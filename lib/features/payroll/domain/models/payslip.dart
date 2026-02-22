class Payslip {
  final String id;
  final String employeeId;
  final String month; // e.g., "January 2024"
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double netSalary;
  final DateTime paidAt;
  final String pdfUrl;

  Payslip({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
    required this.paidAt,
    required this.pdfUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'month': month,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'netSalary': netSalary,
      'paidAt': paidAt.toIso8601String(),
      'pdfUrl': pdfUrl,
    };
  }

  factory Payslip.fromMap(Map<String, dynamic> map) {
    return Payslip(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      month: map['month'] ?? '',
      basicSalary: (map['basicSalary'] ?? 0).toDouble(),
      allowances: (map['allowances'] ?? 0).toDouble(),
      deductions: (map['deductions'] ?? 0).toDouble(),
      netSalary: (map['netSalary'] ?? 0).toDouble(),
      paidAt: DateTime.parse(map['paidAt']),
      pdfUrl: map['pdfUrl'] ?? '',
    );
  }
}
