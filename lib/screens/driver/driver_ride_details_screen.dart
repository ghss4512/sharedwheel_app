import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/passenger_model.dart';
import '../../models/ride_model.dart';
import '../../services/booking_service.dart';
import '../../services/ride_service.dart';
import '../../utils/functions.dart';
import '../../widgets/primary_button.dart';
import 'dart:async';
import '../../services/settings_service.dart';
import '../../widgets/section_title.dart';
import '../shared/submit_rating_screen.dart';

class DriverRideDetailsScreen extends StatefulWidget {
  final RideModel ride;

  const DriverRideDetailsScreen({super.key, required this.ride});

  @override
  State<DriverRideDetailsScreen> createState() =>
      _DriverRideDetailsScreenState();
}

class _DriverRideDetailsScreenState extends State<DriverRideDetailsScreen> {
  final RideService rideService = RideService();
  final BookingService bookingService = BookingService();
  late RideModel ride;
  final SettingsService settingsService = SettingsService();
  Timer? timer;
  int remainingSeconds = 0;
  List<PassengerModel> passengers = [];
  bool isLoading = false;
  bool waitingExpiredShown = false;

  int get approvedCount =>
      passengers.where((p) => p.bookingStatus == 'approved').length;

  int get boardedCount =>
      passengers.where((p) => p.bookingStatus == 'boarded').length;

  int get noShowCount =>
      passengers.where((p) => p.bookingStatus == 'no_show').length;

  bool get canStartRide =>
      ride.rideStatus == 'waiting' && approvedCount == 0 && boardedCount > 0;

  bool get noPassengersBoarded =>
      ride.rideStatus == 'waiting' && approvedCount == 0 && boardedCount == 0;

  bool get showTimer => ride.rideStatus == 'waiting' && approvedCount > 0;

  @override
  void initState() {
    super.initState();
    ride = widget.ride;
    loadPassengers();

    if (ride.rideStatus == 'waiting') {
      Future.microtask(() async {
        await initializeCountdown();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Functions.toProperCase(ride.fromCity)} → ${Functions.toProperCase(ride.toCity)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Available Seats: ${ride.availableSeats}'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(80),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ride.rideStatus.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          SectionTitle(title: "Passenger Summery"),

          // Passenger Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '$approvedCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Approved'),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        '$boardedCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Boarded'),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        '$noShowCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('No Show'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Waiting Countdown Card
          if (showTimer)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Waiting Time Remaining',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatTime(remainingSeconds),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (noPassengersBoarded)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 50,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'No Passengers Boarded',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 5),

                    Text('$noShowCount passenger(s) marked No Show'),
                  ],
                ),
              ),
            ),

          // All Passengers Processed
          if (canStartRide)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'All Passengers Processed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text('$boardedCount passenger(s) boarded'),

                    Text('$noShowCount passenger(s) no show'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          SectionTitle(title: 'Passengers'),

          if (passengers.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No passengers found'),
              ),
            ),

          ...passengers.map(
            (passenger) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(Functions.toProperCase(passenger.fullName)),
                      subtitle: Text(
                        'Seats: ${passenger.seatsBooked}\n'
                        'Phone: ${passenger.phone}',
                      ),
                      trailing: Text(
                        passenger.bookingStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          color: getStatusColor(passenger.bookingStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (ride.rideStatus == 'waiting' &&
                        passenger.bookingStatus == 'approved')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Boarded',
                                onPressed: () {
                                  confirmBoarded(passenger);
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: PrimaryButton(
                                text: 'No Show',
                                onPressed: () {
                                  confirmNoShow(passenger);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (ride.rideStatus == 'completed')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: passenger.canRate
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.star),
                                  label: const Text('Rate Passenger'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SubmitRatingScreen(
                                          rideId: ride.id,
                                          reviewedUserId: passenger.passengerId,
                                          userName: passenger.fullName,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      await loadPassengers();
                                    }
                                  },
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
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
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          if (ride.rideStatus == 'scheduled')
            PrimaryButton(
              text: 'Start Journey',
              onPressed: () {
                confirmStartJourney();
              },
            ),

          if (ride.rideStatus == 'enroute')
            PrimaryButton(
              text: 'I Have Arrived',
              onPressed: () {
                updateRideStatus('arrived');
              },
            ),

          if (ride.rideStatus == 'arrived')
            PrimaryButton(
              text: 'Start Waiting',
              onPressed: () {
                confirmStartWaiting();
              },
            ),

          if (canStartRide)
            PrimaryButton(
              text: 'Start Ride',
              onPressed: () {
                confirmStartRide();
              },
            ),

          if (ride.rideStatus == 'in_progress')
            PrimaryButton(
              text: 'Complete Ride',
              onPressed: () {
                confirmCompleteRide();
              },
            ),
        ],
      ),
    );
  }

  Future<void> loadPassengers() async {
    setState(() {
      isLoading = true;
    });

    try {
      passengers = await rideService.getRidePassengers(ride.id);
      if (ride.rideStatus == 'waiting' && approvedCount == 0) {
        timer?.cancel();
        remainingSeconds = 0;
        waitingExpiredShown = false;
      }
    } catch (e) {
      debugPrint('Passengers Error: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> initializeCountdown() async {
    if (ride.waitingStartedAt == null || ride.waitingStartedAt!.isEmpty) {
      return;
    }
    final waitingMinutes = await settingsService.getDriverWaitingTime();
    final waitingStart = DateTime.parse(ride.waitingStartedAt!);

    final elapsedSeconds = DateTime.now().difference(waitingStart).inSeconds;
    final totalSeconds = waitingMinutes * 60;
    remainingSeconds = totalSeconds - elapsedSeconds;
    if (remainingSeconds < 0) {
      remainingSeconds = 0;
    }

    startTimer();
  }

  Future<void> refreshRide() async {
    final updatedRide = await rideService.getRideDetails(ride.id);
    if (updatedRide == null) {
      return;
    }
    if (!mounted) return;
    setState(() {
      ride = updatedRide;
    });
  }

  Future<void> updateRideStatus(String status) async {
    try {
      final result = await rideService.updateRideStatus(
        rideId: ride.id,
        status: status,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final message = result['message'];

        await refreshRide();
        if (ride.rideStatus == 'waiting') {
          await loadPassengers();
          await initializeCountdown();
        }
        if (!mounted) return;
        Functions.success(context, message);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      debugPrint('Update Ride Status Error: $e');
      if (!mounted) return;
      Functions.error(context, 'Unable to update ride status.');
    }
  }

  Future<void> updatePassengerStatus(int bookingId, String status) async {
    debugPrint('Updating Booking: $bookingId -> $status');
    try {
      final result = await bookingService.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      debugPrint('API Result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        await loadPassengers();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      debugPrint('Update Passenger Error: $e');

      if (!mounted) return;

      Functions.error(context, 'Unable to update passenger status.');
    }
  }

  Future<void> confirmStartJourney() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Journey'),
        content: const Text('Start traveling toward the pickup location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updateRideStatus('enroute');
    }
  }

  Future<void> confirmArrival() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arrival Confirmation'),
        content: const Text('Have you reached the pickup location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updateRideStatus('arrived');
    }
  }

  Future<void> confirmStartWaiting() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Waiting'),
        content: const Text('Passenger waiting timer will begin now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start Waiting'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updateRideStatus('waiting');
    }
  }

  Future<void> confirmNoShow(PassengerModel passenger) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark No Show'),
        content: Text('Mark ${passenger.fullName} as No Show?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updatePassengerStatus(passenger.bookingId, 'no_show');
    }
  }

  Future<void> confirmBoarded(PassengerModel passenger) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Passenger Boarded'),
        content: Text('Confirm ${passenger.fullName} boarded?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updatePassengerStatus(passenger.bookingId, 'boarded');
    }
  }

  Future<void> confirmStartRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Ride'),
        content: const Text('Are all boarded passengers seated and ready?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Start Ride'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updateRideStatus('in_progress');
    }
  }

  Future<void> confirmCompleteRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Ride'),
        content: const Text('Mark this ride as completed?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await updateRideStatus('completed');
    }
  }

  Future<void> showWaitingExpiredDialog() async {
    final approvedPassengers = passengers
        .where((p) => p.bookingStatus == 'approved')
        .length;
    final boardedPassengers = passengers
        .where((p) => p.bookingStatus == 'boarded')
        .length;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Waiting Time Expired'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Boarded Passengers: '
              '$boardedPassengers',
            ),
            const SizedBox(height: 8),
            Text(
              'Pending Passengers: '
              '$approvedPassengers',
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              extendWaitingTime();
            },
            child: const Text('Extend 5 Min'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              markRemainingNoShows();
            },
            child: const Text('Mark Remaining No Shows'),
          ),
        ],
      ),
    );
  }

  Future<void> showStartRideDialog(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('No Shows Processed'),
        content: Text(
          '$message\n\n'
          'Would you like to start the ride now?',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Later'),
          ),

          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await updateRideStatus('in_progress');
            },
            child: const Text('Start Ride'),
          ),
        ],
      ),
    );
  }

  Future<void> markRemainingNoShows() async {
    final result = await bookingService.markRemainingNoShows(ride.id);
    if (!mounted) return;
    if (result['success'] == true) {
      await loadPassengers();
      if (!mounted) return;
      await showStartRideDialog(result['message']);
    } else {
      Functions.error(context, result['message']);
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        if (waitingExpiredShown) return;
        waitingExpiredShown = true;
        if (!mounted) return;
        showWaitingExpiredDialog();
      }
    });
  }

  void extendWaitingTime() {
    setState(() {
      remainingSeconds += 5 * 60;
      waitingExpiredShown = false;
    });
    startTimer();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;

      case 'boarded':
        return Colors.green;

      case 'no_show':
        return Colors.red;

      case 'completed':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }
}
