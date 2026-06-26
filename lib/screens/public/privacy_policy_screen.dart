import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              'SharedWheel values your privacy and is committed to protecting your personal information.',
            ),

            SizedBox(height: 20),

            Text(
              'Information We Collect',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              '• Name\n'
              '• Email Address\n'
              '• Phone Number\n'
              '• Profile Information\n'
              '• Ride Booking Information\n'
              '• Messages exchanged between users',
            ),

            SizedBox(height: 20),

            Text(
              'How We Use Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'We use collected information to provide ride-sharing services, improve user experience, communicate important updates, and maintain platform security.',
            ),

            SizedBox(height: 20),

            Text(
              'Information Sharing',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'SharedWheel does not sell personal information to third parties. Information is only shared when necessary to provide ride-sharing services.',
            ),

            SizedBox(height: 20),

            Text('Security', style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 8),

            Text(
              'We implement reasonable security measures to protect user data from unauthorized access and misuse.',
            ),

            SizedBox(height: 20),

            Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 8),

            Text(
              'For privacy-related questions, please contact SharedWheel support through the application.',
            ),

            SizedBox(height: 30),

            Center(
              child: Text(
                'Last Updated: June 2026',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
