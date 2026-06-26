import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../utils/functions.dart';

class PassengerActiveRideDetailsScreen extends StatelessWidget {
  final RideModel ride;

  const PassengerActiveRideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ROUTE CARD
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
                    ],
                  ),

                  const SizedBox(height: 15),

                  buildStatusBadge(),

                  const SizedBox(height: 15),

                  infoRow(Icons.calendar_month, 'Date', ride.travelDate),

                  infoRow(
                    Icons.access_time,
                    'Time',
                    Functions.convertTo12Hour(ride.travelTime),
                  ),

                  infoRow(
                    Icons.currency_exchange,
                    'Fare',
                    'Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // PICKUP / DROP
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text('Pickup Location'),
                  subtitle: Text(ride.pickupLocation),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.flag, color: Colors.red),
                  title: const Text('Drop Location'),
                  subtitle: Text(ride.dropLocation),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // DRIVER CARD
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(ride.driverName ?? ''),
              subtitle: Text(ride.driverPhone ?? ''),
            ),
          ),

          const SizedBox(height: 15),

          // VEHICLE CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  infoRow(Icons.directions_car, 'Vehicle', ride.vehicleName),

                  infoRow(
                    Icons.confirmation_number,
                    'Number',
                    ride.vehicleNumber,
                  ),

                  infoRow(Icons.palette, 'Color', ride.vehicleColor),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('Message Driver'),
              onPressed: () {
                // Open conversation screen
              },
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.report_problem),
              label: const Text('Submit Complaint'),
              onPressed: () {
                // Open complaint screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusBadge() {
    Color color;

    switch (ride.rideStatus.toLowerCase()) {
      case 'scheduled':
        color = Colors.blue;
        break;

      case 'enroute':
        color = Colors.orange;
        break;

      case 'waiting':
        color = Colors.purple;
        break;

      case 'in_progress':
        color = Colors.green;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        ride.rideStatus.replaceAll('_', ' ').toUpperCase(),

        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 8),

          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
