import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/passenger_dashboard_service.dart';
import '../../utils/functions.dart';
import 'passenger_completed_ride_details_screen.dart';

class PassengerCompletedRidesScreen extends StatefulWidget {
  const PassengerCompletedRidesScreen({super.key});

  @override
  State<PassengerCompletedRidesScreen> createState() =>
      _PassengerCompletedRidesScreenState();
}

class _PassengerCompletedRidesScreenState
    extends State<PassengerCompletedRidesScreen> {
  List<RideModel> rides = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    setState(() => isLoading = true);

    rides = await PassengerDashboardService().getCompletedRides();

    if (!mounted) return;

    setState(() => isLoading = false);
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
            ? const Center(child: CircularProgressIndicator())
            : rides.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 150),
                  Icon(Icons.task_alt, size: 70, color: Colors.grey),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      'No completed rides found',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  return completedRideCard(rides[index]);
                },
              ),
      ),
    );
  }

  Widget completedRideCard(RideModel ride) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Functions.navigateTo(
            context,
            PassengerCompletedRideDetailsScreen(rideId: ride.id),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.route, color: AppColors.primary),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      '${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18),

                  const SizedBox(width: 8),

                  Text(ride.travelDate),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),

                  const SizedBox(width: 8),

                  Text(Functions.convertTo12Hour(ride.travelTime)),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.event_seat, size: 18),

                  const SizedBox(width: 8),

                  Text('${ride.availableSeats} Seats'),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18),

                  const SizedBox(width: 8),

                  Text(
                    'Rs. ${ride.farePerSeat}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility),

                  label: const Text('View Details'),

                  onPressed: () {
                    Functions.navigateTo(
                      context,
                      PassengerCompletedRideDetailsScreen(rideId: ride.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
