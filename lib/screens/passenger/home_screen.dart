import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/passenger/my_bookings_screen.dart';
import 'package:sharedwheel_app/screens/passenger/search_rides_screen.dart';
import 'package:sharedwheel_app/screens/shared/wallet_screen.dart';
import 'package:sharedwheel_app/utils/functions.dart';
import '../../constants/app_colors.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../utils/app_session.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../shared/messages_screen.dart';
import '../shared/notifications_screen.dart';
import 'ride_details_screen.dart';

class HomeScreen extends StatefulWidget {
  // final Function(int) onNavigate;
  // const HomeScreen({super.key, required this.onNavigate});
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  final RideService rideService = RideService();
  List<RideModel> rides = [];
  bool isLoading = false;
  @override
  void initState() { super.initState(); loadRides();}

  Future<void> refreshData() async {
    // reload dashboard stats
    loadRides();
  }

  Future<void> loadRides() async {
    setState(() { isLoading = true; });
    try {
      rides = await rideService.getAvailableRides();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('SharedWheel'),
        actions: [
          IconButton(onPressed: () {
              Functions.navigateTo(context, NotificationsScreen());
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),

      body: RefreshIndicator(onRefresh: loadRides,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// Welcome Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30,
                    child: Icon(Icons.person,),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome Back 👋', style: TextStyle(color:Colors.grey,),),
                        const SizedBox(height: 5,),
                        Text(AppSession.fullName ?? 'Guest User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Quick Actions
            const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: actionCard(icon: Icons.search, title: 'Search Ride',
                  onTap: () {
                      Functions.navigateTo(context, SearchRidesScreen());
                    // widget.onNavigate(1);
                    }
                    ,)
                  ,),
                const SizedBox(width: 12),
                Expanded(child: actionCard(icon: Icons.book, title: 'Bookings',
                  onTap: () {
                  // widget.onNavigate(2);
                    Functions.navigateTo(context, MyBookingsScreen());
                  },
                ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: actionCard(icon: Icons.account_balance_wallet, title: 'Wallet',
                  onTap: () {
                  // widget.onNavigate(3);
                    Functions.navigateTo(context, WalletScreen());
                  },
                ),
                ),
                const SizedBox(width: 12),
                Expanded(child: actionCard(icon: Icons.message, title: 'Messages',
                  onTap: () {
                    Functions.navigateTo(context, MessagesScreen());
                  }
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            /// Available Rides
            const Text('Available Rides', style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const LoadingWidget()
            else if (rides.isEmpty)
              const EmptyStateWidget(message: 'No rides available',)
            else
              ...rides.take(5).map((ride) => rideCard(ride,),
              ),
          ],
        ),
      ),
    );
  }

  Widget actionCard({required IconData icon, required String title, required VoidCallback onTap,}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary,),
            const SizedBox(height: 10,),
            Text(Functions.toProperCase(title), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }

  Widget rideCard(RideModel ride) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
            ),

            const SizedBox(height: 8,),

            Text('👤 ${Functions.toProperCase(ride.driverName)}',),
            Text('⭐ ${ride.rating.toStringAsFixed(1)}',),
            Text('👥 ${ride.availableSeats} Seats Available',),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. ${ride.farePerSeat.toStringAsFixed(0)}', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 18,),),
                ElevatedButton(
                  onPressed: () {
                    Functions.navigateTo(context, RideDetailsScreen(ride: ride));
                  },
                  child: const Text('View',),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}