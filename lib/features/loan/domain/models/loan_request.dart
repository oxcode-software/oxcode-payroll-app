enum LoanStatus { pending, approved, rejected, active, completed }

class LoanAdvanceRequest {
  final String id;
  final String employeeId;
  final double amount;
  final int tenureMonths;
  final double emiAmount;
  final String reason;
  final LoanStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final List<EMIEntry> repaymentSchedule;

  LoanAdvanceRequest({
    required this.id,
    required this.employeeId,
    required this.amount,
    required this.tenureMonths,
    required this.emiAmount,
    required this.reason,
    this.status = LoanStatus.pending,
    required this.createdAt,
    this.approvedAt,
    this.repaymentSchedule = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'amount': amount,
      'tenureMonths': tenureMonths,
      'emiAmount': emiAmount,
      'reason': reason,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'repaymentSchedule': repaymentSchedule.map((e) => e.toMap()).toList(),
    };
  }

  factory LoanAdvanceRequest.fromMap(Map<String, dynamic> map) {
    return LoanAdvanceRequest(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      tenureMonths: map['tenureMonths'] ?? 0,
      emiAmount: (map['emiAmount'] ?? 0).toDouble(),
      reason: map['reason'] ?? '',
      status: LoanStatus.values.firstWhere((e) => e.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      approvedAt: map['approvedAt'] != null
          ? DateTime.parse(map['approvedAt'])
          : null,
      repaymentSchedule: (map['repaymentSchedule'] as List? ?? [])
          .map((e) => EMIEntry.fromMap(e))
          .toList(),
    );
  }
}

class EMIEntry {
  final String month;
  final double amount;
  final bool isPaid;

  EMIEntry({required this.month, required this.amount, this.isPaid = false});

  Map<String, dynamic> toMap() => {
    'month': month,
    'amount': amount,
    'isPaid': isPaid,
  };

  factory EMIEntry.fromMap(Map<String, dynamic> map) {
    return EMIEntry(
      month: map['month'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
    );
  }
}
