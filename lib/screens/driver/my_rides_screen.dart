import 'package:flutter/material.dart';
import 'package:sharedwheel_app/utils/functions.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  final RideService rideService = RideService();
  List<RideModel> rides = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
    return Card(
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

            Text('📅 ${ride.travelDate}'),
            Text('⏰ ${Functions.convertTo12Hour(ride.travelTime)}'),
            Text('👥 ${ride.availableSeats}/${ride.totalSeats} Seats Available',),

            const SizedBox(height: 10),

            Text(
              'Rs. ${ride.farePerSeat.toStringAsFixed(0)}',
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
    );
  }
}