import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../shared/chat_screen.dart';
import '../shared/create_complaint_screen.dart';
import '../shared/submit_rating_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => MyBookingsScreenState();
}

class MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingService bookingService = BookingService();

  List<BookingModel> bookings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> refreshData() async {
    await loadBookings();
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

  Future<void> cancelBooking(BookingModel booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking?\n\n'
          'A cancellation deduction may apply.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      final result = await bookingService.updateBookingStatus(
        bookingId: booking.id,
        status: 'cancelled',
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Functions.success(context, result['message']);
        await loadBookings();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, 'Unable to cancel booking.');
    }
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
                  return Column(
                    children: [
                      bookingCard(bookings[index]),
                      if (index != bookings.length - 1) bookingSeparator(),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget bookingCard(BookingModel booking) {
    final Color statusColor = getStatusColor(booking.bookingStatus);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withAlpha(15), width: 1.5),
      ),

      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: statusColor, width: 5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.bookingStatus.toLowerCase() != "completed")
                buildCurrentRideStatus(booking.bookingStatus.toUpperCase()),

              const SizedBox(height: 10),

              buildCurrentRideStatus(booking.rideStatus),

              const SizedBox(height: 12),

              if (booking.bookingStatus == 'approved' ||
                  booking.bookingStatus == 'boarded' ||
                  booking.bookingStatus == 'completed')
                buildRideProgress(booking.rideStatus),
              const SizedBox(height: 10),
              // ROUTE
              Text(
                '${Functions.toProperCase(booking.fromCity)} → ${Functions.toProperCase(booking.toCity)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const SizedBox(height: 5),
              // DATE
              Text('📅 Date: ${Functions.formatDate(booking.travelDate)}'),
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

              SizedBox(height: 20),

              OutlinedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text("Message Driver"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        rideId: booking.rideId,
                        otherUserId: booking.driverId,
                        otherUserName: booking.driverName,
                      ),
                    ),
                  );
                },
              ),

              if (booking.bookingStatus == 'approved' ||
                  booking.bookingStatus == 'boarded' ||
                  booking.bookingStatus == 'completed')
                Column(
                  children: [
                    const SizedBox(height: 5),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.report_problem, color: Colors.red),
                      label: const Text(
                        'Report Driver',
                        style: TextStyle(color: AppColors.danger),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateComplaintScreen(
                              rideId: booking.rideId,
                              againstUserId: booking.driverId,
                              againstUserName: booking.driverName,
                            ),
                          ),
                        );

                        if (result == true && mounted) {
                          Functions.success(
                            context,
                            'Complaint submitted successfully.',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                ),

              if ((booking.bookingStatus == 'pending' ||
                      booking.bookingStatus == 'approved') &&
                  booking.rideStatus != 'in_progress' &&
                  booking.rideStatus != 'completed')
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    cancelBooking(booking);
                  },
                ),

              if (booking.bookingStatus == 'completed' &&
                  booking.rideStatus == 'completed')
                if (booking.canRate)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.star),
                    label: const Text('Rate Driver'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.success,
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubmitRatingScreen(
                            rideId: booking.rideId,
                            reviewedUserId: booking.driverId,
                            userName: booking.driverName,
                          ),
                        ),
                      );

                      if (result == true) {
                        await loadBookings();
                      }
                    },
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Rating Submitted',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRideProgress(String rideStatus) {
    final statuses = [
      'enroute',
      'arrived',
      'waiting',
      'in_progress',
      'completed',
    ];

    final currentIndex = statuses.indexOf(rideStatus.toLowerCase());

    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ride Progress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...statuses.asMap().entries.map((entry) {
              final completed = entry.key <= currentIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: completed ? Colors.green : Colors.grey,
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Text(getRideStatusTitle(entry.value)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentRideStatus(String status) {
    IconData icon;
    Color color;
    String title;

    switch (status.toLowerCase()) {
      // Booking Status
      case 'pending':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        title = 'Booking Pending';
        break;

      case 'approved':
        icon = Icons.verified;
        color = Colors.green;
        title = 'Booking Approved';
        break;

      case 'rejected':
        icon = Icons.cancel;
        color = Colors.red;
        title = 'Booking Rejected';
        break;

      case 'cancelled':
        icon = Icons.cancel_outlined;
        color = Colors.red.shade700;
        title = 'Booking Cancelled';
        break;

      case 'boarded':
        icon = Icons.airline_seat_recline_normal;
        color = Colors.indigo;
        title = 'Passenger Boarded';
        break;

      case 'no_show':
        icon = Icons.person_off;
        color = Colors.brown;
        title = 'Passenger Did Not Show';
        break;

      // Ride Status
      case 'scheduled':
        icon = Icons.schedule;
        color = Colors.blueGrey;
        title = 'Ride Scheduled';
        break;

      case 'enroute':
        icon = Icons.directions_car;
        color = Colors.blue;
        title = 'Driver On The Way';
        break;

      case 'arrived':
        icon = Icons.location_on;
        color = Colors.orange;
        title = 'Driver Has Arrived';
        break;

      case 'waiting':
        icon = Icons.hourglass_top;
        color = Colors.deepOrange;
        title = 'Waiting For Passengers';
        break;

      case 'in_progress':
        icon = Icons.route;
        color = Colors.purple;
        title = 'Ride In Progress';
        break;

      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
        title = 'Ride Completed';
        break;

      default:
        icon = Icons.help_outline;
        color = Colors.grey;
        title = 'Unknown Status';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Center(
        child: Row(
          children: [
            Icon(icon, color: color),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRideStatusTitle(String status) {
    switch (status) {
      case 'enroute':
        return 'Driver Started Journey';
      case 'arrived':
        return 'Driver Arrived';
      case 'waiting':
        return 'Waiting For Passengers';
      case 'in_progress':
        return 'Ride In Progress';
      case 'completed':
        return 'Ride Completed';
      default:
        return status;
    }
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

  Widget bookingSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: List.generate(
          30,
          (_) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
