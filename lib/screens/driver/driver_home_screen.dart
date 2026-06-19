import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/driver/vehicle_list_screen.dart';
import 'package:sharedwheel_app/screens/shared/driver_verification_screen.dart';
import 'package:sharedwheel_app/screens/shared/messages_screen.dart';
import '../../constants/app_colors.dart';
import '../../services/dashboard_service.dart';
import '../../services/driver_verification_service.dart';
import '../../services/notification_service.dart';
import '../../services/vehicle_service.dart';
import '../../screens/driver/post_ride_screen.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../shared/complaints_screen.dart';
import 'completed_rides_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => DriverHomeScreenState();
}

class DriverHomeScreenState extends State<DriverHomeScreen> {
  int pendingRequests = 0;
  int activeRides = 0;
  int completedRides = 0;
  int unreadNotifications = 0;
  int vehicleCount = 0;

  String verificationStatus = 'not_submitted';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
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
                      AppSession.fullName ?? 'Passenger',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                tileColor: AppColors.primary.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                leading: const Icon(Icons.hourglass_top),
                title: const Text('Pending'),
                subtitle: Text("Requests"),
                trailing: buildBadge(
                  pendingRequests.toString(),
                  AppColors.primary,
                ),
              ),

              ListTile(
                tileColor: AppColors.success.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                leading: const Icon(Icons.route),
                title: const Text('Active'),
                subtitle: Text("Rides"),
                trailing: buildBadge(
                  activeRides.toString(),
                  AppColors.dark,
                ),
              ),

              ListTile(
                hoverColor: Colors.grey,
                tileColor: AppColors.danger.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                leading: const Icon(Icons.task_alt),
                title: const Text('Completed'),
                subtitle: Text("Rides History"),
                trailing: buildBadge(
                  completedRides.toString(),
                  AppColors.success,
                ),
                onTap: () async {
                  await Functions.navigateToAsync(
                    context,
                    const CompletedRidesScreen(),
                  );
                  loadCounts();
                },
              ),

              ListTile(
                hoverColor: Colors.grey,
                tileColor: Colors.indigo.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                leading: const Icon(Icons.task_alt),
                title: const Text('Registered'),
                subtitle: Text("Vehicles"),
                trailing: buildBadge(
                  vehicleCount.toString(),
                  AppColors.warning,
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Messages'),
                  trailing: buildBadge('2', Colors.indigo.withAlpha(200)),
                  onTap: () {
                    Functions.navigateTo(context, MessagesScreen());
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.report_problem),
                  title: const Text('Complaints'),
                  trailing: buildBadge('1', AppColors.success),
                  onTap: () {
                    Functions.navigateTo(context, ComplaintsScreen());
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Driver Verification'),
                  trailing: buildVerificationBadge(),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DriverVerificationScreen(),
                      ),
                    );
                    loadCounts();
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: const Text('Vehicle Information'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VehicleListScreen()),
                    );
                    loadCounts();
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Post New Ride'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final result = await DriverVerificationService()
                        .getStatus();
                    String status = 'not_submitted';
                    if (result['submitted'] == true) {
                      status = result['verification']['status'];
                    }
                    if (status != 'approved') {
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Verification Required'),
                          content: Text(
                            status == 'pending'
                                ? 'Your verification is currently under review.'
                                : status == 'rejected'
                                ? 'Your verification was rejected. Please resubmit your documents.'
                                : 'You must complete driver verification before posting rides.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Functions.navigateTo(
                                  context,
                                  DriverVerificationScreen(),
                                );
                              },
                              child: const Text('Open Verification'),
                            ),
                          ],
                        ),
                      );

                      return;
                    }
                    if (!context.mounted) return;
                    Functions.navigateTo(context, PostRideScreen());
                  },
                ),
              ),
            ],
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

      final verificationResult = await DriverVerificationService().getStatus();
      if (verificationResult['submitted'] == true) {
        verificationStatus = verificationResult['verification']['status'];
      } else {
        verificationStatus = 'not_submitted';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
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

  Widget buildVerificationBadge() {
    Color color = Colors.grey;
    String text = 'Not Submitted';

    switch (verificationStatus) {
      case 'approved':
        color = Colors.green;
        text = 'Approved';
        break;

      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;

      case 'rejected':
        color = Colors.red;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
