import 'package:flutter/material.dart';
import 'package:shared_wheel/constants/base_state.dart';
import '../passenger/passenger_completed_rides_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/message_service.dart';
import '../../services/notification_service.dart';
import '../../services/passenger_dashboard_service.dart';
import '../../services/profile_service.dart';
import '../../services/wallet_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../../widgets/section_title.dart';
import '../auth/login_screen.dart';
import '../passenger/my_bookings_screen.dart';
import '../passenger/search_rides_screen.dart';
import '../shared/change_password_screen.dart';
import '../shared/conversations_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/my_complaints_screen.dart';
import '../shared/notifications_screen.dart';
import '../shared/user_reviews_screen.dart';
import '../shared/wallet_screen.dart';
import 'active_rides_screen.dart';
import 'passenger_active_ride_details_screen.dart';

class PassengerDashboardScreen extends StatefulWidget {
  const PassengerDashboardScreen({super.key});

  @override
  State<PassengerDashboardScreen> createState() =>
      _PassengerDashboardScreenState();
}

class _PassengerDashboardScreenState extends BaseState<PassengerDashboardScreen> {
  int totalBookings = 0;
  int activeBookings = 0;
  int completedBookings = 0;
  int unreadNotifications = 0;
  int unreadMessages = 0;
  double walletBalance = 0;
  double rating = 0;
  int totalRatings = 0;
  bool isLoading = false;

  RideModel? activeRide, recentRide;

  @override
  void onInit() {
    loadCounts();
  }

  @override
  void onResume() {
    loadCounts();
  }

  Future<void> refreshData() async {
    await loadCounts();
  }

  Future<void> loadCounts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dashboardService = PassengerDashboardService();
      totalBookings = await dashboardService.getPassengerBookingsCount();
      activeBookings = await dashboardService.getActiveBookingsCount();
      activeRide = await dashboardService.getActiveRide();
      recentRide = await dashboardService.getRecentRide();
      completedBookings = await dashboardService.getCompletedBookingsCount();
      unreadNotifications = await NotificationService().getUnreadCount();
      final wallet = await WalletService().getWallet();
      walletBalance = wallet.balance;
      unreadMessages = await MessageService().getUnreadCount(
        userId: AppSession.userId!,
      );
      final profile = await ProfileService().getProfile();

      if (profile != null) {
        rating = profile.rating;
        totalRatings = profile.totalRatings;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(
              AppSession.fullName ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),

        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () async {
                  await Functions.navigateTo(
                    context,
                    const NotificationsScreen(),
                  );

                  loadCounts();
                },
              ),

              if (unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadNotifications > 99
                          ? '99+'
                          : unreadNotifications.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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

      body: RefreshIndicator(
        onRefresh: loadCounts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),

          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppSession.fullName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // const Text('Wallet Balance'),
                          Text(
                            'Rs. ${walletBalance.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Functions.navigateTo(
                    //       context,
                    //       const WalletScreen(),
                    //     );
                    //   },
                    //   child: const Text('Wallet'),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              ratingCard(),
              if (activeRide != null) activeRideCard() else recentRideCard(),
              const SizedBox(height: 10),
              statisticsSection(),
              const SizedBox(height: 10),
              SectionTitle(title: "Quick Actions"),
              quickActions(),
              const SizedBox(height: 10),
              SectionTitle(title: "Services"),
              servicesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget statisticsSection() {
    return Row(
      children: [
        Expanded(
          child: statCard(
            title: 'Total',
            value: totalBookings.toString(),
            icon: Icons.book_online,
            color: Colors.blue,
            screen: const MyBookingsScreen(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: statCard(
            title: 'Active',
            value: activeBookings.toString(),
            icon: Icons.route,
            color: Colors.green,
            screen: const ActiveRidesScreen(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: statCard(
            title: 'Completed',
            value: completedBookings.toString(),
            icon: Icons.task_alt,
            color: Colors.orange,
            screen: const PassengerCompletedRidesScreen(),
          ),
        ),
      ],
    );
  }

  Widget quickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        dashboardCard(
          icon: Icons.search,
          title: 'Find Ride',
          color: Colors.blue,
          onTap: () {
            Functions.navigateTo(context, const SearchRidesScreen());
          },
        ),

        dashboardCard(
          icon: Icons.book,
          title: 'Bookings',
          color: Colors.green,
          onTap: () {
            Functions.navigateTo(context, const MyBookingsScreen());
          },
        ),

        dashboardCard(
          icon: Icons.account_balance_wallet,
          title: 'Wallet',
          color: Colors.teal,
          onTap: () {
            Functions.navigateTo(context, const WalletScreen());
          },
        ),

        dashboardCard(
          icon: Icons.chat,
          title: 'Messages',
          badgeCount: unreadMessages,
          color: Colors.deepPurple,
          onTap: () {
            Functions.navigateTo(context, const ConversationsScreen());
          },
        ),
      ],
    );
  }

  Widget servicesSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        dashboardCard(
          icon: Icons.star,
          title: 'Reviews',
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

        dashboardCard(
          icon: Icons.report_problem,
          title: 'Complaints',
          color: Colors.red,
          onTap: () {
            Functions.navigateTo(context, const MyComplaintsScreen());
          },
        ),

        dashboardCard(
          icon: Icons.notifications,
          title: 'Notifications',
          badgeCount: unreadNotifications,
          color: Colors.indigo,
          onTap: () async {
            await Functions.navigateTo(context, const NotificationsScreen());

            loadCounts();
          },
        ),

        dashboardCard(
          icon: Icons.person,
          title: 'Profile',
          color: Colors.blueGrey,
          onTap: () {
            Functions.navigateTo(context, const EditProfileScreen());
          },
        ),
      ],
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      onTap: () {
        Functions.navigateTo(context, screen);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),

            const SizedBox(height: 8),

            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Stack(
          children: [
            if (badgeCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 30),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activeRideCard() {
    if (activeRide == null) {
      return const SizedBox();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.green),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'Current Ride',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    activeRide!.rideStatus.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              '${Functions.toProperCase(activeRide!.fromCity)} → '
              '${Functions.toProperCase(activeRide!.toCity)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_month, size: 18),

                const SizedBox(width: 6),

                Text(activeRide!.travelDate),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.access_time, size: 18),

                const SizedBox(width: 6),

                Text(Functions.convertTo12Hour(activeRide!.travelTime)),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.visibility),
                label: const Text('View Ride'),
                onPressed: () {
                  Functions.navigateTo(
                    context,
                    PassengerActiveRideDetailsScreen(ride: activeRide!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recentRideCard() {
    if (recentRide == null) {
      return const SizedBox();
    }

    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.history)),

        title: Text('${recentRide!.fromCity} → ${recentRide!.toCity}'),

        subtitle: Text(recentRide!.rideStatus.toUpperCase()),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {
          Functions.navigateTo(
            context,
            PassengerActiveRideDetailsScreen(ride: recentRide!),
          );
        },
      ),
    );
  }

  Widget ratingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.amber, size: 30),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '$totalRatings Reviews',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                Functions.navigateTo(
                  context,
                  UserReviewsScreen(
                    userId: AppSession.userId!,
                    userName: AppSession.fullName!,
                  ),
                );
              },
              child: const Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}
