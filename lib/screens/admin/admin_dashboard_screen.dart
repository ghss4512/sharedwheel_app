import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/admin/passengers_screen.dart';
import 'package:sharedwheel_app/screens/admin/settings_screen.dart';
import 'package:sharedwheel_app/screens/admin/withdrawal_history_screen.dart';
import 'package:sharedwheel_app/widgets/section_title.dart';

import '../../constants/app_colors.dart';
import '../../models/admin/dashboard_stats_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';

import 'deposit_history_screen.dart';
import 'drivers_screen.dart';
import 'pending_deposits_screen.dart';
import 'pending_withdrawals_screen.dart';
import 'verification_list_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService service = AdminService();
  DashboardStatsModel stats = DashboardStatsModel(
    drivers: 0,
    passengers: 0,
    pendingDeposits: 0,
    pendingWithdrawals: 0,
    pendingVerifications: 0,
    activeRides: 0,
  );

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'SharedWheel Administration',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadStats,

        child: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SectionTitle(title: "Overview"),
            ),
            const SizedBox(height: 2),
            Column(
              children: [
                statCard(
                  title: 'Drivers',
                  value: stats.drivers.toString(),
                  icon: Icons.person,
                  index: 1,
                  //For Color
                  onTap: () {
                    Functions.navigateTo(context, DriversScreen());
                    loadStats();
                  },
                ),
                statCard(
                  title: 'Passengers',
                  value: stats.passengers.toString(),
                  icon: Icons.people,
                  index: 2,
                  onTap: () {
                    Functions.navigateTo(context, PassengersScreen());
                    loadStats();
                  },
                ),

                statCard(
                  title: 'Deposits',
                  value: stats.pendingDeposits.toString(),
                  icon: Icons.account_balance_wallet,
                  index: 3,
                  onTap: () {
                    Functions.navigateTo(context, PendingDepositsScreen());
                    loadStats();
                  },
                ),

                statCard(
                  title: 'Withdrawals',
                  value: stats.pendingWithdrawals.toString(),
                  icon: Icons.payments,
                  index: 4,
                  onTap: () {
                    Functions.navigateTo(context, PendingWithdrawalsScreen());
                    loadStats();
                  },
                ),

                statCard(
                  title: 'Verifications',
                  value: stats.pendingVerifications.toString(),
                  icon: Icons.verified,
                  index: 5,
                  onTap: () {
                    Functions.navigateTo(context, VerificationListScreen());
                    loadStats();
                  },
                ),

                statCard(
                  title: 'Active Rides',
                  value: stats.activeRides.toString(),
                  icon: Icons.directions_car,
                  index: 6,
                  onTap: () {},
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SectionTitle(title: "Management"),
            ),

            buildMenuCard(
              icon: Icons.verified_user,
              title: 'Driver Verifications',
              onTap: () {
                Functions.navigateTo(context, VerificationListScreen());
                loadStats();
              },
            ),

            // buildMenuCard(
            //   icon: Icons.account_balance_wallet,
            //   title: 'Pending Deposits',
            //   onTap: () {
            //     Functions.navigateTo(context, const PendingDepositsScreen());
            //     loadStats();
            //   },
            // ),
            buildMenuCard(
              icon: Icons.history,
              title: 'Deposit History',
              onTap: () {
                Functions.navigateTo(context, const DepositHistoryScreen());
                loadStats();
              },
            ),

            buildMenuCard(
              icon: Icons.history,
              title: 'Withdrawal History',
              onTap: () {
                Functions.navigateTo(context, WithdrawalHistoryScreen());
              },
            ),

            // buildMenuCard(
            //   icon: Icons.payments,
            //   title: 'Pending Withdrawals',
            //   onTap: () {
            //     Functions.navigateTo(context, const PendingWithdrawalsScreen());
            //     loadStats();
            //   },
            // ),
            buildMenuCard(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Functions.navigateTo(context, SettingsScreen());
                loadStats();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required int index,
    required VoidCallback onTap,
  }) {
    Color color = AppColors.primary;
    switch (index) {
      case 1:
        color = AppColors.primary;
        break;
      case 2:
        color = AppColors.success;
        break;
      case 3:
        color = AppColors.warning;
        break;
      case 4:
        color = AppColors.danger;
        break;
      case 5:
        color = AppColors.dark;
        break;
      case 6:
        color = AppColors.secondary;
        break;
    }
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: Icon(icon, color: AppColors.primary),
            title: Text(title),
            trailing: buildBadge(value, color),
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
