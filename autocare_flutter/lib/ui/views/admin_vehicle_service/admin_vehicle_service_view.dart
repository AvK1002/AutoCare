import 'dart:io';

import 'package:autocare_flutter/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stacked/stacked.dart';

import '../../../models/service.dart';
import 'admin_vehicle_service_viewmodel.dart';

class AdminVehicleServiceView
    extends StackedView<AdminVehicleServiceViewModel> {
  final VehicleService service;
  final bool isAdmin;

  const AdminVehicleServiceView(
      {Key? key, required this.service, required this.isAdmin})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AdminVehicleServiceViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
            "Service: ${viewModel.data != null ? viewModel.data!.id : ""}"),
      ),
      body: viewModel.dataReady || viewModel.data != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text("Service ID: ${viewModel.data!.id}"),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                              "Problem Description: ${viewModel.data!.problemDescription}"),
                        )),
                      ],
                    ),
                    if (viewModel.isBusy)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Column(
                        children: [
                          if (viewModel.customer != null)
                            Card(
                              child: ListTile(
                                title: Text(
                                  viewModel.customer!.fullName,
                                ),
                                subtitle: Text(
                                  viewModel.customer!.email,
                                ),
                              ),
                            ),
                          if (viewModel.vehicle != null && isAdmin)
                            VehicleCard(
                              vehicle: viewModel.vehicle!,
                              onBookButton: () {},
                              isAdmin: true,
                            ),
                          if (!isAdmin) const SizedBox(height: 20),
                        ],
                      ),
                    if (viewModel.data!.repairs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RepairList(repairs: viewModel.data!.repairs),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "Total cost: ${viewModel.data!.totalCost}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    if (!viewModel.data!.isCompleted && isAdmin)
                      RepairForm(onAddRepair: viewModel.onAddRepair),

                    if (!viewModel.data!.isCompleted && isAdmin)
                      ElevatedButton(
                        onPressed: viewModel.setCompleted,
                        child: const Text('Set service complete'),
                      ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  AdminVehicleServiceViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AdminVehicleServiceViewModel();

  @override
  void onViewModelReady(AdminVehicleServiceViewModel viewModel) {
    viewModel.onModelReady(service, isAdmin);
    super.onViewModelReady(viewModel);
  }
}

class RepairForm extends StatefulWidget {
  final Function(Repair) onAddRepair;

  const RepairForm({Key? key, required this.onAddRepair}) : super(key: key);

  @override
  _RepairFormState createState() => _RepairFormState();
}

class _RepairFormState extends State<RepairForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _partController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();
  final TextEditingController _laborHourController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _workController,
              decoration: const InputDecoration(labelText: 'Work'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the work';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _partController,
              decoration: const InputDecoration(labelText: 'Part'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the part';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(labelText: 'Serial Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the serial number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageLinkController,
              decoration: const InputDecoration(labelText: 'Image Link'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the image link';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _laborHourController,
              decoration: const InputDecoration(labelText: 'Labor Hour'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid labor hour';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid cost';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final Repair newRepair = Repair(
                    work: _workController.text,
                    part: _partController.text,
                    serialNumber: _serialNumberController.text,
                    imageLink: _imageLinkController.text,
                    laborHour:
                        double.tryParse(_laborHourController.text) ?? 0.0,
                    cost: double.tryParse(_costController.text) ?? 0.0,
                  );

                  // Invoke the callback function with the new repair object
                  widget.onAddRepair(newRepair);

                  // Clear text controllers after submitting
                  _workController.clear();
                  _partController.clear();
                  _serialNumberController.clear();
                  _imageLinkController.clear();
                  _laborHourController.clear();
                  _costController.clear();
                }
              },
              child: const Text('Add Repair'),
            ),
          ],
        ),
      ),
    );
  }
}

class RepairList extends StatelessWidget {
  final List<Repair> repairs;

  const RepairList({Key? key, required this.repairs}) : super(key: key);

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['Work', 'Part', 'Serial Number', 'Labor Hour', 'Cost'],
                for (var repair in repairs)
                  [
                    repair.work,
                    repair.part,
                    repair.serialNumber,
                    repair.laborHour.toString(),
                    repair.cost.toString()
                  ],
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Text(
                "Total amount: Rs ${repairs.fold(0.0, (sum, repair) => sum + repair.cost)}/-")
          ]);
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final pdfPath = '${tempDir.path}/repair_list.pdf';
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(pdfPath, type: 'application/pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _generatePdf(context),
            child: const Text('Download as PDF'),
          ),
        ),
        const SizedBox(height: 30),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
          },
          children: [
            const TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Work',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Part',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Serial Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Labor Hour',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cost',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            for (var repair in repairs)
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(repair.work),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(repair.part),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(repair.serialNumber),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(repair.laborHour.toInt().toString()),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(repair.cost.toInt().toString()),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
