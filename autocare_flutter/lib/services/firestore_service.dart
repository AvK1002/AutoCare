import 'package:autocare_flutter/models/service.dart';
import 'package:autocare_flutter/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/appuser.dart';
import '../models/servicecenter.dart';

class FirestoreService with ListenableServiceMixin {
  final log = getLogger('FirestoreApi');
  final _authenticationService = locator<FirebaseAuthenticationService>();

  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection("users");

  Future<bool> createUser({required AppUser user, required keyword}) async {
    log.i('user:$user');
    try {
      final userDocument = _usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword), SetOptions(merge: true));
      log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return AppUser.fromMap(userData! as Map<String, dynamic>);
    } else {
      log.e("Error no user");
      return null;
    }
  }

  Future<List<AppUser>> searchUsers(String keyword) async {
    log.i("searching for $keyword");
    final query = _usersCollection
        .where('keyword', arrayContains: keyword.toLowerCase())
        .limit(5);

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> updateLocation(double lat, double long, String place) async {
    log.i('Location update');
    try {
      final userDocument =
      _usersCollection.doc(_authenticationService.currentUser!.uid);
      await userDocument.update({
        "lat": lat,
        "long": long,
        "place": place,
      });
      // log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  //============================================================
  final CollectionReference _serviceCenterCollection =
  FirebaseFirestore.instance.collection("service_centers");

  Stream<ServiceCenter?> getServiceCenterStream() {
    // Replace 'serviceCenters' with the actual name of your collection in Firestore
    return _serviceCenterCollection
        .where('id', isEqualTo: _authenticationService.currentUser?.uid ?? "")
        .snapshots()
        .map(
          (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // If there is a matching document, return the ServiceCenter
          return ServiceCenter.fromMap(
              snapshot.docs.first.data() as Map<String, dynamic>);
        } else {
          // If no matching document found, return null
          return null;
        }
      },
    );
  }

  Future<bool> addServiceCenter(ServiceCenter serviceCenter) async {
    log.i('serviceCenter:$serviceCenter');
    try {
      final userDocument = _serviceCenterCollection.doc(serviceCenter.id);
      await userDocument.set(serviceCenter.toJson(), SetOptions(merge: true));
      log.v('serviceCenter created at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<List<ServiceCenter>> getServiceCenters() async {
    try {
      QuerySnapshot querySnapshot = await _serviceCenterCollection.get();

      return querySnapshot.docs
          .map((DocumentSnapshot document) =>
          ServiceCenter.fromMap(document.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log.e('Error getting service centers: $e');
      return [];
    }
  }

  //[===================================vehicle
  final CollectionReference _vehicleCollection =
  FirebaseFirestore.instance.collection("vehicles");

  Future<String?> generateVehicleDocumentId() async {
    try {
      // Add a document with an auto-generated ID
      DocumentReference documentReference = _vehicleCollection.doc();

      // Retrieve the auto-generated ID from the document reference
      String documentId = documentReference.id;

      // Return the generated document ID
      return documentId;
    } catch (e) {
      // Handle any errors here
      log.e("Error generating document ID: $e");
      return null; // You might want to handle errors more gracefully
    }
  }

  String _vehicleType = "car";

  String get vehicleType => _vehicleType;

  void setVehicleType(String value) {
    log.i('vehicle type:$value');
    _vehicleType = value;
  }

  Future<bool> addVehicle(Vehicle vehicle) async {
    log.i('vehicle:$vehicle');
    try {
      final userDocument = _vehicleCollection.doc(vehicle.id);
      await userDocument.set(vehicle.toMap(), SetOptions(merge: true));
      log.v('vehicle created at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<Vehicle?> getVehicle(String vehicleId) async {
    try {
      final vehicleDocument = await _vehicleCollection.doc(vehicleId).get();
      if (vehicleDocument.exists) {
        return Vehicle.fromMap(vehicleDocument.data() as Map<String, dynamic>);
      } else {
        return null; // Vehicle with the specified ID doesn't exist
      }
    } catch (error) {
      log.e("Error $error");
      return null; // Handle the error as needed
    }
  }

  Future<bool> setVehicleKm(String vehicleId, int value) async {
    log.i("Set f: $value");
    try {
      await _vehicleCollection.doc(vehicleId).update({
        'kilometers': FieldValue.increment(value),
      });
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }

  Future<bool> setVehicleDamage(String vehicleId, int value) async {
    try {
      await _vehicleCollection.doc(vehicleId).update({
        'damagePoints': FieldValue.increment(value),
      });
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }

  Future<bool> setVehicleServices(String vehicleId, double value) async {
    try {
      await _vehicleCollection.doc(vehicleId).set({
        'noOfServices': FieldValue.increment(value),
      }, SetOptions(merge: true));
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }

  Stream<List<Vehicle>> getVehiclesForUser() {
    try {
      log.i(_authenticationService.currentUser?.email);
      // Query to get vehicles where ownerEmail matches the user's email
      Query query = _vehicleCollection.where('ownerEmail',
          isEqualTo: _authenticationService.currentUser?.email ?? "");

      // Snapshot of the query result as a stream
      Stream<QuerySnapshot> snapshots = query.snapshots();

      // Map the snapshots to a list of Vehicle objects
      Stream<List<Vehicle>> vehicleStream =
      snapshots.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot document) {
          return Vehicle.fromMap(document.data() as Map<String, dynamic>);
        }).toList();
      });

      return vehicleStream;
    } catch (e) {
      // Handle any errors here
      log.e("Error getting vehicles for user: $e");
      // You might want to handle errors more gracefully
      return Stream.value([]); // Return an empty list on error
    }
  }

  //[===================================service
  final CollectionReference _serviceCollection =
  FirebaseFirestore.instance.collection("services");

  Future<String?> generateServiceDocumentId() async {
    try {
      // Add a document with an auto-generated ID
      DocumentReference documentReference = _serviceCollection.doc();

      // Retrieve the auto-generated ID from the document reference
      String documentId = documentReference.id;

      // Return the generated document ID
      return documentId;
    } catch (e) {
      // Handle any errors here
      log.e("Error generating document ID: $e");
      return null; // You might want to handle errors more gracefully
    }
  }

  Future<bool> addService(VehicleService service) async {
    log.i('service:$service');
    try {
      final userDocument = _serviceCollection.doc(service.id);
      await userDocument.set(service.toJson(), SetOptions(merge: true));
      log.v('service created at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Stream<List<VehicleService>> getServicesForUser(bool isUser) {
    try {
      // Query to get services where userId matches the user's id
      Query query = _serviceCollection.where(
          isUser ? 'userId' : 'serviceCenterId',
          isEqualTo: _authenticationService.currentUser?.uid ?? "");

      // Snapshot of the query result as a stream
      Stream<QuerySnapshot> snapshots = query.snapshots();

      // Map the snapshots to a list of VehicleService objects
      Stream<List<VehicleService>> serviceStream =
      snapshots.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot document) {
          return VehicleService.fromMap(
              document.data() as Map<String, dynamic>);
        }).toList();
      });

      return serviceStream;
    } catch (e) {
      // Handle any errors here
      log.e("Error getting services for user: $e");
      // You might want to handle errors more gracefully
      return Stream.value([]); // Return an empty list on error
    }
  }

  List<VehicleService> _servicesList = [];

  List<VehicleService> get servicesList => _servicesList;

  void listenToServicesForUser(bool isUser) {
    getServicesForUser(isUser).listen(
          (List<VehicleService> services) {
        log.e(services.length);
        _servicesList = services;
        notifyListeners();
        log.e(servicesList);
      },
      onError: (dynamic error) {
        // Handle errors
        log.e("Error listening to services for user: $error");
      },
    );
  }

  String _serviceId = "";

  void setServiceId(String id) {
    _serviceId = id;
  }

  Stream<VehicleService?> getVehicleServiceStream() {
    // Replace 'serviceCenters' with the actual name of your collection in Firestore
    return _serviceCollection
        .where('id', isEqualTo: _serviceId)
        .snapshots()
        .map(
          (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // If there is a matching document, return the ServiceCenter
          return VehicleService.fromMap(
              snapshot.docs.first.data() as Map<String, dynamic>);
        } else {
          // If no matching document found, return null
          return null;
        }
      },
    );
  }

  Future<bool> addRepairToService(String serviceId, Repair repair) async {
    try {
      await _serviceCollection.doc(serviceId).update({
        'repairs': FieldValue.arrayUnion([repair.toJson()]),
      });
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }

  Future<bool> removeRepairFromService(String serviceId, Repair repair) async {
    try {
      await _serviceCollection.doc(serviceId).update({
        'repairs': FieldValue.arrayRemove([repair.toJson()]),
      });
      return true;
    } catch (error) {
      log.e("Error removing repair from service: $error");
      return false;
    }
  }

  Future<bool> setServiceCost(String serviceId, double cost) async {
    try {
      await _serviceCollection.doc(serviceId).update({
        'totalCost': FieldValue.increment(cost),
      });
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }

  Future<bool> setServiceComplete(String serviceId, bool value) async {
    try {
      await _serviceCollection.doc(serviceId).update({
        'isCompleted': value,
      });
      return true;
    } catch (error) {
      log.e("Error adding repair to service: $error");
      return false;
    }
  }
}
