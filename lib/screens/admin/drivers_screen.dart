import 'package:flutter/material.dart';
import 'user_details_screen.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final AdminService service = AdminService();
  List<UserModel> drivers = [];
  List<UserModel> filteredDrivers = [];
  bool isLoading = true;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadDrivers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadDrivers() async {
    try {
      drivers = await service.getDrivers();
      filteredDrivers = List.from(drivers);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void searchDrivers(String keyword) {
    keyword = keyword.toLowerCase();
    setState(() {
      filteredDrivers = drivers.where((driver) {
        return driver.fullName.toLowerCase().contains(keyword) ||
            driver.phone.toLowerCase().contains(keyword) ||
            driver.email.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Drivers'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchDrivers,
              decoration: const InputDecoration(
                hintText: 'Search Driver',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadDrivers,
              child: isLoading
                  ? const LoadingWidget()
                  : filteredDrivers.isEmpty
                  ? const EmptyStateWidget(message: 'No drivers found')
                  : ListView.builder(
                      itemCount: filteredDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = filteredDrivers[index];
                        return driverCard(driver);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget driverCard(UserModel driver) {
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
                    driver.fullName.isNotEmpty ? driver.fullName[0] : '?',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(driver.phone),

                      Text(driver.email),
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
                Chip(label: Text('⭐ ${driver.rating}')),
                Chip(label: Text('🚗 ${driver.totalRides} rides')),
                Chip(
                  backgroundColor: driver.isVerified
                      ? Colors.green
                      : Colors.orange,
                  label: Text(
                    driver.isVerified ? 'Verified' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Chip(
                  backgroundColor: driver.status == 'active'
                      ? Colors.green
                      : Colors.red,
                  label: Text(
                    Functions.toProperCase(driver.status),
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
                      // Driver Details Screen
                      Functions.navigateTo(context, UserDetailsScreen(userId: driver.id));
                    },
                    child: const Text('View'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      updateStatus(driver);
                    },
                    child: Text(
                      driver.status == 'active' ? 'Suspend' : 'Activate',
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

  Future<void> updateStatus(UserModel driver) async {
    final newStatus = driver.status == 'active' ? 'suspended' : 'active';
    final result = await service.updateUserStatus(
      userId: driver.id,
      status: newStatus,
    );
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadDrivers();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
