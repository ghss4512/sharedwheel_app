import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('About ${AppInfo.appName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withAlpha(20),
                  child: const Icon(
                    Icons.directions_car,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  AppInfo.appName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Ride Sharing Made Easy',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    AppInfo.version,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              subtitle: Text(
                '${AppInfo.appName} is a ride-sharing platform that connects drivers and passengers for safe, affordable and convenient travel.',
              ),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.security),
              title: Text('Safety'),
              subtitle: Text('Verified drivers and secure ride management.'),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.support_agent),
              title: Text('Support'),
              subtitle: Text('Contact support through the app for assistance.'),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              AppInfo.copyright,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
