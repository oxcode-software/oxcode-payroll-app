enum RegularizationType { missedPunch, timeCorrection }

class RegularizationRequest {
  final String id;
  final String employeeId;
  final RegularizationType type;
  final DateTime forDate;
  final String reason;
  final String status;

  RegularizationRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.forDate,
    required this.reason,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'type': type.name,
        'forDate': forDate.toIso8601String(),
        'reason': reason,
        'status': status,
      };

  factory RegularizationRequest.fromMap(Map<String, dynamic> map) =>
      RegularizationRequest(
        id: map['id'],
        employeeId: map['employeeId'],
        type: RegularizationType.values
            .firstWhere((e) => e.name == map['type']),
        forDate: DateTime.parse(map['forDate']),
        reason: map['reason'],
        status: map['status'] ?? 'pending',
      );
}
