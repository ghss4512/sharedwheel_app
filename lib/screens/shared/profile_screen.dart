import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/auth/login_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/profile_model.dart';

// import '../../services/notification_service.dart';
import '../../services/profile_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

// import 'driver_verification_screen.dart';
// import 'notifications_screen.dart';
// import 'messages_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
// import 'complaints_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ProfileService profileService = ProfileService();
  ProfileModel? profile;
  bool isLoading = false;

  // int unreadNotificationCount = 0;
  // final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    loadProfile();
    // loadNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : profile == null
          ? const Center(child: Text('Unable to load profile'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  // PROFILE CARD
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: profile!.profilePhoto.isNotEmpty
                                ? NetworkImage(profile!.profilePhoto)
                                : null,
                            child: profile!.profilePhoto.isEmpty
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            Functions.toProperCase(profile!.fullName),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 10),
                              Text(
                                profile!.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(' (${profile!.totalRatings} ratings)'),
                            ],
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
                              profile!.userType.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          if (profile!.isVerified)
                            const Chip(
                              avatar: Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 18,
                              ),
                              label: Text('Verified'),
                            ),

                          const SizedBox(height: 5),

                          if (profile!.city.isNotEmpty)
                            ListTile(
                              leading: const Icon(Icons.location_city),
                              title: Text(profile!.city),
                            ),

                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text(profile!.phone),
                          ),

                          ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(profile!.email),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          statItem(
                            Icons.route,
                            'Rides',
                            profile!.totalRides.toString(),
                          ),

                          statItem(
                            Icons.cancel,
                            'Cancelled',
                            profile!.cancellationCount.toString(),
                          ),

                          statItem(
                            Icons.warning_amber,
                            'No Shows',
                            profile!.noShowCount.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        logout();
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

  Future<void> refreshData() async {
    await loadProfile();
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

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      profile = await profileService.getProfile();
    } catch (e) {
      debugPrint('Profile Error: $e');
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Widget statItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    await AppSession.clearSession();

    if (!mounted) return;

    Functions.replaceWith(context, LoginScreen());
  }
}
