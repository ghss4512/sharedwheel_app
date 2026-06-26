import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/city_model.dart';
import '../../models/vehicle_model.dart';
import '../../services/city_service.dart';
import '../../services/ride_service.dart';
import '../../services/vehicle_service.dart';
import '../../utils/functions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/searchable_city_dropdown.dart';

class PostRideScreen extends StatefulWidget {
  const PostRideScreen({super.key});

  @override
  State<PostRideScreen> createState() => _PostRideScreenState();
}

class _PostRideScreenState extends State<PostRideScreen> {
  final CityService cityService = CityService();
  List<CityModel> cities = [];
  CityModel? selectedFromCity;
  CityModel? selectedToCity;
  double? farePerSeat;

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
    loadCities();
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
          spacing: 15,
          children: [
            SearchableCityDropdown(
              label: 'From City',
              icon: Icons.location_on,
              cities: cities,
              selectedCity: selectedFromCity,
              onChanged: (city) {
                setState(() async {
                  selectedFromCity = city;
                  await loadFare();
                });
              },
            ),

            SearchableCityDropdown(
              label: 'To City',
              icon: Icons.flag,
              cities: cities,
              selectedCity: selectedToCity,
              onChanged: (city) {
                setState(() async {
                  selectedToCity = city;
                  await loadFare();
                });
              },
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
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.currency_exchange, color: Colors.green),
                title: const Text('Fare Per Seat'),
                subtitle: Text(
                  farePerSeat == null
                      ? 'Select From & To City to get fare'
                      : 'Rs. ${farePerSeat!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
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
    if (pickupLocationController.text.trim().isEmpty ||
        dropLocationController.text.trim().isEmpty ||
        travelDateController.text.trim().isEmpty ||
        travelTimeController.text.trim().isEmpty ||
        totalSeatsController.text.trim().isEmpty) {
      Functions.error(context, 'Please fill all fields');
      return;
    }

    if (selectedVehicle == null) {
      Functions.error(context, 'Please add a vehicle first.');
      return;
    }
    if (selectedFromCity == null) {
      Functions.error(context, 'Please select From City.');
      return;
    }

    if (selectedToCity == null) {
      Functions.error(context, 'Please select To City.');
      return;
    }

    if (farePerSeat == null) {
      Functions.error(context, 'Fare is not configured for this route.');
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final result = await rideService.postRide(
        vehicleId: selectedVehicle!.id,
        fromCityId: selectedFromCity!.id,
        toCityId: selectedToCity!.id,
        pickupLocation: pickupLocationController.text.trim(),
        dropLocation: dropLocationController.text.trim(),
        travelDate: travelDateController.text.trim(),
        travelTime: travelTimeController.text.trim(),
        totalSeats: int.parse(totalSeatsController.text),
        farePerSeat: farePerSeat!,
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

  Future<void> loadCities() async {
    cities = await cityService.getActiveCities();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadFare() async {
    if (selectedFromCity == null || selectedToCity == null) {
      farePerSeat = null;
      return;
    }

    final result = await rideService.getRideFare(
      fromCityId: selectedFromCity!.id,
      toCityId: selectedToCity!.id,
    );

    if (result['success'] == true) {
      farePerSeat = double.tryParse(result['fare']['fare_per_seat'].toString()) ?? 0;
    } else {
      farePerSeat = null;
    }

    if (mounted) {
      setState(() {});
    }
  }
}
