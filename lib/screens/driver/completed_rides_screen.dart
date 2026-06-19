import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class CompletedRidesScreen extends StatefulWidget {
  const CompletedRidesScreen({super.key});

  @override
  State<CompletedRidesScreen> createState() => CompletedRidesScreenState();
}

class CompletedRidesScreenState extends State<CompletedRidesScreen> {
  final RideService service = RideService();

  List<RideModel> rides = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    try {
      rides = await service.getCompletedRides();
    } catch (e) {
      debugPrint(e.toString());
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
        title: const Text('Completed Rides'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadRides,
        child: isLoading
            ? const LoadingWidget()
            : rides.isEmpty
            ? const EmptyStateWidget(message: 'No completed rides found')
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('📍 Pickup: ${ride.pickupLocation}'),
            const SizedBox(height: 8),
            Text('🏁 Drop: ${ride.dropLocation}'),
            const SizedBox(height: 10),
            Text('📅 ${ride.travelDate}'),
            Text('⏰ ${Functions.convertTo12Hour(ride.travelTime)}'),
            const SizedBox(height: 8),
            Text('🚗 ${ride.vehicleName}'),
            Text('🔢 ${ride.vehicleNumber}'),
            Text('🎨 ${ride.vehicleColor}'),
            const SizedBox(height: 8),
            Text('💺 Seats: ${ride.totalSeats}'),
            Text('💰 Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)} / Seat',),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'COMPLETED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}