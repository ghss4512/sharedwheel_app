import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/driver/ride_requests_screen.dart';
import '../../constants/app_colors.dart';
import '../shared/profile_screen.dart';
import 'driver_home_screen.dart';
import 'my_rides_screen.dart';
import 'post_ride_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    DriverHomeScreen(),
    MyRidesScreen(),
    RideRequestsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'My Rides',),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Requests',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}