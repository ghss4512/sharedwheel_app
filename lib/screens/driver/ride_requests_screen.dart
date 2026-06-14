import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../utils/functions.dart';
import '../../models/booking_request_model.dart';
import '../../services/booking_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class RideRequestsScreen extends StatefulWidget {
  const RideRequestsScreen({super.key});

  @override
  State<RideRequestsScreen> createState() => RideRequestsScreenState();
}

class RideRequestsScreenState extends State<RideRequestsScreen> {
  final BookingService bookingService = BookingService();
  List<BookingRequestModel> requests = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    setState(() {
      isLoading = true;
    });
    try {
      requests = await bookingService.getRideRequests();
    } catch (e) {
      debugPrint('Request Error: $e');
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
        title: const Text('Ride Requests'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadRequests,
        child: isLoading
            ? const LoadingWidget()
            : requests.isEmpty
            ? const EmptyStateWidget(message: 'No pending requests')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return requestCard(requests[index]);
                },
              ),
      ),
    );
  }

  Widget requestCard(BookingRequestModel request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.passengerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),
            Text(request.passengerPhone),
            const SizedBox(height: 10),
            Text(
              '${Functions.toProperCase(request.fromCity)} → ${Functions.toProperCase(request.toCity)}',
            ),
            Text('📅 ${request.travelDate}'),
            Text('⏰ ${Functions.convertTo12Hour(request.travelTime)}'),
            Text('👥 Seats: ${request.seatsBooked}'),
            const SizedBox(height: 10),
            Text(
              'Rs. ${Functions.formatCurrency(request.totalFare, 0)}',
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // approve
                      approveRequest(request);
                    },

                    child: const Text('Approve'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // reject
                      rejectRequest(request);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),

                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> approveRequest(BookingRequestModel request) async {
    try {
      final result = await bookingService.updateBookingStatus(bookingId: request.bookingId, status: 'approved');

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        await loadRequests();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    }
  }

  Future<void> rejectRequest(BookingRequestModel request) async {
    try {
      final result = await bookingService.rejectBooking(request.bookingId);

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        await loadRequests();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, e.toString());
    }
  }
}
