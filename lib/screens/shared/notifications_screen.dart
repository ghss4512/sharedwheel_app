import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          notificationCard(
            icon: Icons.check_circle,
            iconColor: AppColors.success,
            title: 'Ride Request Accepted',
            message:
            'Your booking for Lahore → Islamabad has been accepted.',
            time: '5 minutes ago',
          ),

          notificationCard(
            icon: Icons.account_balance_wallet,
            iconColor: AppColors.primary,
            title: 'Wallet Credited',
            message:
            'Rs. 500 has been added to your wallet.',
            time: '1 hour ago',
          ),

          notificationCard(
            icon: Icons.directions_car,
            iconColor: Colors.orange,
            title: 'New Ride Available',
            message:
            'A new ride matching your route has been posted.',
            time: 'Today',
          ),

          notificationCard(
            icon: Icons.info,
            iconColor: Colors.purple,
            title: 'System Notification',
            message:
            'Welcome to SharedWheel.',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }

  Widget notificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor:
          iconColor.withAlpha(38),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}