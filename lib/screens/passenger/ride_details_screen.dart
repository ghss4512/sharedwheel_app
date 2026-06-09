import 'package:flutter/material.dart';
import 'package:sharedwheel_app/models/ride_model.dart';
import 'package:sharedwheel_app/screens/passenger/my_bookings_screen.dart';
import 'package:sharedwheel_app/widgets/section_title.dart';
import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../utils/functions.dart';
import '../../utils/app_session.dart';
import '../../services/booking_service.dart';

class RideDetailsScreen extends StatefulWidget {
  final RideModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  int seatsBooked = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DRIVER CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person, size: 35),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ride.driverName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '⭐ ${widget.ride.rating.toStringAsFixed(1)} Rating',
                          ),
                          Text('🚗 ${widget.ride.totalRides} Rides Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // QUICK INFO
            Row(
              children: [
                Expanded(child: infoCard('📅', 'Date', widget.ride.travelDate)),
                const SizedBox(width: 10),
                Expanded(child: infoCard('⏰', 'Time', Functions.convertTo12Hour(widget.ride.travelTime))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: infoCard(
                    '👥',
                    'Seats',
                    widget.ride.availableSeats.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: infoCard(
                    '💰',
                    'Fare',
                    'Rs. ${Functions.formatCurrency(widget.ride.farePerSeat, 0)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ROUTE
            SectionTitle(title: '🛣 Route Summary'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '📍 ${Functions.toProperCase(widget.ride.fromCity)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Center(child: Icon(Icons.arrow_right)),
                    SizedBox(height: 8),
                    Text(
                      '🎯 ${Functions.toProperCase(widget.ride.toCity)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // VEHICLE
            SectionTitle(title: '🚗 Vehicle Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text(Functions.toProperCase(widget.ride.vehicleName)),
                    ),

                    Divider(),

                    ListTile(
                      leading: const Icon(Icons.confirmation_number),
                      title: Text(widget.ride.vehicleNumber.toUpperCase()),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text(Functions.toProperCase(widget.ride.vehicleColor)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LUGGAGE
            SectionTitle(title: '🎒 Luggage Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: AppColors.success),

                    SizedBox(width: 10),

                    Expanded(child: Text('Luggage Allowed')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SectionTitle(title: '💺 Select Seats'),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: seatsBooked > 1
                              ? () {
                                  setState(() {
                                    seatsBooked--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove_circle),
                        ),
                        Text(
                          seatsBooked.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: seatsBooked < widget.ride.availableSeats
                              ? () {
                                  setState(() {
                                    seatsBooked++;
                                  });
                                }
                              : null,

                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Total Fare: ${Functions.formatCurrency(widget.ride.farePerSeat * seatsBooked, 0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                text: isLoading ? 'Processing...' : '🚗 Request Ride',
                onPressed: isLoading ? null : requestRide,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String icon, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> requestRide() async {
    if (AppSession.userId == null) {
      Functions.error(context, 'Please login again.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await BookingService().bookRide(
        rideId: widget.ride.id,
        passengerId: AppSession.userId!,
        seatsBooked: seatsBooked,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);
        Functions.replaceWith(context, MyBookingsScreen());
        // Navigator.pop(context);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }
}
