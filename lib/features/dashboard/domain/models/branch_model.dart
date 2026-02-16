class Branch {
  final String id;
  final String name;
  final String location;
  final String address;
  final String? managerId;
  final String? managerName;
  final String contactNumber;
  final String email;
  final List<String> departmentIds;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    this.managerId,
    this.managerName,
    required this.contactNumber,
    required this.email,
    this.departmentIds = const [],
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'managerId': managerId,
      'managerName': managerName,
      'contactNumber': contactNumber,
      'email': email,
      'departmentIds': departmentIds,
      'isActive': isActive,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      address: map['address'] ?? '',
      managerId: map['managerId'],
      managerName: map['managerName'],
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'] ?? '',
      departmentIds: List<String>.from(map['departmentIds'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }
}
