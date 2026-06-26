import 'package:flutter/material.dart';
import '../../models/ride_model.dart';
import '../../services/passenger_dashboard_service.dart';
import 'passenger_active_ride_details_screen.dart';
import '../../utils/functions.dart';

class ActiveRidesScreen extends StatefulWidget {
  const ActiveRidesScreen({super.key});

  @override
  State<ActiveRidesScreen> createState() => _ActiveRidesScreenState();
}

class _ActiveRidesScreenState extends State<ActiveRidesScreen> {
  final PassengerDashboardService service = PassengerDashboardService();

  List<RideModel> rides = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    rides = await service.getActiveRides();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Active Rides')),

      body: ListView.builder(
        itemCount: rides.length,

        itemBuilder: (context, index) {
          final ride = rides[index];

          return Card(
            margin: const EdgeInsets.all(8),

            child: ListTile(
              leading: const Icon(Icons.route, color: Colors.green),

              title: Text('${ride.fromCity} → ${ride.toCity}'),

              subtitle: Text('${ride.travelDate} ${ride.travelTime}'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Functions.navigateTo(
                  context,

                  PassengerActiveRideDetailsScreen(ride: ride),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
