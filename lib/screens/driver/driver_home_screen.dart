import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../utils/app_session.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    AppSession.fullName ?? 'Driver',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: ListTile(
                leading: Icon(Icons.pending_actions),
                title: Text('Pending Requests'),
                trailing: Text('0'),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Active Rides'),
                trailing: Text('0'),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Completed Rides'),
                trailing: Text('0'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}