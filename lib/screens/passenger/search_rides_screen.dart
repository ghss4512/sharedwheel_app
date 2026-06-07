import 'package:flutter/material.dart';
import 'package:sharedwheel_app/utils/app_navigator.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'ride_details_screen.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final RideService rideService = RideService();
  List<RideModel> rides = [];
  bool isLoading = false;
  DateTime? selectedDate;
  Future<void> pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> searchRides() async {
    setState(() { isLoading = true; });
    try {
      final result = await rideService.searchRides(
        fromCity: fromController.text.trim(),
        toCity: toController.text.trim(),
      );

      if (!mounted) return;

      setState(() { rides = result; });
    } catch (e) {
      debugPrint('Search Ride Error: $e',);
    }

    if (!mounted) return;

    setState(() {isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Rides',),
        backgroundColor: const Color(0xFF0D6EFD),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: fromController,
                      decoration: InputDecoration(
                        labelText: 'From City',
                        prefixIcon: const Icon(Icons.location_on,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: toController,
                      decoration: InputDecoration(
                        labelText: 'To City',
                        prefixIcon: const Icon(Icons.flag,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),),
                      ),
                    ),

                    const SizedBox(height: 15),
                    InkWell(
                      onTap: pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(12),),
                        child: Text(
                          selectedDate == null ? 'Select Travel Date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: searchRides,
                        style:ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                        ),
                        child: const Text('Search Rides', style: TextStyle(color: Colors.white,),),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Available Rides', style: Theme.of(context).textTheme.titleLarge,),
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const LoadingWidget()
            else if (rides.isEmpty)
              const EmptyStateWidget(
                message: 'No rides found',
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rides.length,
                itemBuilder:(context, index) {
                  return rideCard(rides[index],);
                },
              ),
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
            Text('${ride.fromCity} → ${ride.toCity}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
            ),

            const SizedBox(height: 8),

            Text('📅 ${ride.travelDate}',),

            Text('⏰ ${ride.travelTime}',),

            Text('👥 ${ride.availableSeats} Seats Available',),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. ${ride.farePerSeat.toStringAsFixed(0)}',
                  style:
                  const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18,),
                ),

                ElevatedButton(
                  onPressed: () {
                    AppNavigator.replace(context, RideDetailsScreen(ride: ride));
                  },

                  child: const Text( 'View Ride',),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}