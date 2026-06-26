import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/base_state.dart';
import '../../services/dashboard_service.dart';
import '../../services/driver_verification_service.dart';
import '../../services/notification_service.dart';
import '../../services/rating_service.dart';
import '../../services/vehicle_service.dart';
import '../../services/wallet_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../admin/driver_verification_screen.dart';
import '../auth/login_screen.dart';
import '../driver/active_rides_screen.dart';
import '../driver/ride_requests_screen.dart';
import '../driver/vehicle_list_screen.dart';
import '../public/contact_support_screen.dart';
import '../shared/change_password_screen.dart';
import '../shared/conversations_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/my_complaints_screen.dart';
import '../shared/notifications_screen.dart';
import '../shared/user_reviews_screen.dart';
import '../shared/wallet_screen.dart';
import 'completed_rides_screen.dart';
import 'my_rides_screen.dart';
import 'post_ride_screen.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends BaseState<DriverDashboardScreen> {
  int pendingRequests = 0;
  int activeRides = 0;
  int completedRides = 0;
  int unreadNotifications = 0;
  int vehicleCount = 0;

  double walletBalance = 0;
  double driverRating = 5.0;
  int totalRatings = 0;

  String verificationStatus = 'not_submitted';
  bool isLoading = false;

  Map<String, dynamic>? upcomingRide;

  @override
  void onInit() {
    loadCounts();
  }

  @override
  void onResume() {
    loadCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, size: 32),
                onPressed: () {
                  Functions.navigateTo(
                    context,
                    NotificationsScreen(),
                  ).then((_) => loadCounts());
                },
              ),
              if (unreadNotifications > 0)
                Positioned(
                  right: 2,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadNotifications > 99
                          ? '99+'
                          : unreadNotifications.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          PopupMenuButton<String>(
            offset: const Offset(0, 55),

            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  AppSession.fullName.toString().isNotEmpty
                      ? AppSession.fullName.toString()[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Functions.navigateTo(context, const EditProfileScreen());
                  break;
                case 'password':
                  Functions.navigateTo(context, ChangePasswordScreen());
                  break;
                case 'logout':
                  AppSession.clearSession();
                  Functions.replaceWith(context, LoginScreen());
                  break;
              }
            },

            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppSession.fullName.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      AppSession.userType.toString().toUpperCase(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const Divider(),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: AppColors.primary),
                    SizedBox(width: 10),
                    Text('My Profile'),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'password',
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: AppColors.info),
                    SizedBox(width: 10),
                    Text('Change Password'),
                  ],
                ),
              ),

              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.danger),
                    SizedBox(width: 10),
                    Text('Logout', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadCounts,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppSession.fullName ?? 'Driver'} 👋',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.green,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  'Rs. ${walletBalance.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.15,
                        children: [
                          buildMenuCard(
                            icon: Icons.list_alt,
                            title: 'Pending Requests',
                            badge: pendingRequests.toString(),
                            color: Colors.orange,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                RideRequestsScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.route,
                            title: 'Active Rides',
                            badge: activeRides.toString(),
                            color: Colors.green,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                ActiveRidesScreen(),
                              );
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.task_alt,
                            title: 'Completed Rides',
                            badge: completedRides.toString(),
                            color: Colors.blue,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                const CompletedRidesScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.directions_car,
                            title: 'Vehicles',
                            badge: vehicleCount.toString(),
                            color: Colors.indigo,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                VehicleListScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            badge: unreadNotifications.toString(),
                            color: Colors.blueGrey,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                NotificationsScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.star,
                            title: 'Rating',
                            badge: driverRating.toStringAsFixed(1),
                            color: Colors.amber,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                UserReviewsScreen(
                                  userId: AppSession.userId!,
                                  userName: AppSession.fullName!,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.25,
                        children: [
                          buildMenuCard(
                            icon: Icons.add_circle,
                            title: 'Post Ride',
                            color: Colors.deepPurple,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                PostRideScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.directions_car,
                            title: 'My Rides',
                            color: Colors.green,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                const MyRidesScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.account_balance_wallet,
                            title: 'Wallet',
                            color: Colors.teal,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                WalletScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.chat,
                            title: 'Messages',
                            color: Colors.indigo,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                const ConversationsScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Upcoming Ride',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                if (upcomingRide == null)
                                  const Text('No upcoming rides')
                                else ...[
                                  Text(
                                    '${upcomingRide!['from_city']} → '
                                    '${upcomingRide!['to_city']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    '${upcomingRide!['travel_date']} '
                                    '${upcomingRide!['travel_time']}',
                                  ),

                                  Text(
                                    'Fare: Rs. ${Functions.formatCurrency(double.parse(upcomingRide!['fare_per_seat'] ?? 0), 0)}',
                                  ),

                                  Text(
                                    'Seats: ${upcomingRide!['available_seats']}',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Text(
                          'Driver Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.25,
                        children: [
                          buildMenuCard(
                            icon: Icons.report_problem,
                            title: 'Complaints',
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                MyComplaintsScreen(),
                              );
                            },
                          ),
                          buildMenuCard(
                            icon: Icons.verified_user,
                            title: 'Verification',
                            badge: verificationStatus,
                            color: verificationStatus == 'approved'
                                ? Colors.green
                                : verificationStatus == 'pending'
                                ? Colors.orange
                                : Colors.red,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                DriverVerificationScreen(),
                              ).then((_) => loadCounts());
                            },
                          ),
                          buildMenuCard(
                            icon: Icons.emergency,
                            title: 'SOS',
                            color: Colors.red,
                            onTap: () {
                              Functions.info(
                                context,
                                'Emergency feature coming soon',
                              );
                            },
                          ),

                          buildMenuCard(
                            icon: Icons.support_agent,
                            title: 'Support',
                            color: Colors.blue,
                            onTap: () {
                              Functions.navigateTo(
                                context,
                                const ContactSupportScreen(),
                              );
                              Functions.info(context, 'Support coming soon');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> loadCounts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dashboardService = DashboardService();

      pendingRequests = await dashboardService.getPendingRequestsCount();

      activeRides = await dashboardService.getActiveRidesCount();

      completedRides = await dashboardService.getCompletedRidesCount();

      vehicleCount = await VehicleService().getVehicleCount();

      unreadNotifications = await NotificationService().getUnreadCount();

      final wallet = await WalletService().getWallet();
      walletBalance = wallet.balance;

      final verificationResult = await DriverVerificationService().getStatus();
      if (verificationResult['submitted'] == true) {
        verificationStatus = verificationResult['verification']['status'];
      } else {
        verificationStatus = 'not_submitted';
      }

      final ratings = await RatingService().getUserRatings(AppSession.userId!);
      if (ratings['success'] == true) {
        driverRating =
            double.tryParse(ratings['user']['rating'].toString()) ?? 5.0;
        totalRatings =
            int.tryParse(ratings['user']['total_ratings'].toString()) ?? 0;
      }
      upcomingRide = await dashboardService.getUpcomingRide();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
    Color color = AppColors.primary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              if (badge != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
