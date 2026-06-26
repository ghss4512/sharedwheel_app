import 'package:flutter/material.dart';
import 'package:shared_wheel/constants/base_state.dart';
import '../../utils/functions.dart';
import 'driver_ride_details_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => MyRidesScreenState();
}

class MyRidesScreenState extends BaseState<MyRidesScreen> {
  final RideService rideService = RideService();
  List<RideModel> rides = [];
  bool isLoading = false;

  @override
  void onInit() {
    loadRides();
  }

  @override
  void onResume() {
    loadRides();
  }

  Future<void> loadRides() async {
    setState(() {
      isLoading = true;
    });
    try {
      rides = await rideService.getMyRides();
    } catch (e) {
      debugPrint('Ride Error: $e');
    }

    if (!mounted) return;
    debugPrint(
      'Rides Count: ${rides.length}',
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Rides'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadRides,
        child: isLoading
            ? const LoadingWidget()
            : rides.isEmpty
            ? const EmptyStateWidget(message: 'No rides found')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  return rideCard(rides[index]);
                },
              ),
      ),
    );
  }

  Widget rideCard(RideModel ride) {
    return InkWell(
      onTap: () {
        Functions.navigateTo(context,  DriverRideDetailsScreen(ride: ride));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('📍 Pickup: ${ride.pickupLocation}'),
              Text('🏁 Drop: ${ride.dropLocation}'),
              Text('📅 ${ride.travelDate}'),
              Text('⏰ ${Functions.convertTo12Hour(ride.travelTime)}'),
              Text('👥 ${ride.availableSeats}/${ride.totalSeats} Seats Available',),
              const SizedBox(height: 10),
              Text(
                'Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)}',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(ride.rideStatus.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}