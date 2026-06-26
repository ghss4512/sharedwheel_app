import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'completed_ride_details_screen.dart';

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
    return InkWell(
      onTap: () {
        Functions.navigateTo(context, CompletedRideDetailsScreen(ride: ride));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      '${Functions.toProperCase(ride.fromCity)} → '
                      '${Functions.toProperCase(ride.toCity)}',
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
                      color: Colors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18, color: Colors.red),
                  const SizedBox(width: 5),
                  Text(ride.travelDate),
                  const SizedBox(width: 20),
                  const Icon(Icons.access_time, size: 18, color: Colors.green),
                  const SizedBox(width: 5),
                  Text(Functions.convertTo12Hour(ride.travelTime)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.currency_exchange, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    "Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.event_seat, size: 18, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text('${ride.totalSeats} Seats'),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getPassengerStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'boarded':
        return Colors.green;
      case 'no_show':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
