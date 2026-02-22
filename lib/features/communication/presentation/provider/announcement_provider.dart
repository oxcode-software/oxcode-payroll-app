import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxcode_payroll/features/communication/domain/models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  List<Announcement> get announcements => List.unmodifiable(_announcements);
  bool get isLoading => _isLoading;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      _announcements = snapshot.docs
          .map((doc) => Announcement.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<void> listenAnnouncements() async* {
    yield* _firestore
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      _announcements =
          snapshot.docs.map((doc) => Announcement.fromMap(doc.data())).toList();
      notifyListeners();
    });
  }
}
