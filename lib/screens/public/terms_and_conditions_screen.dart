import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              'By using SharedWheel, you agree to the following terms and conditions.',
            ),

            SizedBox(height: 20),

            Text(
              '1. User Responsibilities',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'Users must provide accurate information during registration and maintain the confidentiality of their account credentials.',
            ),

            SizedBox(height: 20),

            Text(
              '2. Ride Bookings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'Passengers are responsible for confirming ride details before booking. Drivers are responsible for providing accurate ride information.',
            ),

            SizedBox(height: 20),

            Text('3. Payments', style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 8),

            Text(
              'All wallet deposits, withdrawals, and ride payments are subject to verification and approval where applicable.',
            ),

            SizedBox(height: 20),

            Text(
              '4. Prohibited Activities',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'Users must not engage in fraudulent activities, harassment, abuse, impersonation, or misuse of the platform.',
            ),

            SizedBox(height: 20),

            Text(
              '5. Driver Verification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'SharedWheel may require drivers to submit verification documents before offering rides on the platform.',
            ),

            SizedBox(height: 20),

            Text(
              '6. Limitation of Liability',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'SharedWheel acts as a platform connecting drivers and passengers and is not responsible for actions, delays, disputes, or incidents occurring during rides.',
            ),

            SizedBox(height: 20),

            Text(
              '7. Account Suspension',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'SharedWheel reserves the right to suspend or terminate accounts that violate platform policies.',
            ),

            SizedBox(height: 20),

            Text(
              '8. Changes to Terms',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'SharedWheel may update these terms at any time. Continued use of the platform constitutes acceptance of updated terms.',
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
