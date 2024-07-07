class ServiceCenter {
  final String id;
  final String name;
  final String logoUrl;
  final String email;
  final String phone;
  final String address; // New field for the service center's address
  final double latitude;
  final double longitude;
  final DateTime regTime;

  ServiceCenter({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.email,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.regTime,
  });

  ServiceCenter.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        name = data['name'] ?? "nil",
        logoUrl = data['logoUrl'] ?? "nil",
        email = data['email'] ?? "nil",
        phone = data['phone'] ?? "nil",
        address = data['address'] ?? "nil",
        latitude = data['lat'] ?? 0.0,
        longitude = data['long'] ?? 0.0,
        regTime =
            data['regTime'] != null ? data['regTime'].toDate() : DateTime.now();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'email': email,
      'phone': phone,
      'address': address,
      'lat': latitude,
      'long': longitude,
      'regTime': regTime,
    };
    return map;
  }
}
