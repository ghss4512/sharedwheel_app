import 'package:flutter/material.dart';
import 'user_details_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class PassengersScreen extends StatefulWidget {
  const PassengersScreen({super.key});

  @override
  State<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends State<PassengersScreen> {
  final AdminService service = AdminService();

  List<UserModel> passengers = [];
  List<UserModel> filteredPassengers = [];

  bool isLoading = true;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPassengers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPassengers() async {
    try {
      passengers = await service.getPassengers();

      filteredPassengers = List.from(passengers);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void searchPassengers(String keyword) {
    keyword = keyword.toLowerCase();

    setState(() {
      filteredPassengers = passengers.where((passenger) {
        return passenger.fullName.toLowerCase().contains(keyword) ||
            passenger.phone.toLowerCase().contains(keyword) ||
            passenger.email.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Passengers'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,
              onChanged: searchPassengers,
              decoration: const InputDecoration(
                hintText: 'Search Passenger',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadPassengers,

              child: isLoading
                  ? const LoadingWidget()
                  : filteredPassengers.isEmpty
                  ? const EmptyStateWidget(message: 'No passengers found')
                  : ListView.builder(
                      itemCount: filteredPassengers.length,
                      itemBuilder: (context, index) {
                        final passenger = filteredPassengers[index];
                        return passengerCard(passenger);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passengerCard(UserModel passenger) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Text(
                    passenger.fullName.isNotEmpty ? passenger.fullName[0] : '?',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        passenger.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(passenger.phone),

                      Text(passenger.email),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('⭐ ${passenger.rating}')),
                Chip(label: Text('${passenger.totalRides} rides')),
                Chip(
                  backgroundColor: passenger.status == 'active'
                      ? Colors.green
                      : Colors.red,
                  label: Text(
                    Functions.toProperCase(passenger.status),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Passenger Details Screen
                      Functions.navigateTo(context, UserDetailsScreen(userId: passenger.id));
                    },
                    child: const Text('View'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      updateStatus(passenger);
                    },

                    child: Text(
                      passenger.status == 'active' ? 'Suspend' : 'Activate',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateStatus(UserModel passenger) async {
    final newStatus = passenger.status == 'active' ? 'suspended' : 'active';
    final result = await service.updateUserStatus(
      userId: passenger.id,
      status: newStatus,
    );
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadPassengers();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
