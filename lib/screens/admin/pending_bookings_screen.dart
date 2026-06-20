import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'booking_details_screen.dart';

class PendingBookingsScreen extends StatefulWidget {
  const PendingBookingsScreen({super.key});

  @override
  State<PendingBookingsScreen> createState() => _PendingBookingsScreenState();
}

class _PendingBookingsScreenState extends State<PendingBookingsScreen> {
  final AdminService service = AdminService();

  List<BookingModel> bookings = [];
  List<BookingModel> filteredBookings = [];

  bool isLoading = true;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadBookings() async {
    try {
      bookings = await service.getPendingBookings();
      filteredBookings = List.from(bookings);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void searchBookings(String keyword) {
    keyword = keyword.toLowerCase();

    setState(() {
      filteredBookings = bookings.where((booking) {
        return booking.fromCity.toLowerCase().contains(keyword) ||
            booking.toCity.toLowerCase().contains(keyword) ||
            booking.driverName.toLowerCase().contains(keyword) ||
            booking.passengerName.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Pending Bookings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,

              onChanged: searchBookings,

              decoration: const InputDecoration(
                hintText: 'Search booking...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadBookings,

              child: isLoading
                  ? const LoadingWidget()
                  : filteredBookings.isEmpty
                  ? const EmptyStateWidget(message: 'No pending bookings found')
                  : ListView.builder(
                      itemCount: filteredBookings.length,

                      itemBuilder: (context, index) {
                        return bookingCard(filteredBookings[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingCard(BookingModel booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              '${booking.fromCity} → ${booking.toCity}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Passenger: ${booking.passengerName}'),

            Text('Driver: ${booking.driverName}'),

            Text('Seats: ${booking.seatsBooked}'),

            Text('Fare: Rs. ${Functions.formatCurrency(booking.totalFare, 0)}'),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: [
                Chip(label: Text(booking.bookingStatus)),

                Chip(label: Text(booking.paymentStatus)),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  Functions.navigateTo(
                    context,
                    BookingDetailsScreen(bookingId: booking.id),
                  );
                },

                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
