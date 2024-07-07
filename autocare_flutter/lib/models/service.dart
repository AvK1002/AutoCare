class VehicleService {
  String id;
  final String problemDescription;
  final DateTime date;
  final String serviceCenterId;
  final String serviceCenterName;
  final String userId;
  final String userName;
  final String vehicleId;
  final List<Repair> repairs;
  final double totalCost; // New field for total cost
  final bool isCompleted; // New field for total cost

  VehicleService({
    required this.id,
    required this.problemDescription,
    required this.date,
    required this.serviceCenterId,
    required this.serviceCenterName,
    required this.userId,
    required this.userName,
    required this.vehicleId,
    required this.repairs,
    required this.totalCost,
    required this.isCompleted,
  });

  factory VehicleService.fromMap(Map<String, dynamic> data) {
    return VehicleService(
      id: data['id'] ?? "",
      problemDescription: data['problemDescription'] ?? "",
      date: data['date'] != null ? data['date'].toDate() : DateTime.now(),
      serviceCenterId: data['serviceCenterId'] ?? "",
      serviceCenterName: data['serviceCenterName'] ?? "",
      userId: data['userId'] ?? "",
      userName: data['userName'] ?? "",
      vehicleId: data['vehicleId'] ?? "",
      repairs: List<Repair>.from(
        (data['repairs'] ?? []).map((repairData) => Repair.fromMap(repairData)),
      ),
      totalCost: data['totalCost'] ?? 0.0,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problemDescription': problemDescription,
      'date': date,
      'serviceCenterId': serviceCenterId,
      'serviceCenterName': serviceCenterName,
      'userId': userId,
      'userName': userName,
      'vehicleId': vehicleId,
      'repairs': repairs.map((repair) => repair.toJson()).toList(),
      'totalCost': totalCost,
      'isCompleted': isCompleted,
    };
  }
}

class Repair {
  final String work;
  final String part;
  final String serialNumber;
  final String imageLink;
  final double laborHour;
  final double cost;

  Repair({
    required this.work,
    required this.part,
    required this.serialNumber,
    required this.imageLink,
    required this.laborHour,
    required this.cost,
  });

  factory Repair.fromMap(Map<String, dynamic> data) {
    return Repair(
      work: data['work'] ?? "",
      part: data['part'] ?? "",
      serialNumber: data['serialNumber'] ?? "",
      imageLink: data['imageLink'] ?? "",
      laborHour: data['laborHour'] ?? 0.0,
      cost: data['cost'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'work': work,
      'part': part,
      'serialNumber': serialNumber,
      'imageLink': imageLink,
      'laborHour': laborHour,
      'cost': cost,
    };
  }
}
