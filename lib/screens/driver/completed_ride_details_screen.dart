import 'package:flutter/material.dart';
import '../../screens/shared/user_reviews_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/passenger_model.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/section_title.dart';
import '../shared/my_complaints_screen.dart';

class CompletedRideDetailsScreen extends StatefulWidget {
  final RideModel ride;

  const CompletedRideDetailsScreen({super.key, required this.ride});

  @override
  State<CompletedRideDetailsScreen> createState() =>
      _CompletedRideDetailsScreenState();
}

class _CompletedRideDetailsScreenState
    extends State<CompletedRideDetailsScreen> {
  final RideService rideService = RideService();
  List<PassengerModel> passengers = [];
  bool isLoading = true;
  late RideModel ride;

  int get boardedCount => passengers
      .where((p) => p.bookingStatus.toLowerCase() == 'boarded')
      .length;

  int get noShowCount => passengers
      .where((p) => p.bookingStatus.toLowerCase() == 'no_show')
      .length;

  @override
  void initState() {
    super.initState();
    ride = widget.ride;
    loadPassengers();
  }

  Future<void> loadPassengers() async {
    try {
      passengers = await rideService.getRidePassengers(ride.id, ride.driverId);
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
        title: const Text('Completed Ride'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionTitle(title: 'Ride Summery'),
                rideSummaryCard(),

                const SizedBox(height: 15),
                SectionTitle(title: 'Ride Performance'),
                performanceCard(),

                const SizedBox(height: 15),

                SectionTitle(title: 'Passengers'),
                const SizedBox(height: 10),
                ...passengers.map((p) => passengerCard(p)),

                SectionTitle(title: 'Post Ride Actions'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.star),
                            label: const Text('View Reviews'),
                            onPressed: () {
                              Functions.navigateTo(
                                context,
                                UserReviewsScreen(
                                  userId: ride.driverId,
                                  userName: 'My Reviews',
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.report_problem),
                            label: const Text('View Complaints'),
                            onPressed: () {
                              Functions.navigateTo(
                                context,
                                const MyComplaintsScreen(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildStatusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'boarded':
        color = Colors.green;
        break;

      case 'no_show':
        color = Colors.red;
        break;

      case 'approved':
        color = Colors.blue;
        break;

      case 'completed':
        color = Colors.teal;
        break;

      case 'rejected':
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget rideSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${Functions.toProperCase(ride.fromCity)} → '
                    '${Functions.toProperCase(ride.toCity)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            infoRow(Icons.calendar_month, 'Date', ride.travelDate),
            infoRow(
              Icons.access_time,
              'Time',
              Functions.convertTo12Hour(ride.travelTime),
            ),
            infoRow(Icons.event_seat, 'Seats', ride.totalSeats.toString()),
            infoRow(
              Icons.currency_exchange,
              'Fare',
              'Rs. ${Functions.formatCurrency(ride.farePerSeat, 0)}',
            ),
            infoRow(Icons.directions_car, 'Vehicle', ride.vehicleName),
            const Divider(),

            infoRow(Icons.location_on, 'Pickup', ride.pickupLocation),

            infoRow(Icons.flag, 'Drop', ride.dropLocation),
          ],
        ),
      ),
    );
  }

  Widget performanceCard() {
    return Row(
      children: [
        Expanded(
          child: performanceItem(
            '$boardedCount',
            'Boarded',
            Colors.green,
            Icons.check_circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: performanceItem(
            '$noShowCount',
            'No Show',
            Colors.red,
            Icons.person_off,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: performanceItem(
            '${passengers.length}',
            'Passengers',
            Colors.blue,
            Icons.people,
          ),
        ),
      ],
    );
  }

  Widget performanceItem(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget passengerCard(PassengerModel passenger) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(passenger.fullName.substring(0, 1).toUpperCase()),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Functions.toProperCase(passenger.fullName),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Seats: ${passenger.seatsBooked}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  buildStatusBadge(passenger.bookingStatus),
                ],
              ),
            ),

            passenger.canRate
                ? const Icon(Icons.star_border, color: Colors.amber)
                : const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),

        Text(label),
      ],
    );
  }

  Widget infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 8),

          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
