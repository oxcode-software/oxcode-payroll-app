enum EmploymentType { fullTime, partTime, contract }

enum EmployeeStatus { active, probation, inactive }

class EmployeeModel {
  final String id;
  final String name;
  final String designation;
  final String department;
  final String email;
  final String phone;
  final String photoUrl;
  final DateTime joiningDate;
  final EmploymentType employmentType;
  final EmployeeStatus status;
  final String? branchId;
  final Map<String, String> documents; // Document Type -> URL

  EmployeeModel({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.joiningDate,
    required this.employmentType,
    required this.status,
    this.branchId,
    this.documents = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'department': department,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'joiningDate': joiningDate.toIso8601String(),
      'employmentType': employmentType.name,
      'status': status.name,
      'branchId': branchId,
      'documents': documents,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      designation: map['designation'] ?? '',
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      joiningDate: DateTime.parse(map['joiningDate']),
      employmentType: EmploymentType.values.firstWhere(
        (e) => e.name == map['employmentType'],
      ),
      status: EmployeeStatus.values.firstWhere((e) => e.name == map['status']),
      branchId: map['branchId'],
      documents: Map<String, String>.from(map['documents'] ?? {}),
    );
  }
}
