import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxcode_payroll/features/loan/domain/models/loan_request.dart';

class LoanProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LoanAdvanceRequest> _requests = [];
  bool _isLoading = false;

  List<LoanAdvanceRequest> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;

  Future<void> fetchRequests(String employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('loans')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('createdAt', descending: true)
          .get();
      _requests = snapshot.docs
          .map((doc) => LoanAdvanceRequest.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching loans: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitRequest(LoanAdvanceRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('loans').doc(request.id).set(request.toMap());
      _requests.insert(0, request);
    } catch (e) {
      debugPrint("Error submitting loan: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestAdvance({
    required String employeeId,
    required double amount,
    required int tenureMonths,
  }) async {
    final id = _firestore.collection('loans').doc().id;
    final request = LoanAdvanceRequest(
      id: id,
      employeeId: employeeId,
      amount: amount,
      tenureMonths: tenureMonths,
      emiAmount: amount / tenureMonths,
      reason: 'Advance request',
      createdAt: DateTime.now(),
    );
    await submitRequest(request);
  }

  Future<void> recordRepayment({
    required String loanId,
    required double amount,
    required DateTime paidAt,
  }) async {
    await _firestore.collection('loans').doc(loanId).update({
      'lastPaidAt': paidAt.toIso8601String(),
      'outstanding': FieldValue.increment(-amount),
    });
  }
}
