import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'home_screen.dart';
import 'search_rides_screen.dart';
import 'my_bookings_screen.dart';
import 'wallet_screen.dart';
import '../shared/profile_screen.dart';

class PassengerDashboard extends StatefulWidget {
  const PassengerDashboard({super.key});

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  int currentIndex = 0;
  final List<Widget> screens = const [
    HomeScreen(),
    SearchRidesScreen(),
    MyBookingsScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens,),

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search',),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings',),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',),
        ],
      ),
    );
  }
}