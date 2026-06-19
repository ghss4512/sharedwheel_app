import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'passenger_home_screen.dart';
import 'search_rides_screen.dart';
import 'my_bookings_screen.dart';
import '../shared/wallet_screen.dart';
import '../shared/profile_screen.dart';

class PassengerDashboard extends StatefulWidget {
  const PassengerDashboard({super.key});

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  int currentIndex = 0;

  final homeKey = GlobalKey<HomeScreenState>();
  final searchKey = GlobalKey<SearchRidesScreenState>();
  final bookingsKey = GlobalKey<MyBookingsScreenState>();
  final walletKey = GlobalKey<WalletScreenState>();
  final profileKey = GlobalKey<ProfileScreenState>();

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(key: homeKey),
      SearchRidesScreen(key: searchKey),
      MyBookingsScreen(key: bookingsKey),
      WalletScreen(key: walletKey,),
      ProfileScreen(key: profileKey,),
    ];
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              await homeKey.currentState?.refreshData();
              break;
            case 1:
              await searchKey.currentState?.refreshData();
              break;
            case 2:
              await bookingsKey.currentState?.refreshData();
              break;
            case 3:
              await walletKey.currentState?.refreshData();
              break;
            case 4:
              await profileKey.currentState?.refreshData();
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
