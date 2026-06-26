import 'package:flutter/material.dart';

import '../../models/city_model.dart';
import '../../models/ride_model.dart';
import '../../services/city_service.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/searchable_city_dropdown.dart';
import 'ride_details_screen.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => SearchRidesScreenState();
}

class SearchRidesScreenState extends State<SearchRidesScreen> {
  List<CityModel> cities = [];
  final CityService cityService = CityService();
  CityModel? selectedFromCity;
  CityModel? selectedToCity;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final RideService rideService = RideService();
  List<RideModel> rides = [];
  bool isLoading = false;
  DateTime? selectedDate;

  @override
  initState() {
    super.initState();
    searchRides();
    loadCities();
  }

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

  Future<void> refreshData() async {
    await searchRides();
  }

  Future<void> searchRides() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await rideService.searchRides(
        fromCityId: selectedFromCity?.id,
        toCityId: selectedToCity?.id,
        travelDate: selectedDate,
      );

      if (!mounted) return;

      setState(() {
        rides = result;
      });
    } catch (e) {
      debugPrint('Search Ride Error: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadCities() async {
    cities = await cityService.getActiveCities();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Rides'),
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
                  spacing: 10,
                  children: [
                    SearchableCityDropdown(
                      label: 'From City',
                      icon: Icons.location_on,
                      cities: cities,
                      selectedCity: selectedFromCity,
                      onChanged: (city) {
                        setState(() {
                          selectedFromCity = city;
                        });
                      },
                    ),

                    SearchableCityDropdown(
                      label: 'To City',
                      icon: Icons.flag,
                      cities: cities,
                      selectedCity: selectedToCity,
                      onChanged: (city) {
                        setState(() {
                          selectedToCity = city;
                        });
                      },
                    ),

                    // TextField(
                    //   controller: fromController,
                    //   decoration: InputDecoration(
                    //     labelText: 'From City',
                    //     prefixIcon: const Icon(Icons.location_on),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 15),
                    //
                    // TextField(
                    //   controller: toController,
                    //   decoration: InputDecoration(
                    //     labelText: 'To City',
                    //     prefixIcon: const Icon(Icons.flag),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),

                    // const SizedBox(height: 15),
                    InkWell(
                      onTap: pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedDate == null
                              ? 'Select Travel Date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: searchRides,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                        ),
                        child: const Text(
                          'Search Rides',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Rides',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const LoadingWidget()
            else if (rides.isEmpty)
              const EmptyStateWidget(message: 'No rides found')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  return rideCard(rides[index]);
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
            Text(
              '${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('📍 Pickup: ${ride.pickupLocation}'),
            Text('🏁 Drop: ${ride.dropLocation}'),
            const SizedBox(height: 8),
            Text('📅 ${ride.travelDate}'),
            Text('⏰ ${Functions.convertTo12Hour(ride.travelTime)}'),

            Text('👥 ${ride.availableSeats} Seats Available'),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Functions.navigateTo(
                      context,
                      RideDetailsScreen(ride: ride),
                    );
                  },

                  child: const Text('View Ride'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
