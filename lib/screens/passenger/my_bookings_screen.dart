import 'package:flutter/material.dart';
import 'package:sharedwheel_app/utils/functions.dart';
import '../../constants/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingService bookingService = BookingService();

  List<BookingModel> bookings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() {
      isLoading = true;
    });
    try {
      bookings = await bookingService.getMyBookings();
    } catch (e) {
      debugPrint('Booking Error: $e');
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
        title: Text('My Bookings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadBookings,
        child: isLoading
            ? LoadingWidget()
            : bookings.isEmpty
            ? EmptyStateWidget(message: 'No bookings found')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return bookingCard(bookings[index]);
                },
              ),
      ),
    );
  }

  Widget bookingCard(BookingModel booking) {
    final Color statusColor = getStatusColor(booking.bookingStatus);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS BADGE
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6,),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.bookingStatus.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ROUTE
            Text(
              '${Functions.toProperCase(booking.fromCity)} → ${Functions.toProperCase(booking.toCity)}',

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            const SizedBox(height: 5),

            // DATE
            Text('📅 Date: ${booking.travelDate}'),

            const SizedBox(height: 5),

            // TIME
            Text('⏰ Time: ${Functions.convertTo12Hour(booking.travelTime)}'),

            const SizedBox(height: 5),

            // SEATS
            Text('👥 Seats Booked: ${booking.seatsBooked}'),

            const SizedBox(height: 5),

            // PAYMENT STATUS
            if (booking.paymentStatus.isNotEmpty)
              Text('💳 Payment: ${booking.paymentStatus.toUpperCase()}'),

            const SizedBox(height: 12),

            // FARE
            Text(
              'Rs. ${Functions.formatCurrency(booking.totalFare, 0)}',

              style: const TextStyle(
                color: AppColors.success,

                fontSize: 20,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
