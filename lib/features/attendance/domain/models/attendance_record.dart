enum AttendanceStatus { present, absent, late, earlyExit, halfDay }

class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime? punchIn;
  final DateTime? punchOut;
  final String? checkInSelfieUrl;
  final String? checkOutSelfieUrl;
  final AttendanceStatus status;
  final String? correctionReason;
  final bool isApproved;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.punchIn,
    this.punchOut,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
    required this.status,
    this.correctionReason,
    this.isApproved = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'date': date.toIso8601String(),
      'punchIn': punchIn?.toIso8601String(),
      'punchOut': punchOut?.toIso8601String(),
      'checkInSelfieUrl': checkInSelfieUrl,
      'checkOutSelfieUrl': checkOutSelfieUrl,
      'status': status.name,
      'correctionReason': correctionReason,
      'isApproved': isApproved,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      date: DateTime.parse(map['date']),
      punchIn: map['punchIn'] != null ? DateTime.parse(map['punchIn']) : null,
      punchOut: map['punchOut'] != null
          ? DateTime.parse(map['punchOut'])
          : null,
      checkInSelfieUrl: map['checkInSelfieUrl'],
      checkOutSelfieUrl: map['checkOutSelfieUrl'],
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      correctionReason: map['correctionReason'],
      isApproved: map['isApproved'] ?? true,
    );
  }
}
