class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final int noOfServices;
  final String color;
  final String licensePlate;
  final String ownerEmail;
  final int kilometers;
  final int damagePoints;
  final String engineNumber;
  final String chassisNumber;
  final String vehicleType; // New field
  final DateTime regTime;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.noOfServices,
    required this.color,
    required this.licensePlate,
    required this.ownerEmail,
    required this.kilometers,
    required this.damagePoints,
    required this.engineNumber,
    required this.chassisNumber,
    required this.vehicleType,
    required this.regTime,
  });

  // Create a Vehicle instance from a map
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] ?? "",
      brand: map['brand'] ?? "",
      model: map['model'] ?? "",
      year: map['year'] ?? 0,
      noOfServices: map['noOfServices'] != null
          ? int.parse(map['noOfServices'].toString())
          : 0,
      color: map['color'] ?? "",
      licensePlate: map['licensePlate'] ?? "",
      ownerEmail: map['ownerEmail'] ?? "",
      kilometers: map['kilometers'] ?? 0,
      damagePoints: map['damagePoints'] ?? "",
      engineNumber: map['engineNumber'] ?? "",
      chassisNumber: map['chassisNumber'] ?? "",
      vehicleType: map['vehicleType'] ?? "",
      regTime:
          map['regTime'] != null ? map['regTime'].toDate() : DateTime.now(),
    );
  }

  // Convert the Vehicle instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'noOfServices': noOfServices,
      'color': color,
      'licensePlate': licensePlate,
      'ownerEmail': ownerEmail,
      'kilometers': kilometers,
      'damagePoints': damagePoints,
      'engineNumber': engineNumber,
      'chassisNumber': chassisNumber,
      'vehicleType': vehicleType,
      'regTime': regTime,
    };
  }

  double calculateFitnessLevel(int currentYear) {
    // Calculate the fitness penalty based on the difference between the current year and the vehicle's manufacturing year
    // If the number of services is less than the difference, no penalty is applied; otherwise, penalize based on the excess services
    double servicePenalty = (currentYear - year) < noOfServices
        ? 0.0
        : ((currentYear - year) - noOfServices) * 3;

    // Calculate the overall fitness level using a weighted formula:
    // - Penalize based on the difference in manufacturing years (scaled by 0.1)
    //   and apply the service penalty
    // - Penalize based on kilometers traveled (scaled by 0.0001)
    // - Penalize based on damage points (scaled by 2.0)
    double fitness = 100.0 -
        ((currentYear - year) * 0.1 * servicePenalty) -
        (kilometers * 0.0001) -
        (damagePoints * 2.0);

    // Ensure the fitness level is within the valid range of 0 to 100
    return fitness.clamp(0.0, 100.0);
  }
}
