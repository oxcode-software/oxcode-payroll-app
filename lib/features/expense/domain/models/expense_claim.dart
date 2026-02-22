enum ExpenseCategory { travel, food, lodging, medical, miscellaneous }

enum ExpenseStatus { pending, approved, rejected }

class ExpenseClaim {
  final String id;
  final String employeeId;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final String? receiptUrl;
  final ExpenseStatus status;
  final DateTime createdAt;

  ExpenseClaim({
    required this.id,
    required this.employeeId,
    required this.amount,
    required this.category,
    required this.description,
    this.receiptUrl,
    this.status = ExpenseStatus.pending,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'amount': amount,
      'category': category.name,
      'description': description,
      'receiptUrl': receiptUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ExpenseClaim.fromMap(Map<String, dynamic> map) {
    return ExpenseClaim(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == map['category'],
      ),
      description: map['description'] ?? '',
      receiptUrl: map['receiptUrl'],
      status: ExpenseStatus.values.firstWhere((e) => e.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
