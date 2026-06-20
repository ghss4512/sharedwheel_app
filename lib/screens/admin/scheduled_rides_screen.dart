import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'ride_details_screen.dart';

class ScheduledRidesScreen extends StatefulWidget {
  const ScheduledRidesScreen({super.key});

  @override
  State<ScheduledRidesScreen> createState() => _ScheduledRidesScreenState();
}

class _ScheduledRidesScreenState extends State<ScheduledRidesScreen> {
  final AdminService service = AdminService();
  List<RideModel> rides = [];
  List<RideModel> filteredRides = [];
  bool isLoading = true;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadRides();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRides() async {
    try {
      rides = await service.getScheduledRides();
      filteredRides = List.from(rides);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void searchRides(String keyword) {
    keyword = keyword.toLowerCase();

    setState(() {
      filteredRides = rides.where((ride) {
        return ride.fromCity.toLowerCase().contains(keyword) ||
            ride.toCity.toLowerCase().contains(keyword) ||
            ride.driverName.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Scheduled Rides'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchRides,
              decoration: const InputDecoration(
                hintText: 'Search ride...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadRides,

              child: isLoading
                  ? const LoadingWidget()
                  : filteredRides.isEmpty
                  ? const EmptyStateWidget(message: 'No scheduled rides found')
                  : ListView.builder(
                      itemCount: filteredRides.length,

                      itemBuilder: (context, index) {
                        return rideCard(filteredRides[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rideCard(RideModel ride) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              '${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('Driver: ${ride.driverName}'),

            Text('Phone: ${ride.driverPhone}'),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: [
                Chip(label: Text('${ride.totalBookings} Bookings')),

                Chip(
                  label: Text('${ride.bookedSeats}/${ride.totalSeats} Seats'),
                ),

                Chip(
                  backgroundColor: Colors.orange,

                  label: Text(
                    Functions.toProperCase(ride.rideStatus),

                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  Functions.navigateTo(
                    context,

                    RideDetailsScreen(rideId: ride.id),
                  );
                },

                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
