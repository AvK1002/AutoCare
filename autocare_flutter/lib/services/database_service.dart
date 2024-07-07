import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/reading.dart';
import 'firestore_service.dart';

class DatabaseService with ListenableServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;

  DeviceReading? get node => _node;

  final _firestoreService = locator<FirestoreService>();
  String? _vehicleId;

  void setVehicleId(String? id) {
    log.i("Set vehicle id: $_vehicleId");
    _vehicleId = id;
  }

  int _lastKm = 0;

  void setKm(int km) {
    if (_vehicleId != null) {
      if (_lastKm != km) {
        // log.i("Set KM: $km");
        int value = (km - _lastKm);
        // log.i(value);
        _lastKm = km;
        if (value > 0) {
          _firestoreService.setVehicleKm(_vehicleId!, value);
        }
      }
    }
  }

  void setupNodeListening() {
    DatabaseReference starCountRef =
        _db.ref('/devices/JRrKAx7nRIciWujByyqbeOUn45T2/reading');
    starCountRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        try {
          dynamic data = event.snapshot.value;
          if (data is Map<dynamic, dynamic>) {
            _node = DeviceReading.fromMap(data);
            log.v(_node?.lastSeen);
            notifyListeners();
            if (node != null) {
              setKm(node!.encoderValue * 10);
            }
          } else {
            log.e('Data is not a Map<String, dynamic>: $data');
          }
        } catch (e) {
          log.e('Error parsing data: $e');
        }
      }
    });
  }
}
