class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? type; // e.g., "Policy", "Holiday", "Urgent"

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      type: map['type'],
    );
  }
}
