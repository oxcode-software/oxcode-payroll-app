import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/employee_model.dart';
import '../../domain/models/session_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final CollectionReference _sessions = FirebaseFirestore.instance.collection(
    'sessions',
  );

  // MessageCentral (VerifyNow)
  static const String _mcCustomerId = String.fromEnvironment(
    'MC_CUSTOMER_ID',
    defaultValue: 'C-944E26524E124AD',
  );
  static const String _mcAuthToken = String.fromEnvironment(
    'MC_AUTH_TOKEN',
    defaultValue:
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDLTk0NEUyNjUyNEUxMjRBRCIsImlhdCI6MTc3MDA5OTg1MSwiZXhwIjoxOTI3Nzc5ODUxfQ.gwFggGhlDzUb22oUGjojH2gbQF54JJ1B4G9Af835wRpsrBNBmjZ_7jNuJ94DT9fQUrzlGxFFXIfGxNh93Kpjqg',
  );
  static const String _mcBaseUrl =
      'https://cpaas.messagecentral.com/verification/v3';
  String? _mcRequestId;
  String? _mcPhoneNumber;

  User? _user;
  EmployeeModel? _employeeProfile;
  bool _isLoading = false;
  StreamSubscription? _sessionSub;

  User? get user => _user;
  EmployeeModel? get employeeProfile => _employeeProfile;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _fetchProfile(user.uid);
        await _registerSession();
        _startSessionWatch(user.uid);
      } else {
        _employeeProfile = null;
        await _sessionSub?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> _fetchProfile(String uid) async {
    try {
      final doc = await _firestore.collection('employees').doc(uid).get();
      if (doc.exists) {
        _employeeProfile = EmployeeModel.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _registerSession();
      _startSessionWatch(_auth.currentUser?.uid);
      // Profile will be fetched by the listener
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithCompanyCode({
    required String companyCode,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final companySnap = await _firestore
          .collection('companies')
          .where('code', isEqualTo: companyCode)
          .limit(1)
          .get();
      if (companySnap.docs.isEmpty) {
        throw Exception('Invalid company code');
      }
      await login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmployeeCode({
    required String employeeCode,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snap = await _firestore
          .collection('employees')
          .where('employeeCode', isEqualTo: employeeCode)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) {
        throw Exception('Employee code not found');
      }
      final data = snap.docs.first.data() as Map<String, dynamic>;
      final email = data['email'] as String?;
      if (email == null || email.isEmpty) {
        throw Exception('Employee missing email for password login');
      }
      await login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMSG91Otp(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_mcCustomerId.contains('REPLACE_WITH') ||
          _mcAuthToken.contains('REPLACE_WITH')) {
        throw Exception(
          'Configure MessageCentral MC_CUSTOMER_ID and MC_AUTH_TOKEN.',
        );
      }

      final parsed = _parsePhone(phoneNumber);
      final uri = Uri.parse(
        '$_mcBaseUrl/send?countryCode=${parsed.countryCode}'
        '&customerId=$_mcCustomerId'
        '&flowType=SMS'
        '&mobileNumber=${parsed.number}',
      );

      final response = await http.post(
        uri,
        headers: {'authToken': _mcAuthToken},
      );

      final Map<String, dynamic> result =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};
      final status = (result['status'] ?? result['Status'] ?? '').toString();
      final success = response.statusCode == 200 &&
          (status.isEmpty ||
              status.toLowerCase() == 'success' ||
              result['success'] == true);

      if (!success) {
        debugPrint(
            'MC send failed: code=${response.statusCode}, body=${response.body}');
        throw Exception(result['message'] ?? 'Failed to send OTP');
      }

      _mcRequestId =
          result['requestId'] ?? result['request_id'] ?? result['id'];
      _mcPhoneNumber = parsed.e164;
      debugPrint('MC send ok: requestId=$_mcRequestId phone=$_mcPhoneNumber');
    } catch (e) {
      debugPrint('Error sending MessageCentral OTP: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> verifyMSG91Token(String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_mcPhoneNumber == null) {
        throw Exception('Send OTP first');
      }

      final parsed = _parsePhone(_mcPhoneNumber!);
      final query = StringBuffer()
        ..write('countryCode=${parsed.countryCode}')
        ..write('&customerId=$_mcCustomerId')
        ..write('&mobileNumber=${parsed.number}')
        ..write('&code=$otp');
      if (_mcRequestId != null) {
        query.write('&requestId=$_mcRequestId');
      }
      final uri = Uri.parse('$_mcBaseUrl/validate?$query');

      final response = await http.post(
        uri,
        headers: {'authToken': _mcAuthToken},
      );

      final Map<String, dynamic> result =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      final status = (result['status'] ?? result['Status'] ?? '').toString();
      final success = response.statusCode == 200 &&
          (status.isEmpty ||
              status.toLowerCase() == 'success' ||
              result['success'] == true);

      if (!success) {
        debugPrint(
            'MC verify failed: code=${response.statusCode}, body=${response.body}');
        throw Exception(result['message'] ?? 'Verification failed');
      }

      final snapshot = await _firestore
          .collection('employees')
          .where('phone', isEqualTo: _mcPhoneNumber)
          .get();

      debugPrint('MC verify ok for phone=$_mcPhoneNumber');
      return snapshot.docs
          .map(
            (doc) => {'uid': doc.id, 'companyCode': doc.data()['companyCode']},
          )
          .toList();
    } catch (e) {
      debugPrint('Error verifying MessageCentral OTP: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithUid(String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await FirebaseFunctions.instanceFor(
        region: 'us-central1',
      ).httpsCallable('getCustomToken').call({'uid': uid});

      final token = result.data['token'];
      await _auth.signInWithCustomToken(token);
      await _registerSession();
      _startSessionWatch(uid);
    } catch (e) {
      debugPrint('Error logging in with UID: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        // options: const AuthenticationOptions(
        //   stickyAuth: true,
        //   biometricOnly: true,
        // ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: ${e.code}');
      return false;
    }
  }

  Future<void> updateBiometricStatus(bool enabled) async {
    if (_employeeProfile == null) return;

    try {
      await _firestore.collection('employees').doc(_employeeProfile!.id).update(
        {'isBiometricEnabled': enabled},
      );

      _employeeProfile = EmployeeModel(
        id: _employeeProfile!.id,
        name: _employeeProfile!.name,
        designation: _employeeProfile!.designation,
        department: _employeeProfile!.department,
        email: _employeeProfile!.email,
        phone: _employeeProfile!.phone,
        photoUrl: _employeeProfile!.photoUrl,
        joiningDate: _employeeProfile!.joiningDate,
        employmentType: _employeeProfile!.employmentType,
        status: _employeeProfile!.status,
        companyCode: _employeeProfile!.companyCode,
        isBiometricEnabled: enabled,
        branchId: _employeeProfile!.branchId,
        documents: _employeeProfile!.documents,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating biometric status: $e');
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Create initial employee profile in Firestore
      final newEmployee = EmployeeModel(
        id: uid,
        name: name,
        designation: 'New Employee',
        department: 'Operations',
        email: email,
        phone: '',
        photoUrl: '',
        joiningDate: DateTime.now(),
        employmentType: EmploymentType.fullTime,
        status: EmployeeStatus.active,
        companyCode: 'OXCODE', // Default for now, should be passed from UI
      );

      await _firestore
          .collection('employees')
          .doc(uid)
          .set(newEmployee.toMap());
      await credential.user?.updateDisplayName(name);

      _user = _auth.currentUser;
      _employeeProfile = newEmployee;
      await _registerSession();
      _startSessionWatch(uid);
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutAllDevices() async {
    if (_user == null) return;
    final snapshots = await _sessions
        .where('userId', isEqualTo: _user!.uid)
        .get();
    for (final doc in snapshots.docs) {
      await doc.reference.update({'revoked': true});
    }
    await logout();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _employeeProfile = null;
    notifyListeners();
  }

  Future<bool> hasNetwork() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _registerSession() async {
    final current = _auth.currentUser ?? _user;
    if (current == null) return;

    final deviceInfo = DeviceInfoPlugin();
    final baseInfo = await deviceInfo.deviceInfo;
    final data = baseInfo.data;

    final deviceId =
        data['identifierForVendor'] ??
        data['androidId'] ??
        data['deviceId'] ??
        data['id'] ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final deviceName = data['model'] ?? data['device'] ?? 'unknown';

    final session = SessionModel(
      id: _sessions.doc().id,
      userId: current.uid,
      platform: SessionPlatform.android,
      deviceName: deviceName,
      deviceId: deviceId,
      createdAt: DateTime.now(),
    );

    await _sessions.doc(session.id).set(session.toMap());
  }

  void _startSessionWatch(String? uid) {
    _sessionSub?.cancel();
    if (uid == null) return;
    _sessionSub = _sessions
        .where('userId', isEqualTo: uid)
        .where('revoked', isEqualTo: true)
        .snapshots()
        .listen((event) async {
          if (event.docs.isNotEmpty) {
            await _auth.signOut();
          }
        });
  }

  _ParsedPhone _parsePhone(String input) {
    String digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    String country = '91';
    if (digits.startsWith('91') && digits.length > 10) {
      country = '91';
      digits = digits.substring(2);
    }
    if (digits.length > 10) {
      country = digits.substring(0, digits.length - 10);
      digits = digits.substring(digits.length - 10);
    }
    return _ParsedPhone(
      countryCode: country,
      number: digits,
      e164: '+$country$digits',
    );
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }
}

class _ParsedPhone {
  final String countryCode;
  final String number;
  final String e164;
  _ParsedPhone({
    required this.countryCode,
    required this.number,
    required this.e164,
  });
}
