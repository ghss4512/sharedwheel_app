import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/vehicle_service.dart';
import '../../utils/functions.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final VehicleService service = VehicleService();
  final formKey = GlobalKey<FormState>();
  final vehicleNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final vehicleColorController = TextEditingController();
  final seatingCapacityController = TextEditingController(text: '4');
  bool isSubmitting = false;

  String vehicleType = 'Car';
  final List<String> vehicleTypes = ['Car', 'Bike', 'Van', 'Bus', 'Rickshaw'];

  @override
  void dispose() {
    vehicleNameController.dispose();
    vehicleNumberController.dispose();
    vehicleColorController.dispose();
    seatingCapacityController.dispose();
    super.dispose();
  }

  Future<void> saveVehicle() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await service.addVehicle(
        vehicleType: vehicleType,
        vehicleName: vehicleNameController.text.trim(),
        vehicleNumber: vehicleNumberController.text.trim(),
        vehicleColor: vehicleColorController.text.trim(),
        seatingCapacity: int.parse(seatingCapacityController.text),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);
        Navigator.pop(context, true);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, e.toString());
    }

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: vehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type',
                  border: OutlineInputBorder(),
                ),

                items: vehicleTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleType = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: vehicleNameController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vehicle name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vehicle number is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: vehicleColorController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Color',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vehicle color is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: seatingCapacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Seating Capacity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final seats = int.tryParse(value);
                  if (seats == null || seats <= 0) {
                    return 'Invalid capacity';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : saveVehicle,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  child: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Save Vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}