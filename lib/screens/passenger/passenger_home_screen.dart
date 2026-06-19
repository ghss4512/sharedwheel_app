import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/passenger/my_bookings_screen.dart';
import 'package:sharedwheel_app/screens/shared/messages_screen.dart';
import 'package:sharedwheel_app/screens/shared/notifications_screen.dart';

import '../../constants/app_colors.dart';
import '../../services/notification_service.dart';
import '../../services/passenger_dashboard_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../shared/complaints_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int totalBookings = 0;
  int activeBookings = 0;
  int completedBookings = 0;

  int unreadNotifications = 0;
  int unreadMessages = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
      completedBookings = await dashboardService.getCompletedBookingsCount();

      completedBookings = await dashboardService.getCompletedBookingsCount();
      unreadNotifications = await NotificationService().getUnreadCount();

      // Until messages module is completed
      unreadMessages = 0;

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
        title: const Text('Passenger Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadCounts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),

          child: Column(
            spacing: 5,
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
                      "${AppSession.userId ?? 0} : ${AppSession.fullName ?? 'Passenger'}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: AppColors.primary.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.book_online),
                  title: const Text('Bookings'),
                  subtitle: const Text('Total'),
                  trailing: Text(
                    totalBookings.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Functions.navigateTo(context, const MyBookingsScreen());
                  },
                ),
              ),

              Card(
                color: AppColors.success.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.route),
                  title: const Text('Active'),
                  subtitle: const Text('Bookings'),
                  trailing: Text(
                    activeBookings.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),

              Card(
                color: AppColors.danger.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: const Text('Completed'),
                  subtitle: const Text('Bookings'),
                  trailing: Text(
                    completedBookings.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),

              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.search),
              //     title: const Text('Search Rides'),
              //     trailing: const Icon(Icons.arrow_forward_ios),
              //     onTap: () {
              //       Functions.navigateTo(context, const SearchRidesScreen());
              //     },
              //   ),
              // ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: unreadNotifications > 0
                      ? buildBadge(unreadNotifications.toString(), Colors.red)
                      : const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Functions.navigateTo(context, const NotificationsScreen());
                    loadCounts();
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Messages'),
                  trailing: unreadMessages > 0
                      ? buildBadge(unreadMessages.toString(), Colors.blue)
                      : const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Functions.navigateTo(context, const MessagesScreen());
                    loadCounts();
                  },
                ),
              ),

              // Card(
              //   child: ListTile(
              //     leading: const Icon(Icons.account_balance_wallet),
              //     title: const Text('Wallet'),
              //     trailing: const Icon(Icons.arrow_forward_ios),
              //     onTap: () {
              //       Functions.navigateTo(context, const WalletScreen());
              //     },
              //   ),
              // ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.report_problem),
                  title: const Text('Complaints'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Functions.navigateTo(context, const ComplaintsScreen());
                  },
                ),
              ),
            ],
          ),
        ),
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
