import 'package:flutter/material.dart';
import 'package:sharedwheel_app/screens/admin/widgets/verification_status_tab.dart';
import '../../services/driver_verification_service.dart';

class VerificationListScreen extends StatefulWidget {
  const VerificationListScreen({super.key});

  @override
  State<VerificationListScreen> createState() => _VerificationListScreenState();
}

class _VerificationListScreenState extends State<VerificationListScreen> {
  final DriverVerificationService service = DriverVerificationService();
  String selectedStatus = 'pending';
  int pendingCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;

  bool isLoadingCounts = true;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    final result = await service.getVerificationCounts();

    if (result['success'] == true) {
      pendingCount = result['pending'] ?? 0;
      approvedCount = result['approved'] ?? 0;
      rejectedCount = result['rejected'] ?? 0;
    }

    if (mounted) {
      setState(() {
        isLoadingCounts = false;
      });
    }
  }

  Widget buildStatCard(String title, int count, Color color, String status) {
    final bool isSelected = selectedStatus == status;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedStatus = status;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: isSelected ? 6 : 1,
          color: isSelected ? color.withAlpha(25) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 4),

                Text(title, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Verifications')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                buildStatCard(
                  'Pending',
                  pendingCount,
                  Colors.orange,
                  'pending',
                ),
                buildStatCard(
                  'Approved',
                  approvedCount,
                  Colors.green,
                  'approved',
                ),
                buildStatCard(
                  'Rejected',
                  rejectedCount,
                  Colors.red,
                  'rejected',
                ),
              ],
            ),
          ),

          Expanded(
            child: VerificationStatusTab(
              status: selectedStatus,
              onRefreshCounts: loadCounts,
            ),
          ),
        ],
      ),
    );
  }
}
