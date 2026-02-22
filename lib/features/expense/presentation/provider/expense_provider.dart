import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxcode_payroll/features/expense/domain/models/expense_claim.dart';
import 'package:oxcode_payroll/general/services/storage_service.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = StorageService();
  List<ExpenseClaim> _claims = [];
  bool _isLoading = false;

  List<ExpenseClaim> get claims => List.unmodifiable(_claims);
  bool get isLoading => _isLoading;

  Future<void> fetchClaims(String employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('expenses')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('createdAt', descending: true)
          .get();
      _claims = snapshot.docs
          .map((doc) => ExpenseClaim.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching expenses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitClaim(ExpenseClaim claim) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('expenses').doc(claim.id).set(claim.toMap());
      _claims.insert(0, claim);
    } catch (e) {
      debugPrint("Error submitting expense: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitClaimWithReceipt(
    ExpenseClaim claim, {
    File? receiptFile,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      String? receiptUrl = claim.receiptUrl;
      if (receiptFile != null) {
        receiptUrl = await _storage.uploadFile(
          path: 'expenses/${claim.employeeId}/${claim.id}.jpg',
          file: receiptFile,
        );
      }
      await _firestore.collection('expenses').doc(claim.id).set({
        ...claim.toMap(),
        'receiptUrl': receiptUrl,
      });
      _claims.insert(0, claim);
    } catch (e) {
      debugPrint("Error submitting expense: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
