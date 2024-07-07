import 'package:autocare_flutter/ui/smart_widgets/online_status.dart';
import 'package:autocare_flutter/ui/views/widgets/360viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../models/appuser.dart';
import '../../../models/service.dart';
import '../../../models/servicecenter.dart';
import '../../../models/vehicle.dart';
import '../../../services/firestore_service.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Welcome ${viewModel.user != null ? viewModel.user!.fullName : ""}"),
          actions: [
            IconButton(
                onPressed: viewModel.logout, icon: const Icon(Icons.logout))
          ],
        ),
        body:
            // viewModel.dataReady ?
            viewModel.data != null && viewModel.data!.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8),
                              child: Text(
                                "Booked Services",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: viewModel.vehicleServices
                                .map((VehicleService service) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                      'Service Center: ${service.serviceCenterName}'),
                                  // Replace with the relevant data
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Service ID: ${service.id}'),
                                      Text('Date: ${service.date}'),
                                      Text(
                                          'Details: ${service.problemDescription}'),
                                      Text(
                                          'Cost: ₹${service.totalCost.round()}'),
                                    ],
                                  ),
                                  trailing: service.isCompleted
                                      ? const Icon(
                                          Icons.done_outline,
                                          color: Colors.green,
                                        )
                                      : null,
                                  onTap: () {
                                    viewModel.openVehicleService(service);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8),
                              child: Text(
                                "Vehicles",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: List.generate(
                            viewModel.data!.length,
                            (index) {
                              return VehicleCard(
                                vehicle: viewModel.data![index],
                                onBookButton: () async {
                                  VehicleService? service =
                                      await showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        ServiceBookBottomSheet(
                                      user: viewModel.user!,
                                      vehicle: viewModel.data![index],
                                    ),
                                  );

                                  if (service != null) {
                                    viewModel.bookService(service);
                                  }
                                },
                                isAdmin: false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No vehicles registered!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Pls request service center nearby you to add your vehicle!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
        // : const Center(child: CircularProgressIndicator()),
        );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onBookButton;
  final bool isAdmin;

  const VehicleCard(
      {super.key,
      required this.vehicle,
      required this.onBookButton,
      required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) {
          double fitnessLevel = vehicle.calculateFitnessLevel(2023);

          return Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              // border: Border.all(
              //   color: Colors.purple, // You can customize the border color
              //   width: 2.0,
              // ),
            ),
            child: Column(
              children: [
                Image360Viewer(isCar: vehicle.vehicleType == 'car'),
                ListTile(
                  title: Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Year: ${vehicle.year}'),
                      Text('Color: ${vehicle.color}'),
                      Text('License Plate: ${vehicle.licensePlate}'),
                      // Add more details as needed
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'KM: ${vehicle.kilometers}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Damage: ${vehicle.damagePoints}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Services: ${vehicle.noOfServices}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        // Adjust the radius as needed
                        child: LinearProgressIndicator(
                          value: fitnessLevel / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                          minHeight: 30,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'Fitness Level: ${fitnessLevel.toStringAsFixed(2)}%',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8.0),

                if (!isAdmin)
                  Column(
                    children: [
                      const Divider(),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Realtime reading:',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IsOnlineWidget(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (model.node != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.rotate_90_degrees_ccw),
                            const SizedBox(width: 3),
                            Text(
                              "${model.node!.encoderValue * 10} KM",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.thermostat),
                            Text(
                              "${model.node!.temp.toStringAsFixed(2)}°C",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.directions_car_rounded),
                            Text(
                              "${model.node!.speed.toStringAsFixed(2)} km/hr",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      if (model.node != null)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 300,
                            child: GoogleMap(
                              onMapCreated: (controller) {},
                              onTap: (LatLng location) {},
                              initialCameraPosition: CameraPosition(
                                target:
                                    LatLng(model.node!.lat, model.node!.long),
                                // Default map position
                                zoom: 15.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("picked_location"),
                                  position:
                                      LatLng(model.node!.lat, model.node!.long),
                                  infoWindow: const InfoWindow(
                                    title: "Current location",
                                  ),
                                ),
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                ///---------------------------------------------
                if (!isAdmin)
                  Column(
                    children: [
                      const Divider(),
                      ElevatedButton(
                        onPressed: onBookButton,
                        child: const Text('Book for service'),
                      ),
                    ],
                  ),
              ],
            ),
          );
        });
  }
}

class ServiceBookBottomSheet extends StatefulWidget {
  final AppUser user;
  final Vehicle vehicle;

  const ServiceBookBottomSheet(
      {Key? key, required this.vehicle, required this.user})
      : super(key: key);

  @override
  State<ServiceBookBottomSheet> createState() => _ServiceBookBottomSheetState();
}

class _ServiceBookBottomSheetState extends State<ServiceBookBottomSheet> {
  late GoogleMapController _mapController;
  final TextEditingController _problemDescriptionController =
      TextEditingController();
  final FirestoreService _firestoreService =
      FirestoreService(); // Instantiate your Firestore service
  List<ServiceCenter> _serviceCenters = [];
  ServiceCenter? selectedServiceCenter;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _loadServiceCenters();
  }

  Future<void> _loadServiceCenters() async {
    // Fetch service centers from Firestore
    _serviceCenters = await _firestoreService.getServiceCenters();
    setState(() {
      // Update the widget when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _problemDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Problem Description',
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _addServiceCentersMarkers();
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(9.9894, 76.3174),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
            ),
          ),
          ElevatedButton(
            onPressed: selectedServiceCenter != null
                ? () {
                    if (selectedServiceCenter != null &&
                        _problemDescriptionController.text.isNotEmpty) {
                      // Determine the service center ID based on the selected location
                      // Create a Service object
                      VehicleService newService = VehicleService(
                        id: '',
                        problemDescription: _problemDescriptionController.text,
                        date: DateTime.now(),
                        serviceCenterId: selectedServiceCenter!.id,
                        serviceCenterName: selectedServiceCenter!.name,
                        userId: widget.user.id,
                        userName: widget.user.fullName,
                        vehicleId: widget.vehicle.id,
                        repairs: [],
                        totalCost: 0.0,
                        isCompleted: false, // Set it based on your logic
                      );

                      // Pass the new service object back to the caller
                      Navigator.pop(context, newService);
                    } else {
                      // Show an error message or handle the case when either location or problem description is missing
                    }
                  }
                : null,
            child: Text(selectedServiceCenter != null
                ? 'Book Service'
                : "Please select a location"),
          ),
        ],
      ),
    );
  }

  // Helper method to add markers on the map for service centers
  void _addServiceCentersMarkers() {
    for (var i = 0; i < _serviceCenters.length; i++) {
      final marker = Marker(
          markerId: MarkerId(_serviceCenters[i].id),
          position:
              LatLng(_serviceCenters[i].latitude, _serviceCenters[i].longitude),
          // icon: BitmapDescriptor.,
          infoWindow: InfoWindow(
            title: _serviceCenters[i].name,
            snippet: _serviceCenters[i].address,
          ),
          onTap: () {
            selectedServiceCenter = _serviceCenters[i];
            setState(() {});
          });

      setState(() {
        markers[MarkerId(_serviceCenters[i].id)] = marker;
      });
    }
  }

  @override
  void dispose() {
    _problemDescriptionController.dispose(); // Dispose of the text controller
    super.dispose();
  }
}
