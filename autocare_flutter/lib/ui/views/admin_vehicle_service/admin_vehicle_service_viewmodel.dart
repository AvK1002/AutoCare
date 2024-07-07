import 'package:autocare_flutter/models/appuser.dart';
import 'package:autocare_flutter/models/service.dart';
import 'package:autocare_flutter/models/vehicle.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/firestore_service.dart';
import '../../../services/user_service.dart';

class AdminVehicleServiceViewModel extends StreamViewModel<VehicleService?> {
  final log = getLogger('AdminVehicleServiceViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final _firebaseService = locator<FirestoreService>();
  final _userService = locator<UserService>();

  late VehicleService _initService;

  Vehicle? vehicle;
  AppUser? customer;

  void onModelReady(VehicleService service, bool isAdmin) async {
    _initService = service;
    setBusy(true);
    vehicle = await _firebaseService.getVehicle(_initService.vehicleId);
    if (vehicle != null) {
      _damage = vehicle!.damagePoints;
    }
    customer = await _firebaseService.getUser(
        userId: !isAdmin ? _initService.serviceCenterId : _initService.userId);
    setBusy(false);
  }

  @override
  Stream<VehicleService?> get stream =>
      _firebaseService.getVehicleServiceStream();

  void onAddRepair(Repair repair) async {
    // Call the addRepairToService method
    bool success =
        await _firebaseService.addRepairToService(_initService.id, repair);
    bool success2 =
        await _firebaseService.setServiceCost(_initService.id, repair.cost);

    if (repair.serialNumber == 'nil' && repair.part != "nil") {
      setDamage(1);
    }

    if (success && success2) {
      log.i('Repair added to service successfully');
      showDialog(title: "Success", description: "Repair data added!");
    } else {
      showDialog(title: "Error", description: "Please try again!");
      log.e('Failed to add repair to service');
    }
  }

  int _damage = 0;

  int get damage => _damage;

  void setDamage(int value) {
    _firebaseService.setVehicleDamage(_initService.vehicleId, value);
  }

  void showDialog({required String title, required String description}) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
  }

  void setCompleted() {
    _firebaseService.setServiceComplete(_initService.id, true);
    // _firebaseService.setVehicleServices(_initService.vehicleId, 1);
  }
}
