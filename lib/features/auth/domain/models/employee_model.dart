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
  final String? employeeCode;
  final String companyCode;
  final String? companyName;
  final bool isBiometricEnabled;
  final Map<String, String> documents; // Document Type -> URL
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

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
    this.employeeCode,
    required this.companyCode,
    this.companyName,
    this.isBiometricEnabled = false,
    this.documents = const {},
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.emergencyContactName,
    this.emergencyContactPhone,
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
      'employeeCode': employeeCode,
      'companyCode': companyCode,
      'companyName': companyName,
      'isBiometricEnabled': isBiometricEnabled,
      'documents': documents,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
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
      companyCode: map['companyCode'] ?? '',
      companyName: map['companyName'],
      isBiometricEnabled: map['isBiometricEnabled'] ?? false,
      documents: Map<String, String>.from(map['documents'] ?? {}),
      bankName: map['bankName'],
      accountNumber: map['accountNumber'],
      ifscCode: map['ifscCode'],
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      employeeCode: map['employeeCode'],
    );
  }
}
