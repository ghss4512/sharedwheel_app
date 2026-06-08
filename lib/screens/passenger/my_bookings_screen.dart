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
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${Functions.toProperCase(booking.fromCity)} → ${Functions.toProperCase(booking.toCity)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ],
            ),

            const SizedBox(height: 12),
            Text('📅 ${booking.travelDate}'),
            Text('⏰ ${Functions.convertTo12Hour(booking.travelTime)}'),
            Text('👥 Seats: ${booking.seatsBooked}'),
            const SizedBox(height: 10),
            Text('Rs. ${Functions.formatCurrency(booking.totalFare, 0)}',
              style: const TextStyle(color: AppColors.success, fontSize: 18, fontWeight: FontWeight.bold,),
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