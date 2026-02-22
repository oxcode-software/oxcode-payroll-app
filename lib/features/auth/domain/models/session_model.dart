enum SessionPlatform { android, ios, web, desktop }

class SessionModel {
  final String id;
  final String userId;
  final SessionPlatform platform;
  final String deviceName;
  final String deviceId;
  final DateTime createdAt;
  final bool revoked;

  SessionModel({
    required this.id,
    required this.userId,
    required this.platform,
    required this.deviceName,
    required this.deviceId,
    required this.createdAt,
    this.revoked = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'platform': platform.name,
        'deviceName': deviceName,
        'deviceId': deviceId,
        'createdAt': createdAt.toIso8601String(),
        'revoked': revoked,
      };

  factory SessionModel.fromMap(Map<String, dynamic> map) => SessionModel(
        id: map['id'],
        userId: map['userId'],
        platform: SessionPlatform.values.firstWhere(
          (e) => e.name == map['platform'],
          orElse: () => SessionPlatform.android,
        ),
        deviceName: map['deviceName'],
        deviceId: map['deviceId'],
        createdAt: DateTime.parse(map['createdAt']),
        revoked: map['revoked'] ?? false,
      );
}
