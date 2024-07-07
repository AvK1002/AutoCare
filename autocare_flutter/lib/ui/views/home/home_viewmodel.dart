import 'package:autocare_flutter/app/app.bottomsheets.dart';
import 'package:autocare_flutter/app/app.dialogs.dart';
import 'package:autocare_flutter/app/app.locator.dart';
import 'package:autocare_flutter/app/app.router.dart';
import 'package:autocare_flutter/models/appuser.dart';
import 'package:autocare_flutter/models/service.dart';
import 'package:autocare_flutter/services/database_service.dart';
import 'package:autocare_flutter/services/user_service.dart';
import 'package:autocare_flutter/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.logger.dart';
import '../../../models/reading.dart';
import '../../../models/vehicle.dart';
import '../../../services/firestore_service.dart';

class HomeViewModel extends StreamViewModel<List<Vehicle>> {
  final log = getLogger('HomeViewModel');

  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _firebaseService = locator<FirestoreService>();
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();

  DeviceReading? get node => _dbService.node;

  List<VehicleService> get vehicleServices => _firebaseService.servicesList;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_dbService, _firebaseService];

  AppUser? get user => _userService.user;

  @override
  Stream<List<Vehicle>> get stream => _firebaseService.getVehiclesForUser();

  void logout() {
    _userService.logout();
  }

  @override
  void onData(List<Vehicle>? data) {
    if (data != null && data.isNotEmpty) {
      _dbService.setVehicleId(data[0].id);
    }
    super.onData(data);
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  void bookService(VehicleService? service) async {
    if (service != null) {
      String? docId = await _firebaseService.generateServiceDocumentId();
      if (docId == null) {
        showDialog(title: "Error", description: "Error pls try again!");
        return;
      }

      service.id = docId;
      log.i(service.problemDescription);

      bool isDone = await _firebaseService.addService(service);

      // Set isBusy to false to hide the loading indicator
      setBusy(false);

      // Navigate back or show a success message
      if (isDone) {
        showDialog(title: "Done", description: "Service booked successfully!");
      } else {
        showDialog(title: "Error", description: "Error pls try again!");
      }
    }
  }

  void showDialog({required String title, required String description}) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
  }

  void openVehicleService(VehicleService service) {
    _firebaseService.setServiceId(service.id);
    _navigationService.navigateToAdminVehicleServiceView(
        service: service, isAdmin: false);
  }

  @override
  void dispose() {
    _dbService.setVehicleId(null);
    super.dispose();
  }
}
