import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

class UserDetailsScreen extends StatefulWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final AdminService service = AdminService();
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      user = await service.getUserDetails(widget.userId);
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
        title: const Text('User Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : user == null
          ? const Center(child: Text('User not found'))
          : RefreshIndicator(
              onRefresh: loadUser,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildHeader(),
                  const SizedBox(height: 16),
                  buildPersonalInfo(),
                  const SizedBox(height: 16),
                  buildStatistics(),
                  const SizedBox(height: 16),
                  buildStatusCard(),
                  const SizedBox(height: 20),
                  buildActionButton(),
                ],
              ),
            ),
    );
  }

  Widget buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              child: Text(
                user!.fullName.isNotEmpty ? user!.fullName[0] : '?',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              user!.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(Functions.toProperCase(user!.userType)),
          ],
        ),
      ),
    );
  }

  Widget buildPersonalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            buildInfoTile('Phone', user!.phone),

            buildInfoTile('Email', user!.email),

            buildInfoTile('City', user!.city),

            buildInfoTile('Address', user!.address),
          ],
        ),
      ),
    );
  }

  Widget buildStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            buildInfoTile(
              'Wallet Balance',
              'Rs. ${Functions.formatCurrency(user!.walletBalance, 0)}',
            ),

            buildInfoTile('Rating', user!.rating.toStringAsFixed(1)),

            buildInfoTile('Total Ratings', user!.totalRatings.toString()),

            buildInfoTile('Total Rides', user!.totalRides.toString()),

            buildInfoTile('No Shows', user!.noShowCount.toString()),

            buildInfoTile('Cancellations', user!.cancellationCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Account Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            Row(
              children: [
                Chip(
                  backgroundColor: user!.status == 'active'
                      ? Colors.green
                      : Colors.red,

                  label: Text(
                    Functions.toProperCase(user!.status),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 10),

                if (user!.isVerified)
                  const Chip(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Verified',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton() {
    return ElevatedButton.icon(
      onPressed: updateStatus,

      icon: Icon(user!.status == 'active' ? Icons.block : Icons.check),

      label: Text(user!.status == 'active' ? 'Suspend User' : 'Activate User'),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Future<void> updateStatus() async {
    final newStatus = user!.status == 'active' ? 'suspended' : 'active';

    final result = await service.updateUserStatus(
      userId: user!.id,
      status: newStatus,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      Functions.success(context, result['message']);

      loadUser();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
