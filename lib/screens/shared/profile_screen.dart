import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'notifications_screen.dart';
import 'messages_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'complaints_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Later load from API
    const String userName = 'Abdul Ghafoor';
    const String phone = '+92 300 1234567';
    const String email = 'abdul@example.com';
    const String userType = 'passenger';
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        userType.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(phone),
                    ),

                    const ListTile(
                      leading: Icon(Icons.email),
                      title: Text(email),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MENU ITEMS
            profileMenuTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                );
              },
            ),

            profileMenuTile(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChangePasswordScreen(),
                    )
                );
              },
            ),

            profileMenuTile(
              icon: Icons.notifications,
              title: 'Notifications',
              badgeCount: 5,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),

            profileMenuTile(
              icon: Icons.message,
              title: 'Messages',
              badgeCount: 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessagesScreen()),
                );
              },
            ),

            profileMenuTile(
              icon: Icons.report_problem,
              title: 'My Complaints',
              badgeCount: 1,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComplaintsScreen(),)
                );
              },
            ),

            if (userType == 'driver') ...[
              profileMenuTile(
                icon: Icons.verified_user,
                title: 'Driver Verification',
                onTap: () {},
              ),

              profileMenuTile(
                icon: Icons.directions_car,
                title: 'Vehicle Information',
                onTap: () {},
              ),
            ],

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(width: 10),

            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),

        onTap: onTap,
      ),
    );
  }
}