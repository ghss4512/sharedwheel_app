import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

class RideDetailsScreen extends StatefulWidget {
  final int rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  final AdminService service = AdminService();

  bool isLoading = true;

  Map<String, dynamic>? ride;
  List bookings = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await service.getRideDetails(widget.rideId);

      if (result['success'] == true) {
        ride = result['ride'];

        bookings = result['bookings'] ?? [];
      }
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
        title: const Text('Ride Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : ride == null
          ? const Center(child: Text('Ride not found'))
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildRideInfo(),
                  const SizedBox(height: 16),
                  buildDriverInfo(),
                  const SizedBox(height: 16),
                  buildPassengers(),
                  const SizedBox(height: 20),
                  buildActions(),
                ],
              ),
            ),
    );
  }

  Widget buildRideInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ride Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),
            infoTile('Route', '${ride!['from_city']} → ${ride!['to_city']}'),
            infoTile('Pickup', ride!['pickup_location'].toString()),
            infoTile('Drop', ride!['drop_location'].toString()),
            infoTile('Date', ride!['travel_date'].toString()),
            infoTile('Time', ride!['travel_time'].toString()),
            infoTile('Fare', 'Rs. ${ride!['fare_per_seat']}'),
            infoTile('Seats', '${ride!['available_seats']} / ${ride!['total_seats']}',),
            infoTile('Status', Functions.toProperCase(ride!['ride_status'].toString()),),
          ],
        ),
      ),
    );
  }

  Widget buildDriverInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),
            infoTile('Name', ride!['driver_name'].toString()),
            infoTile('Phone', ride!['driver_phone'].toString()),
            infoTile('Email', ride!['driver_email'].toString()),
            infoTile('Rating', ride!['driver_rating'].toString()),
            infoTile('Total Rides', ride!['driver_total_rides'].toString()),
          ],
        ),
      ),
    );
  }

  Widget buildPassengers() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passengers (${bookings.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (bookings.isEmpty) const Text('No passengers'),
            ...bookings.map((booking) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(booking['full_name'].toString()),
                subtitle: Text('${booking['seats_booked']} seat(s)\n${booking['booking_status']}',),
                trailing: Text('Rs. ${booking['total_fare']}'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: completeRide,
                icon: const Icon(Icons.check_circle),
                label: const Text('Complete Ride'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cancelRide,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Ride'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> completeRide() async {
    final result = await service.completeRide(widget.rideId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadData();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> cancelRide() async {
    final result = await service.cancelRide(widget.rideId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadData();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
