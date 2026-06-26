import 'package:flutter/material.dart';
import 'package:shared_wheel/constants/base_state.dart';
import 'package:shared_wheel/screens/admin/ride_fares_screen.dart';

import '../../constants/app_colors.dart';
import '../../models/admin/dashboard_stats_model.dart';
import '../../services/admin_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../../widgets/section_title.dart';
import '../auth/login_screen.dart';
import '../shared/change_password_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/notifications_screen.dart';
import 'active_rides_screen.dart';
import 'admin_complaints_screen.dart';
import 'cancelled_rides_screen.dart';
import 'cities_screen.dart';
import 'completed_rides_screen.dart';
import 'deposit_history_screen.dart';
import 'drivers_screen.dart';
import 'passengers_screen.dart';
import 'pending_deposits_screen.dart';
import 'pending_withdrawals_screen.dart';
import 'scheduled_rides_screen.dart';
import 'settings_screen.dart';
import 'verification_list_screen.dart';
import 'withdrawal_history_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends BaseState<AdminDashboardScreen> {
  final AdminService service = AdminService();
  DashboardStatsModel stats = DashboardStatsModel(
    drivers: 0,
    passengers: 0,
    activeUsers: 0,
    pendingBookings: 0,
    activeRides: 0,
    cancelledRides: 0,
    completedRides: 0,
    pendingComplaints: 0,
    pendingDeposits: 0,
    pendingVerifications: 0,
    pendingWithdrawals: 0,
    scheduledRides: 0,
    suspendedUsers: 0,
    totalBookings: 0,
    totalComplaints: 0,
    totalDeposits: 0,
    totalWithdrawals: 0,
    unverifiedDrivers: 0,
    verifiedDrivers: 0,
    totalRideFares: 0,
    totalCities: 0,
  );
  bool isLoading = true;

  @override
  void onInit() {
    loadStats();
  }

  @override
  void onResume() {
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      stats = await service.getDashboardStats();
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
        toolbarHeight: 80.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Adjust the radius size here
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            const Text(
              'Welcome Admin 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Text(
              'SharedWheel Platform',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Functions.navigateTo(context, NotificationsScreen());
            },
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
                  loadStats();
                  break;
                case 'password':
                  Functions.navigateTo(context, ChangePasswordScreen());
                  break;
                case 'settings':
                  Functions.navigateTo(context, SettingsScreen());
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

              if (AppSession.userType == 'admin')
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, color: AppColors.success),
                      SizedBox(width: 10),
                      Text('Settings'),
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
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadStats,
        child: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SectionTitle(title: 'Needs Attention'),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  dashboardCard(
                    icon: Icons.verified_user,
                    title: 'Verifications',
                    value: stats.pendingVerifications.toString(),
                    color: Colors.orange,
                    onTap: () {
                      Functions.navigateTo(context, VerificationListScreen());
                    },
                  ),

                  dashboardCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Deposits',
                    value: stats.pendingDeposits.toString(),
                    color: Colors.green,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const PendingDepositsScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.payments,
                    title: 'Withdrawals',
                    value: stats.pendingWithdrawals.toString(),
                    color: Colors.red,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const PendingWithdrawalsScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.support_agent,
                    title: 'Complaints',
                    value:
                        "${stats.pendingComplaints}/${stats.totalComplaints}",
                    color: Colors.purple,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const AdminComplaintsScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.route,
                    title: 'Ride Fares',
                    value: stats.totalRideFares.toString(),
                    color: Colors.green,
                    onTap: () {
                      Functions.navigateTo(context, const RideFaresScreen());
                    },
                  ),

                  dashboardCard(
                    icon: Icons.location_city,
                    title: 'Cities',
                    value: stats.totalCities.toString(),
                    color: Colors.indigo,
                    onTap: () {
                      Functions.navigateTo(context, const CitiesScreen());
                    },
                  ),

                ],
              ),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Ride Management'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  dashboardCard(
                    icon: Icons.schedule,
                    title: 'Scheduled Rides',
                    value: "${stats.scheduledRides}",
                    color: Colors.blue,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const ScheduledRidesScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.route,
                    title: 'Active Rides',
                    value: '${stats.activeRides}',
                    color: Colors.green,
                    onTap: () {
                      Functions.navigateTo(context, const ActiveRidesScreen());
                    },
                  ),

                  dashboardCard(
                    icon: Icons.check_circle,
                    title: 'Completed Rides',
                    value: '${stats.completedRides}',
                    color: Colors.indigo,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const CompletedRidesScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.cancel,
                    title: 'Cancelled Rides',
                    value: '${stats.cancelledRides}',
                    color: Colors.red,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const CancelledRidesScreen(),
                      );
                    },
                  ),
                ],
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Financials'),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  dashboardCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Deposit History',
                    value: '${stats.totalDeposits}',
                    color: Colors.green,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const DepositHistoryScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.payments,
                    title: 'Withdrawal History',
                    value: '${stats.totalWithdrawals}',
                    color: Colors.red,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const WithdrawalHistoryScreen(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 20),
            Divider(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Users'),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  dashboardCard(
                    icon: Icons.person,
                    title: 'Drivers',
                    value: '${stats.drivers}',
                    color: Colors.blue,
                    onTap: () {
                      Functions.navigateTo(context, const DriversScreen());
                    },
                  ),

                  dashboardCard(
                    icon: Icons.people,
                    title: 'Passengers',
                    value: '${stats.passengers}',
                    color: Colors.green,
                    onTap: () {
                      Functions.navigateTo(context, const PassengersScreen());
                    },
                  ),
                ],
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Platform'),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  dashboardCard(
                    icon: Icons.support_agent,
                    title: 'Complaints',
                    value:
                        '${stats.pendingComplaints}/${stats.totalComplaints}',
                    color: Colors.deepOrange,
                    onTap: () {
                      Functions.navigateTo(
                        context,
                        const AdminComplaintsScreen(),
                      );
                    },
                  ),

                  dashboardCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    value: '',
                    color: Colors.blueGrey,
                    onTap: () {
                      Functions.navigateTo(context, SettingsScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget dashboardCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 2),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
