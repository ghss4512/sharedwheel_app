import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final AdminService service = AdminService();

  bool isLoading = true;

  Map<String, dynamic>? booking;

  @override
  void initState() {
    super.initState();
    loadBooking();
  }

  Future<void> loadBooking() async {
    try {
      final result = await service.getBookingDetails(widget.bookingId);

      if (result['success'] == true) {
        booking = result['booking'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

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
        title: const Text('Booking Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : booking == null
          ? const Center(child: Text('Booking not found'))
          : RefreshIndicator(
              onRefresh: loadBooking,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildPassengerCard(),

                  const SizedBox(height: 16),

                  buildDriverCard(),

                  const SizedBox(height: 16),

                  buildRideCard(),

                  const SizedBox(height: 16),

                  buildBookingCard(),

                  const SizedBox(height: 20),

                  buildActions(),
                ],
              ),
            ),
    );
  }

  Widget buildPassengerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Passenger Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            infoTile('Name', booking!['passenger_name'].toString()),

            infoTile('Phone', booking!['passenger_phone'].toString()),

            infoTile('Email', booking!['passenger_email'].toString()),
          ],
        ),
      ),
    );
  }

  Widget buildDriverCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Driver Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            infoTile('Name', booking!['driver_name'].toString()),

            infoTile('Phone', booking!['driver_phone'].toString()),
          ],
        ),
      ),
    );
  }

  Widget buildRideCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Ride Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            infoTile(
              'Route',
              '${booking!['from_city']} → ${booking!['to_city']}',
            ),

            infoTile('Date', booking!['travel_date'].toString()),

            infoTile('Time', booking!['travel_time'].toString()),

            infoTile('Pickup', booking!['pickup_location'].toString()),

            infoTile('Drop', booking!['drop_location'].toString()),
          ],
        ),
      ),
    );
  }

  Widget buildBookingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Booking Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            infoTile('Seats', booking!['seats_booked'].toString()),

            infoTile('Fare Per Seat', 'Rs. ${booking!['fare_per_seat']}'),

            infoTile('Total Fare', 'Rs. ${booking!['total_fare']}'),

            infoTile('Booking Status', booking!['booking_status'].toString()),

            infoTile('Payment Status', booking!['payment_status'].toString()),
          ],
        ),
      ),
    );
  }

  Widget buildActions() {
    final status = booking!['booking_status'].toString();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pending
            if (status == 'pending') ...[
              actionButton(
                text: 'Approve Booking',
                icon: Icons.check,
                onPressed: approveBooking,
              ),
              const SizedBox(height: 10),
              actionButton(
                text: 'Reject Booking',
                icon: Icons.close,
                color: Colors.orange,
                onPressed: rejectBooking,
              ),
            ],
            // Approved
            if (status == 'approved') ...[
              actionButton(
                text: 'Mark Boarded',
                icon: Icons.directions_car,
                color: Colors.blue,
                onPressed: markBoarded,
              ),
              const SizedBox(height: 10),
              actionButton(
                text: 'Mark No Show',
                icon: Icons.warning,
                color: Colors.red,
                onPressed: markNoShow,
              ),
              const SizedBox(height: 10),
              actionButton(
                text: 'Cancel Booking',
                icon: Icons.cancel,
                color: Colors.orange,
                onPressed: cancelBooking,
              ),
            ],
            // Boarded
            if (status == 'boarded') ...[
              actionButton(
                text: 'Complete Booking',
                icon: Icons.check_circle,
                color: Colors.green,
                onPressed: completeBooking,
              ),
            ],

            // Final States
            if ([
              'completed',
              'cancelled',
              'rejected',
              'no_show',
            ].contains(status))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Booking is $status',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> approveBooking() async {
    final result = await service.approveBooking(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> rejectBooking() async {
    final result = await service.rejectBooking(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> cancelBooking() async {
    final result = await service.cancelBooking(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> markNoShow() async {
    final result = await service.markNoShow(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> markBoarded() async {
    final result = await service.markBoarded(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> completeBooking() async {
    final result = await service.completeBooking(widget.bookingId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      await loadBooking();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
