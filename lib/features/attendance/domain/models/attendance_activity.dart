import 'package:flutter/material.dart';

enum ActivityType { punchIn, punchOut, startBreak, endBreak }

class AttendanceActivity {
  final ActivityType type;
  final DateTime time;
  final String? selfiePath;
  final Duration? duration; // Used for breaks

  AttendanceActivity({
    required this.type,
    required this.time,
    this.selfiePath,
    this.duration,
  });

  String get label {
    switch (type) {
      case ActivityType.punchIn:
        return "Punch In";
      case ActivityType.punchOut:
        return "Punch Out";
      case ActivityType.startBreak:
        return "Break Started";
      case ActivityType.endBreak:
        return "Break Ended";
    }
  }

  IconData get icon {
    switch (type) {
      case ActivityType.punchIn:
        return Icons.login;
      case ActivityType.punchOut:
        return Icons.logout;
      case ActivityType.startBreak:
        return Icons.coffee;
      case ActivityType.endBreak:
        return Icons.work_history;
    }
  }
}
