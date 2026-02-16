import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:oxcode_payroll/features/attendance/domain/models/attendance_activity.dart';
import 'package:oxcode_payroll/features/attendance/domain/models/attendance_record.dart';
import 'package:oxcode_payroll/general/services/notification_service.dart';
import 'package:intl/intl.dart';

class AttendanceProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isCheckedIn = false;
  bool _isOnBreak = false;
  DateTime? _checkInTime;
  DateTime? _breakStartTime;
  Duration _workedDuration = Duration.zero;
  Duration _totalBreakDuration = Duration.zero;
  Timer? _timer;
  String? _selfiePath;
  String? _currentRecordId;

  final List<AttendanceActivity> _activities = [];

  // Reminder Settings
  bool _punchInReminder = false;
  TimeOfDay _punchInTimeSet = const TimeOfDay(hour: 9, minute: 0);
  bool _punchOutReminder = false;
  TimeOfDay _punchOutTimeSet = const TimeOfDay(hour: 18, minute: 0);

  bool get isCheckedIn => _isCheckedIn;
  bool get isOnBreak => _isOnBreak;
  String? get selfiePath => _selfiePath;
  List<AttendanceActivity> get activities => List.unmodifiable(_activities);

  bool get punchInReminder => _punchInReminder;
  TimeOfDay get punchInTimeSet => _punchInTimeSet;
  bool get punchOutReminder => _punchOutReminder;
  TimeOfDay get punchOutTimeSet => _punchOutTimeSet;

  final _notificationService = NotificationService();

  Future<void> init(String employeeId) async {
    await fetchTodayRecord(employeeId);
  }

  Future<void> fetchTodayRecord(String employeeId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docId = "${employeeId}_$today";

    try {
      final doc = await _firestore.collection('attendance').doc(docId).get();
      if (doc.exists) {
        final record = AttendanceRecord.fromMap(doc.data()!);
        _isCheckedIn = record.punchIn != null && record.punchOut == null;
        _checkInTime = record.punchIn;
        _currentRecordId = docId;

        if (_isCheckedIn) {
          _startTimer();
        }

        // Populate activities if needed (assuming activities are stored elsewhere or reconstructed)
        // For now, let's just sync the status
      } else {
        _isCheckedIn = false;
        _checkInTime = null;
        _currentRecordId = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching today's record: $e");
    }
  }

  void updatePunchInReminder(bool enabled, TimeOfDay time) {
    _punchInReminder = enabled;
    _punchInTimeSet = time;
    if (enabled) {
      _notificationService.scheduleAttendanceReminder(
        id: 101,
        title: "Punch In Reminder",
        body: "Time to start your shift! Don't forget to punch in.",
        time: time,
      );
    } else {
      _notificationService.cancelReminder(101);
    }
    notifyListeners();
  }

  void updatePunchOutReminder(bool enabled, TimeOfDay time) {
    _punchOutReminder = enabled;
    _punchOutTimeSet = time;
    if (enabled) {
      _notificationService.scheduleAttendanceReminder(
        id: 102,
        title: "Punch Out Reminder",
        body: "Workday is over! Don't forget to punch out.",
        time: time,
      );
    } else {
      _notificationService.cancelReminder(102);
    }
    notifyListeners();
  }

  String get workingHours {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_workedDuration.inHours);
    final minutes = twoDigits(_workedDuration.inMinutes.remainder(60));
    final seconds = twoDigits(_workedDuration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  double get shiftProgress {
    if (!_isCheckedIn) return 0.0;
    const totalShiftSeconds = 9 * 3600; // 9 AM to 6 PM = 9 hours
    final elapsedSeconds = _workedDuration.inSeconds;
    final progress = elapsedSeconds / totalShiftSeconds;
    return progress.clamp(0.0, 1.0);
  }

  Future<void> toggleAttendance(
    String? imagePath,
    String employeeId,
    String employeeName,
  ) async {
    if (_isCheckedIn) {
      await _checkOut(imagePath, employeeId);
    } else {
      await _checkIn(imagePath, employeeId, employeeName);
    }
  }

  Future<void> _checkIn(
    String? imagePath,
    String employeeId,
    String employeeName,
  ) async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final docId = "${employeeId}_$today";

    final record = AttendanceRecord(
      id: docId,
      employeeId: employeeId,
      employeeName: employeeName,
      date: now,
      punchIn: now,
      checkInSelfieUrl:
          imagePath, // In a real app, this would be a cloud storage URL
      status: AttendanceStatus.present,
    );

    try {
      await _firestore.collection('attendance').doc(docId).set(record.toMap());
      _isCheckedIn = true;
      _selfiePath = imagePath;
      _checkInTime = now;
      _currentRecordId = docId;
      _activities.insert(
        0,
        AttendanceActivity(
          type: ActivityType.punchIn,
          time: _checkInTime!,
          selfiePath: imagePath,
        ),
      );
      _startTimer();
      notifyListeners();
    } catch (e) {
      debugPrint("Error checking in: $e");
    }
  }

  Future<void> _checkOut(String? imagePath, String employeeId) async {
    if (_isOnBreak) await endBreak(null);

    final now = DateTime.now();
    try {
      await _firestore.collection('attendance').doc(_currentRecordId).update({
        'punchOut': now.toIso8601String(),
        'checkOutSelfieUrl': imagePath,
      });

      _isCheckedIn = false;
      _activities.insert(
        0,
        AttendanceActivity(
          type: ActivityType.punchOut,
          time: now,
          selfiePath: imagePath,
        ),
      );
      _selfiePath = null;
      _stopTimer();
      notifyListeners();
    } catch (e) {
      debugPrint("Error checking out: $e");
    }
  }

  Future<void> startBreak(String? imagePath) async {
    if (!_isCheckedIn || _isOnBreak) return;
    _isOnBreak = true;
    _breakStartTime = DateTime.now();
    _activities.insert(
      0,
      AttendanceActivity(
        type: ActivityType.startBreak,
        time: _breakStartTime!,
        selfiePath: imagePath,
      ),
    );
    notifyListeners();
  }

  Future<void> endBreak(String? imagePath) async {
    if (!_isCheckedIn || !_isOnBreak) return;
    final breakEndTime = DateTime.now();
    final breakDuration = breakEndTime.difference(_breakStartTime!);
    _totalBreakDuration += breakDuration;
    _isOnBreak = false;
    _activities.insert(
      0,
      AttendanceActivity(
        type: ActivityType.endBreak,
        time: breakEndTime,
        duration: breakDuration,
        selfiePath: imagePath,
      ),
    );
    _breakStartTime = null;
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_checkInTime != null && !_isOnBreak) {
        _workedDuration =
            DateTime.now().difference(_checkInTime!) - _totalBreakDuration;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _totalBreakDuration = Duration.zero;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
