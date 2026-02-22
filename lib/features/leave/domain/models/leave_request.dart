enum LeaveStatus { pending, approved, rejected, cancelled }

enum LeaveType { sick, casual, earned, unpaid }

class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final LeaveType type;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final LeaveStatus status;
  final List<String> documentUrls;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    this.status = LeaveStatus.pending,
    this.documentUrls = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'type': type.name,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'reason': reason,
      'status': status.name,
      'documentUrls': documentUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      type: LeaveType.values.firstWhere((e) => e.name == map['type']),
      fromDate: DateTime.parse(map['fromDate']),
      toDate: DateTime.parse(map['toDate']),
      reason: map['reason'] ?? '',
      status: LeaveStatus.values.firstWhere((e) => e.name == map['status']),
      documentUrls: List<String>.from(map['documentUrls'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  LeaveRequest copyWith({
    LeaveStatus? status,
    List<String>? documentUrls,
  }) {
    return LeaveRequest(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
      reason: reason,
      status: status ?? this.status,
      documentUrls: documentUrls ?? this.documentUrls,
      createdAt: createdAt,
    );
  }
}
