import 'package:flutter/material.dart';
import 'package:sharedwheel_app/widgets/section_title.dart';
import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Ride Details',),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DRIVER CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person, size: 35),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ali Raza',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text('⭐ 4.8 Rating'),
                          const Text('🚗 120 Rides Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // QUICK INFO
            Row(
              children: [
                Expanded(child: infoCard('📅', 'Date', '10 Jun 2026')),
                const SizedBox(width: 10),
                Expanded(child: infoCard('⏰', 'Time', '08:00 AM')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: infoCard('👥', 'Seats', '3')),
                const SizedBox(width: 10),
                Expanded(child: infoCard('💰', 'Fare', 'Rs. 1800')),
              ],
            ),
            const SizedBox(height: 20),
            // ROUTE
            SectionTitle(title: '🛣 Route Summary'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '📍 Lahore',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Center(child: Icon(Icons.arrow_downward)),
                    SizedBox(height: 8),
                    Text(
                      '🎯 Islamabad',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // VEHICLE
            SectionTitle(title: '🚗 Vehicle Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.directions_car),
                      title: Text('Toyota Corolla'),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(Icons.confirmation_number),
                      title: Text('ABC-123'),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text('White'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LUGGAGE
            SectionTitle(title: '🎒 Luggage Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: AppColors.success),

                    SizedBox(width: 10),

                    Expanded(child: Text('Luggage Allowed')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                text: '🚗 Request Ride',
                onPressed: () {
                  // Request Ride API
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String icon, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
