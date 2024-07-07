import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../models/service.dart';
import 'admin_viewmodel.dart';

class AdminView extends StackedView<AdminViewModel> {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AdminViewModel viewModel,
    Widget? child,
  ) {
    if (!viewModel.dataReady || viewModel.data == null) {
      return const ServiceCenterAddView();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Service Center: ${viewModel.data!.name}",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: viewModel.logout, icon: const Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: Image.network(viewModel.data!.logoUrl)),
                ),
                Text(viewModel.data!.address),
                Text(viewModel.data!.email),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8),
                      child: Text(
                        "Services",
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
                        .map<Widget>((VehicleService service) {
                      return Card(
                        child: ListTile(
                          title: Text('Service Booked By: ${service.userName}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Service ID: ${service.id}'),
                              Text('Date: ${service.date}'),
                              Text('Details: ${service.problemDescription}'),
                            ],
                          ),
                          trailing: service.isCompleted
                              ? const Icon(
                                  Icons.done_outline,
                                  color: Colors.green,
                                )
                              : null,
                          onTap: () {
                            // Your navigation logic here
                            viewModel.openVehicleService(service);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    viewModel.openVehicleAdding(true);
                  },
                  child: Card(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: Image.asset('assets/car/1.png'),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    "Add new car",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20.0, left: 10),
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    viewModel.openVehicleAdding(false);
                  },
                  child: Card(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: Image.asset('assets/bike/bike.png'),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    "Add new bike",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20.0, left: 10),
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  AdminViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AdminViewModel();

  @override
  void onViewModelReady(AdminViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}

class ServiceCenterAddView extends StatelessWidget {
  const ServiceCenterAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdminViewModel>.reactive(
      viewModelBuilder: () => AdminViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Service Center'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: model.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.name,
                      controller: model.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Logo URL'),
                      keyboardType: TextInputType.url,
                      controller: model.logoUrlController,
                      validator: (value) {
                        // Add validation for the logo URL if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: model.emailController,
                      validator: (value) {
                        // Add validation for the email if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Phone'),
                      controller: model.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        // Add validation for the phone if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Address'),
                      controller: model.addressController,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        // Add validation for the address if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        LatLng? pickedLocation = await showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              const LocationPickerBottomSheet(),
                        );

                        if (pickedLocation != null) {
                          model.setPickedLocation(pickedLocation);
                        }
                      },
                      child: Text(model.pickedLocation != null
                          ? 'Change location'
                          : 'Pick Location'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (model.validateForm()) {
                          model.addServiceCenter();
                        }
                      },
                      child: model.isBusy
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Service Center'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LocationPickerBottomSheet extends StatefulWidget {
  const LocationPickerBottomSheet({super.key});

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          0.7, // Adjust the height as needed
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onTap: (LatLng location) {
              setState(() {
                _pickedLocation = location;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(9.9894, 76.3174), // Default map position
              zoom: 15.0,
            ),
            markers: _pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId("picked_location"),
                      position: _pickedLocation!,
                      infoWindow: const InfoWindow(
                        title: "Picked Location",
                      ),
                    ),
                  }
                : {},
          ),
          Positioned(
            top: 10,
            left: 50,
            right: 50,
            child: SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _pickedLocation);
                },
                child: const Text('Pick this Location'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
