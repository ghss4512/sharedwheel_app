import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';

class PostRideScreen extends StatefulWidget {
  const PostRideScreen({super.key});

  @override
  State<PostRideScreen> createState() => _PostRideScreenState();
}

class _PostRideScreenState extends State<PostRideScreen> {
  final fromCityController = TextEditingController();
  final toCityController = TextEditingController();
  final pickupLocationController = TextEditingController();
  final dropLocationController = TextEditingController();
  final travelDateController = TextEditingController();
  final travelTimeController = TextEditingController();
  final totalSeatsController = TextEditingController();
  final fareController = TextEditingController();

  List<VehicleModel> vehicles = [];
  VehicleModel? selectedVehicle;

  final RideService rideService = RideService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Post Ride'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 5,
          children: [
            CustomTextField(
              label: 'From City',
              icon: Icons.location_on,
              controller: fromCityController,
            ),

            CustomTextField(
              label: 'To City',
              icon: Icons.flag,
              controller: toCityController,
            ),

            CustomTextField(
              label: 'Pickup Location',
              icon: Icons.location_on,
              controller: pickupLocationController,
            ),

            CustomTextField(
              label: 'Drop Location',
              icon: Icons.flag,
              controller: dropLocationController,
            ),

            CustomTextField(
              label: 'Travel Date',
              icon: Icons.calendar_today,
              controller: travelDateController,
              readOnly: true,
              onTap: pickDate,
            ),

            CustomTextField(
              label: 'Travel Time',
              icon: Icons.access_time,
              controller: travelTimeController,
              readOnly: true,
              onTap: pickTime,
            ),

            CustomTextField(
              label: 'Total Seats',
              icon: Icons.event_seat,
              controller: totalSeatsController,
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
              label: 'Fare Per Seat',
              icon: Icons.currency_exchange,
              controller: fareController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<VehicleModel>(
              initialValue: selectedVehicle,
              decoration: const InputDecoration(
                labelText: 'Vehicle',
                border: OutlineInputBorder(),
              ),
              items: vehicles.map((vehicle) {
                return DropdownMenuItem(
                  value: vehicle,
                  child: Text(
                    '${vehicle.vehicleName} (${vehicle.vehicleNumber})',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVehicle = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a vehicle';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              text: isLoading ? 'Posting...' : 'Post Ride',
              onPressed: isLoading ? null : postRide,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      travelDateController.text = date.toIso8601String().split('T').first;
      setState(() {});
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      travelTimeController.text =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  Future<void> postRide() async {
    if (fromCityController.text.trim().isEmpty ||
        toCityController.text.trim().isEmpty ||
        pickupLocationController.text.trim().isEmpty ||
        dropLocationController.text.trim().isEmpty ||
        travelDateController.text.trim().isEmpty ||
        travelTimeController.text.trim().isEmpty ||
        totalSeatsController.text.trim().isEmpty ||
        fareController.text.trim().isEmpty) {
      Functions.error(context, 'Please fill all fields');
      return;
    }

    if (selectedVehicle == null) {
      Functions.error(context, 'Please add a vehicle first.');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final result = await rideService.postRide(
        fromCity: fromCityController.text.trim(),
        toCity: toCityController.text.trim(),
        pickupLocation: pickupLocationController.text.trim(),
        dropLocation: dropLocationController.text.trim(),
        travelDate: travelDateController.text.trim(),
        travelTime: travelTimeController.text.trim(),
        totalSeats: int.parse(totalSeatsController.text),
        farePerSeat: double.parse(fareController.text),
        vehicleName: selectedVehicle!.vehicleName,
        vehicleNumber: selectedVehicle!.vehicleNumber,
        vehicleColor: selectedVehicle!.vehicleColor,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Functions.success(context, result['message']);
        // Return to previous screen after success
        Navigator.pop(context);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadVehicles() async {
    vehicles = await VehicleService().getVehicles();
    if (vehicles.isNotEmpty) {
      selectedVehicle = vehicles.firstWhere(
        (v) => v.isDefault,
        orElse: () => vehicles.first,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }
}
