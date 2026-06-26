import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/passenger_completed_ride_model.dart';
import '../../services/passenger_dashboard_service.dart';
import '../../utils/functions.dart';
import '../shared/chat_screen.dart';
import '../shared/submit_rating_screen.dart';

class PassengerCompletedRideDetailsScreen extends StatefulWidget {
  final int rideId;

  const PassengerCompletedRideDetailsScreen({super.key, required this.rideId});

  @override
  State<PassengerCompletedRideDetailsScreen> createState() =>
      _PassengerCompletedRideDetailsScreenState();
}

class _PassengerCompletedRideDetailsScreenState
    extends State<PassengerCompletedRideDetailsScreen> {
  final PassengerDashboardService dashboardService =
      PassengerDashboardService();
  PassengerCompletedRideModel? ride;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRide();
  }

  Future<void> loadRide() async {
    ride = await dashboardService.getCompletedRideDetails(
      rideId: widget.rideId,
    );
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Completed Ride'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ride == null
          ? const Center(child: Text("Ride not found"))
          : RefreshIndicator(
              onRefresh: loadRide,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  statusCard(),

                  const SizedBox(height: 15),

                  driverCard(),

                  const SizedBox(height: 15),

                  routeCard(),

                  const SizedBox(height: 15),

                  vehicleCard(),

                  const SizedBox(height: 15),

                  bookingCard(),

                  const SizedBox(height: 15),

                  paymentCard(),

                  const SizedBox(height: 15),

                  ratingCard(),

                  const SizedBox(height: 15),

                  actionButtons(),

                  const SizedBox(height: 20),

                  thankYouCard(),
                ],
              ),
            ),
    );
  }

  Widget statusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),

            const SizedBox(height: 10),

            const Text(
              'Ride Completed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              ride!.rideStatus.toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget driverCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primary.withAlpha(20),
                  backgroundImage: ride!.driverPhoto.isNotEmpty
                      ? NetworkImage(ride!.driverPhoto)
                      : null,
                  child: ride!.driverPhoto.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        )
                      : null,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride!.driverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),

                          const SizedBox(width: 4),

                          Text(
                            ride!.driverRating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            '(${ride!.totalReviews} Reviews)',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.green,
                          ),

                          const SizedBox(width: 5),

                          Text(ride!.driverPhone),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget routeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(Icons.trip_origin, color: Colors.green),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    Functions.toProperCase(ride!.fromCity),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.only(left: 11),
              child: SizedBox(height: 30, child: VerticalDivider(thickness: 2)),
            ),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    Functions.toProperCase(ride!.toCity),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget vehicleCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            detailRow(Icons.directions_car, 'Vehicle', ride!.vehicleName),

            const Divider(),

            detailRow(
              Icons.confirmation_number,
              'Registration No.',
              ride!.vehicleNumber,
            ),

            const Divider(),

            detailRow(Icons.palette, 'Color', ride!.vehicleColor),
          ],
        ),
      ),
    );
  }

  Widget bookingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            detailRow(Icons.receipt_long, 'Booking ID', '#${ride!.bookingId}'),

            const Divider(),

            detailRow(
              Icons.event_seat,
              'Seats Booked',
              ride!.seatsBooked.toString(),
            ),

            const Divider(),

            detailRow(
              Icons.verified,
              'Booking Status',
              ride!.bookingStatus.toUpperCase(),
            ),

            const Divider(),

            detailRow(Icons.calendar_today, 'Booked On', ride!.bookingDate),
          ],
        ),
      ),
    );
  }

  Widget paymentCard() {
    return Card(
      // color: Colors.green.withAlpha(15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            detailRow(
              Icons.payments,
              'Fare / Seat',
              'Rs. ${ride!.farePerSeat}',
            ),

            const Divider(),

            detailRow(Icons.event_seat, 'Seats', ride!.seatsBooked.toString()),

            const Divider(),

            detailRow(
              Icons.account_balance_wallet,
              'Total Paid',
              'Rs. ${ride!.totalFare}',
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (ride!.alreadyRated) ...[
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < ride!.myRating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                ride!.myReview.isEmpty ? 'No written review.' : ride!.myReview,
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.star),
                  label: const Text('Rate Driver'),
                  onPressed: () {
                    // TODO
                    // Open rating dialog
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget thankYouCard() {
    return Card(
      color: AppColors.primary.withAlpha(15),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 40),

            const SizedBox(height: 10),

            const Text(
              'Thank You!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Thank you for travelling with SharedWheel.\n'
              'We hope to serve you again soon.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget tripDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            detailRow(Icons.calendar_month, 'Travel Date', ride!.travelDate),

            const Divider(),

            detailRow(
              Icons.access_time,
              'Departure Time',
              Functions.convertTo12Hour(ride!.travelTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget fareCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.currency_exchange, size: 35, color: Colors.green),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Fare Per Seat', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Text(
              'Rs. ${ride!.farePerSeat}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButtons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      Functions.launchPhone(phone: ride!.driverPhone);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      Functions.navigateTo(
                        context,
                        ChatScreen(
                          rideId: ride!.rideId,
                          otherUserId: ride!.driverId,
                          otherUserName: ride!.driverName,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            if (!ride!.alreadyRated) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.star_rate),
                  label: const Text('Rate Driver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () async {
                    final result = await Functions.navigateTo(
                      context,
                      SubmitRatingScreen(
                        rideId: ride!.rideId,
                        reviewedUserId: ride!.driverId,
                        userName: ride!.driverName,
                      ),
                    );

                    if (result == true) {
                      await loadRide();
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),

        const SizedBox(width: 15),

        Expanded(child: Text(title)),

        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
