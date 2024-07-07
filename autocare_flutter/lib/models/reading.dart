class DeviceReading {
  final double aclX;
  final double aclY;
  final double aclZ;
  final int encoderValue;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double lat;
  final double long;
  final double speed;
  final double temp;
  final DateTime lastSeen;

  DeviceReading({
    required this.aclX,
    required this.aclY,
    required this.aclZ,
    required this.encoderValue,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.lat,
    required this.long,
    required this.speed,
    required this.temp,
    required this.lastSeen,
  });

  factory DeviceReading.fromMap(Map<dynamic, dynamic> data) {
    return DeviceReading(
      aclX: (data['acl_x'] ?? 0.0) is double
          ? data['acl_x']
          : double.parse(data['acl_x'] ?? '0.0'),
      aclY: (data['acl_y'] ?? 0.0) is double
          ? data['acl_y']
          : double.parse(data['acl_y'] ?? '0.0'),
      aclZ: (data['acl_z'] ?? 0.0) is double
          ? data['acl_z']
          : double.parse(data['acl_z'] ?? '0.0'),
      encoderValue: data['encoderValue'] ?? 0,
      gyroX: (data['gyro_x'] ?? 0.0) is double
          ? data['gyro_x']
          : double.parse(data['gyro_x'] ?? '0.0'),
      gyroY: (data['gyro_y'] ?? 0.0) is double
          ? data['gyro_y']
          : double.parse(data['gyro_y'] ?? '0.0'),
      gyroZ: (data['gyro_z'] ?? 0.0) is double
          ? data['gyro_z']
          : double.parse(data['gyro_z'] ?? '0.0'),
      lat: (data['lat'] ?? 0.0) is double
          ? data['lat']
          : double.parse(data['lat'] ?? '0.0'),
      long: (data['long'] ?? 0.0) is double
          ? data['long']
          : double.parse(data['long'] ?? '0.0'),
      speed: (data['speed'] ?? 0.0) is double
          ? data['speed']
          : double.parse(data['speed'] ?? '0.0'),
      temp: (data['temp'] ?? 0.0) is double
          ? data['temp']
          : double.parse(data['temp'] ?? '0.0'),
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}
