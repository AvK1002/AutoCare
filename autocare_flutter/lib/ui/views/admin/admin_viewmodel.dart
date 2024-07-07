import 'package:autocare_flutter/app/app.router.dart';
import 'package:autocare_flutter/models/servicecenter.dart';
import 'package:autocare_flutter/services/firestore_service.dart';
import 'package:autocare_flutter/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/service.dart';

class AdminViewModel extends StreamViewModel<ServiceCenter?> {
  final log = getLogger('AdminViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final _firebaseService = locator<FirestoreService>();
  final _userService = locator<UserService>();

  @override
  Stream<ServiceCenter?> get stream =>
      _firebaseService.getServiceCenterStream();

  List<VehicleService> get vehicleServices => _firebaseService.servicesList;

  @override
  List<ListenableServiceMixin> get listenableServices => [_firebaseService];

  void logout() {
    _userService.logout();
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final logoUrlController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  void onModelReady() {
    emailController.text = _userService.user!.email;
  }

  void openVehicleAdding(bool isCar) {
    _firebaseService.setVehicleType(isCar ? "car" : "bike");
    _navigationService.navigateToAddVehicleView(isCar: isCar);
  }

  void openVehicleService(VehicleService service) {
    _firebaseService.setServiceId(service.id);
    _navigationService.navigateToAdminVehicleServiceView(
        service: service, isAdmin: true);
  }

  LatLng? _pickedLocation;

  LatLng? get pickedLocation => _pickedLocation;

  void setPickedLocation(LatLng? location) {
    if (location != null) {
      log.i('Picked Location: ${location.latitude}, ${location.longitude}');
    }
    _pickedLocation = location;
    notifyListeners(); // Notify listeners to update the UI when the location is set
  }

  void addServiceCenter() async {
    // Set isBusy to true to show a loading indicator
    setBusy(true);

    if (_pickedLocation == null) {
      showDialog(title: "Error", description: "Please pick a location!");
      setBusy(false);
      return;
    }

    // Create a ServiceCenter object with the form data
    ServiceCenter newServiceCenter = ServiceCenter(
      id: _userService.user!.id,
      // You may want to generate a unique ID
      name: nameController.text,
      logoUrl: logoUrlController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      latitude: _pickedLocation!.latitude,
      longitude: _pickedLocation!.longitude,
      regTime: DateTime.now(),
      // Set other properties based on your form fields
    );

    // Add the new service center to Firebase
    bool isDone = await _firebaseService.addServiceCenter(newServiceCenter);

    // Set isBusy to false to hide the loading indicator
    setBusy(false);

    // Navigate back or show a success message
    if (isDone) {
      showDialog(
          title: "Done", description: "Service center added successfully!");
    } else {
      showDialog(title: "Error", description: "Error pls try again!");
    }
  }

  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    } else {
      // If the form is not valid, show error messages or perform necessary actions
      return false;
    }
  }

  void showDialog({required String title, required String description}) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
  }
}
