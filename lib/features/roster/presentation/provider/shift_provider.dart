import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxcode_payroll/features/roster/domain/models/shift_assignment.dart';

class ShiftProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ShiftAssignment> _shifts = [];
  bool _isLoading = false;

  List<ShiftAssignment> get shifts => List.unmodifiable(_shifts);
  bool get isLoading => _isLoading;

  Future<void> fetchWeeklyRoster(String employeeId, DateTime start) async {
    _isLoading = true;
    notifyListeners();
    try {
      final end = start.add(const Duration(days: 7));
      final snapshot = await _firestore
          .collection('rosters')
          .where('employeeId', isEqualTo: employeeId)
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThanOrEqualTo: end.toIso8601String())
          .orderBy('date')
          .get();
      _shifts = snapshot.docs
          .map((doc) => ShiftAssignment.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching roster: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestSwap({
    required String shiftId,
    required String requesterId,
    required String targetUserId,
  }) async {
    final id = _firestore.collection('shift_swaps').doc().id;
    await _firestore.collection('shift_swaps').doc(id).set({
      'id': id,
      'shiftId': shiftId,
      'requesterId': requesterId,
      'targetUserId': targetUserId,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<double> overtimeHours(String employeeId) {
    return _firestore
        .collection('attendance')
        .where('employeeId', isEqualTo: employeeId)
        .snapshots()
        .map((snap) {
      double total = 0;
      for (final doc in snap.docs) {
        total += (doc.data()['overtimeHours'] ?? 0).toDouble();
      }
      return total;
    });
  }
}
