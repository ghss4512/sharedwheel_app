import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/driver/ride_requests_screen.dart';
import '../../constants/app_colors.dart';
import '../shared/profile_screen.dart';
import '../shared/wallet_screen.dart';
import 'driver_home_screen.dart';
import 'my_rides_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int currentIndex = 0;
  final ridesKey = GlobalKey<MyRidesScreenState>();
  final requestsKey = GlobalKey<RideRequestsScreenState>();
  final walletKey = GlobalKey<WalletScreenState>();

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      DriverHomeScreen(),
      MyRidesScreen(key: ridesKey),
      RideRequestsScreen(key: requestsKey),
      WalletScreen(key: walletKey),
      ProfileScreen(),
    ];
  }

  void refreshCurrentTab(int index) {
    switch (index) {
      case 1:
        ridesKey.currentState?.loadRides();
        break;

      case 2:
        requestsKey.currentState?.loadRequests();
        break;

      case 3:
        walletKey.currentState?.loadWallet();
        break;
    }
  }

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

          refreshCurrentTab(index);
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'My Rides',),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Requests',),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
