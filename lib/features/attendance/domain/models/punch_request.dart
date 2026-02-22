enum PunchType { gps, selfie, qr, wifi, kiosk }

class PunchRequest {
  final String id;
  final String employeeId;
  final PunchType type;
  final DateTime createdAt;
  final double? lat;
  final double? lng;
  final String? selfieUrl;
  final String? qrCode;
  final String? wifiBssid;
  final bool checkIn;

  PunchRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.createdAt,
    required this.checkIn,
    this.lat,
    this.lng,
    this.selfieUrl,
    this.qrCode,
    this.wifiBssid,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'type': type.name,
        'createdAt': createdAt.toIso8601String(),
        'lat': lat,
        'lng': lng,
        'selfieUrl': selfieUrl,
        'qrCode': qrCode,
        'wifiBssid': wifiBssid,
        'checkIn': checkIn,
      };

  factory PunchRequest.fromMap(Map<String, dynamic> map) => PunchRequest(
        id: map['id'],
        employeeId: map['employeeId'],
        type: PunchType.values.firstWhere((e) => e.name == map['type']),
        createdAt: DateTime.parse(map['createdAt']),
        lat: (map['lat'] as num?)?.toDouble(),
        lng: (map['lng'] as num?)?.toDouble(),
        selfieUrl: map['selfieUrl'],
        qrCode: map['qrCode'],
        wifiBssid: map['wifiBssid'],
        checkIn: map['checkIn'] ?? true,
      );
}
