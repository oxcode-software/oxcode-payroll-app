class ShiftAssignment {
  final String id;
  final String employeeId;
  final String shiftName; // e.g., "Morning", "Night", "General"
  final String startTime; // e.g., "09:00"
  final String endTime; // e.g., "18:00"
  final DateTime date;
  final String? location; // e.g., "Office A", "Remote"

  ShiftAssignment({
    required this.id,
    required this.employeeId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'shiftName': shiftName,
      'startTime': startTime,
      'endTime': endTime,
      'date': date.toIso8601String(),
      'location': location,
    };
  }

  factory ShiftAssignment.fromMap(Map<String, dynamic> map) {
    return ShiftAssignment(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      shiftName: map['shiftName'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      date: DateTime.parse(map['date']),
      location: map['location'],
    );
  }
}
