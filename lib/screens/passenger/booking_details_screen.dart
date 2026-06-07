import 'package:flutter/material.dart';
import 'package:sharedwheel_app/widgets/section_title.dart';

import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(
          'Booking Details',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 35,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Booking Accepted',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Your booking has been accepted by the driver.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ROUTE INFORMATION
            SectionTitle(title: '🛣 Route Information'),
            infoCard([
              infoTile('From', 'Lahore'),
              infoTile('To', 'Islamabad'),
              infoTile('Date', '10 June 2026'),
              infoTile('Time', '08:00 AM'),
            ]),

            const SizedBox(height: 20),

            // DRIVER INFORMATION
            SectionTitle(title: '👤 Driver Information'),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text(
                  'Ali Raza',
                ),
                subtitle: const Text(
                  '⭐ 4.8 Rating',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOOKING INFORMATION
            SectionTitle(title: '📋 Booking Information'),
            infoCard([
              infoTile('Booking ID', '#BK-1001'),
              infoTile('Seats Booked', '2'),
              infoTile('Status', 'Accepted'),
              infoTile('Booked On', '05 June 2026'),
            ]),

            const SizedBox(height: 20),

            // PAYMENT INFORMATION
            SectionTitle(title: '💰 Payment Information'),
            infoCard([
              infoTile('Fare Per Seat', 'Rs. 1800'),
              infoTile('Seats', '2'),
              infoTile('Total Fare', 'Rs. 3600'),
            ]),

            const SizedBox(height: 25),

            PrimaryButton(
              text: '💬 Message Driver',
              onPressed: () {
                // Navigate to Messages
              },
            ),

            const SizedBox(height: 12),

            PrimaryButton(
              text: '📞 Call Driver',
              onPressed: () {
                // Launch Phone Dialer

              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Cancel Booking

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                child: const Text(
                  '❌ Cancel Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }



  Widget infoCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget infoTile(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}