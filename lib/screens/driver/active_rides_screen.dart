import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import 'driver_ride_details_screen.dart';

class ActiveRidesScreen extends StatefulWidget {
  const ActiveRidesScreen({super.key});

  @override
  State<ActiveRidesScreen> createState() => _ActiveRidesScreenState();
}

class _ActiveRidesScreenState extends State<ActiveRidesScreen> {
  final RideService rideService = RideService();
  bool isLoading = true;
  List<RideModel> rides = [];

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    setState(() {
      isLoading = true;
    });
    rides = await rideService.getActiveRides();
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
        title: const Text('Active Rides'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const LoadingWidget()
          : rides.isEmpty
          ? const Center(child: Text('No active rides found.'))
          : RefreshIndicator(
              onRefresh: loadRides,
              child: ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];

                  return InkWell(
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        DriverRideDetailsScreen(ride: ride),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.route,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${ride.fromCity} → ${ride.toCity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                buildStatusBadge(ride.rideStatus),
                              ],
                            ),

                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 18),
                                const SizedBox(width: 5),
                                Text(ride.travelDate),
                                const SizedBox(width: 20),
                                const Icon(Icons.access_time, size: 18),
                                const SizedBox(width: 5),
                                Text(ride.travelTime),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.event_seat, size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  '${ride.availableSeats}/${ride.totalSeats} Seats',
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

Widget buildStatusBadge(String status) {
  Color color;
  switch (status.toLowerCase()) {
    case 'scheduled':
      color = Colors.blue;
      break;
    case 'enroute':
      color = Colors.orange;
      break;
    case 'arrived':
      color = Colors.deepOrange;
      break;
    case 'waiting':
      color = Colors.amber;
      break;
    case 'in_progress':
      color = Colors.green;
      break;
    default:
      color = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withAlpha(30),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status.replaceAll('_', ' ').toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
  );
}
