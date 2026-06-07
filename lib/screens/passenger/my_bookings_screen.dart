import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bookingCard(
            route: 'Lahore → Islamabad',
            driver: 'Ali Raza',
            date: '10 Jun 2026',
            time: '08:00 AM',
            seats: 2,
            fare: 'Rs. 3,600',
            status: 'Pending',
            statusColor: Colors.orange,
          ),

          _bookingCard(
            route: 'Lahore → Multan',
            driver: 'Ahmed Khan',
            date: '12 Jun 2026',
            time: '09:30 AM',
            seats: 1,
            fare: 'Rs. 1,200',
            status: 'Accepted',
            statusColor: AppColors.success,
          ),

          _bookingCard(
            route: 'Karachi → Hyderabad',
            driver: 'Usman Ali',
            date: '05 Jun 2026',
            time: '07:00 AM',
            seats: 3,
            fare: 'Rs. 2,700',
            status: 'Completed',
            statusColor: AppColors.primary,
          ),

        ],
      ),
    );
  }

  Widget _bookingCard({
    required String route,
    required String driver,
    required String date,
    required String time,
    required int seats,
    required String fare,
    required String status,
    required Color statusColor,
  }) {

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    route,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(38),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text('👤 Driver: $driver'),
            const SizedBox(height: 5),
            Text('📅 Date: $date'),
            const SizedBox(height: 5),
            Text('⏰ Time: $time'),
            const SizedBox(height: 5),
            Text('👥 Seats Booked: $seats'),
            const SizedBox(height: 10),
            Text(
              fare,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            PrimaryButton(
              text: 'View Details',
              onPressed: () {
                // Navigate to booking details screen later
              },
            ),
          ],
        ),
      ),
    );
  }
}