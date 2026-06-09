import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
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
  final travelDateController = TextEditingController();
  final travelTimeController = TextEditingController();
  final totalSeatsController = TextEditingController();
  final fareController = TextEditingController();
  final vehicleNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final vehicleColorController = TextEditingController();

  final RideService rideService = RideService();
  bool isLoading = false;

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
        travelDateController.text.trim().isEmpty ||
        travelTimeController.text.trim().isEmpty ||
        totalSeatsController.text.trim().isEmpty ||
        fareController.text.trim().isEmpty ||
        vehicleNameController.text.trim().isEmpty ||
        vehicleNumberController.text.trim().isEmpty ||
        vehicleColorController.text.trim().isEmpty) {
      Functions.error(context, 'Please fill all fields');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final result = await rideService.postRide(
        fromCity: fromCityController.text.trim(),
        toCity: toCityController.text.trim(),
        travelDate: travelDateController.text.trim(),
        travelTime: travelTimeController.text.trim(),
        totalSeats: int.parse(totalSeatsController.text),
        farePerSeat: double.parse(fareController.text),
        vehicleName: vehicleNameController.text.trim(),
        vehicleNumber: vehicleNumberController.text.trim(),
        vehicleColor: vehicleColorController.text.trim(),
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
          children: [
            CustomTextField(
              label: 'From City',
              icon: Icons.location_on,
              controller: fromCityController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'To City',
              icon: Icons.flag,
              controller: toCityController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Travel Date',
              icon: Icons.calendar_today,
              controller: travelDateController,
              readOnly: true,
              onTap: pickDate,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Travel Time',
              icon: Icons.access_time,
              controller: travelTimeController,
              readOnly: true,
              onTap: pickTime,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Total Seats',
              icon: Icons.event_seat,
              controller: totalSeatsController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Fare Per Seat',
              icon: Icons.currency_exchange,
              controller: fareController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Vehicle Name',
              icon: Icons.directions_car,
              controller: vehicleNameController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Vehicle Number',
              icon: Icons.confirmation_number,
              controller: vehicleNumberController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Vehicle Color',
              icon: Icons.color_lens,
              controller: vehicleColorController,
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
}
