import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_vehicle_viewmodel.dart';

class AddVehicleView extends StackedView<AddVehicleViewModel> {
  final bool isCar;

  const AddVehicleView({Key? key, required this.isCar}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddVehicleViewModel viewModel,
    Widget? child,
  ) {
    return const AddVehicleViewForm();
  }

  @override
  AddVehicleViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddVehicleViewModel();

  @override
  void onViewModelReady(AddVehicleViewModel viewModel) {
    viewModel.onModelReady(isCar);
    super.onViewModelReady(viewModel);
  }
}

class AddVehicleViewForm extends StatelessWidget {
  const AddVehicleViewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVehicleViewModel>.reactive(
      viewModelBuilder: () => AddVehicleViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Vehicle'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: model.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Brand'),
                      keyboardType: TextInputType.text,
                      controller: model.brandController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the brand';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Model'),
                      keyboardType: TextInputType.text,
                      controller: model.modelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the model';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      controller: model.yearController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the year';
                        }
                        // Additional validation for a valid year if needed
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Color'),
                      keyboardType: TextInputType.text,
                      controller: model.colorController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the color';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'License Plate'),
                      keyboardType: TextInputType.text,
                      controller: model.licensePlateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the license plate';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Owner Email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: model.ownerEmailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the owner\'s email';
                        }
                        // Additional validation for a valid email if needed
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'No of Service'),
                      keyboardType: TextInputType.text,
                      controller: model.servicesController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the no of services';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Kilometers'),
                      keyboardType: TextInputType.number,
                      controller: model.kilometersController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the kilometers';
                        }
                        // Additional validation for a valid number if needed
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Damage Points'),
                      keyboardType: TextInputType.text,
                      controller: model.damagePointsController,
                      validator: (value) {
                        // You may add additional validation logic here
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Engine Number'),
                      keyboardType: TextInputType.text,
                      controller: model.engineNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the engine number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Chassis Number'),
                      keyboardType: TextInputType.text,
                      controller: model.chassisNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the chassis number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (model.validateForm()) {
                          model.addVehicle();
                        }
                      },
                      child: model.isBusy
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Vehicle'),
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
