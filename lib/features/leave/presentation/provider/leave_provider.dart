import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxcode_payroll/features/leave/domain/models/leave_request.dart';

class LeaveProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LeaveRequest> _leaves = [];
  bool _isLoading = false;

  List<LeaveRequest> get leaves => List.unmodifiable(_leaves);
  bool get isLoading => _isLoading;

  Future<void> fetchLeaves(String employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('leaves')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('createdAt', descending: true)
          .get();
      _leaves = snapshot.docs
          .map((doc) => LeaveRequest.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching leaves: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyLeave(LeaveRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('leaves')
          .doc(request.id)
          .set(request.toMap());
      _leaves.insert(0, request);
    } catch (e) {
      debugPrint("Error applying leave: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelLeave(String leaveId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('leaves').doc(leaveId).update({
        'status': LeaveStatus.cancelled.name,
      });
      _leaves = _leaves
          .map((leave) => leave.id == leaveId
              ? leave.copyWith(status: LeaveStatus.cancelled)
              : leave)
          .toList();
    } catch (e) {
      debugPrint("Error cancelling leave: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
