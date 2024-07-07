import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/vehicle.dart';
import '../../../services/firestore_service.dart';

class AddVehicleViewModel extends BaseViewModel {
  final log = getLogger('AddVehicleViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _firebaseService = locator<FirestoreService>();

  late bool isCar;

  void onModelReady(bool isCarIn) {
    isCar = isCarIn;
    log.i(isCar);
  }

  final formKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final licensePlateController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final servicesController = TextEditingController();
  final kilometersController = TextEditingController();
  final damagePointsController = TextEditingController();
  final engineNumberController = TextEditingController();
  final chassisNumberController = TextEditingController();

  void addVehicle() async {
    // Set isBusy to true to show a loading indicator
    setBusy(true);

    String? docId = await _firebaseService.generateVehicleDocumentId();
    if (docId == null) {
      showDialog(title: "Error", description: "Error pls try again!");
      return;
    }

    log.i(docId);
    // log.i(isCar);

    // Create a Vehicle object with the form data
    Vehicle newVehicle = Vehicle(
      id: docId,
      // You may want to generate a unique ID
      brand: brandController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      color: colorController.text,
      licensePlate: licensePlateController.text,
      ownerEmail: ownerEmailController.text,
      kilometers: int.parse(kilometersController.text),
      noOfServices: int.parse(servicesController.text),
      damagePoints: int.parse(damagePointsController.text),
      engineNumber: engineNumberController.text,
      chassisNumber: chassisNumberController.text,
      vehicleType: _firebaseService.vehicleType,
      regTime: DateTime.now(),
      // Add other properties based on your form fields
    );

    // Add the new vehicle to Firebase
    bool isDone = await _firebaseService.addVehicle(newVehicle);

    // Set isBusy to false to hide the loading indicator
    setBusy(false);

    // Navigate back or show a success message
    // Navigate back or show a success message
    if (isDone) {
      _navigationService.back();
      showDialog(title: "Done", description: "Vehicle added successfully!");
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
