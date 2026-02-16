import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/employee_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  EmployeeModel? _employeeProfile;
  bool _isLoading = false;

  User? get user => _user;
  EmployeeModel? get employeeProfile => _employeeProfile;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _fetchProfile(user.uid);
      } else {
        _employeeProfile = null;
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
      // Profile will be fetched by the listener
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
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
      );

      await _firestore
          .collection('employees')
          .doc(uid)
          .set(newEmployee.toMap());
      await credential.user?.updateDisplayName(name);

      _user = _auth.currentUser;
      _employeeProfile = newEmployee;
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
