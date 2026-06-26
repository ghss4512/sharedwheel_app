import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/complaint_log_model.dart';
import '../../models/complaint_model.dart';
import '../../services/complaint_service.dart';
import '../../widgets/loading_widget.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final int complaintId;

  const ComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final ComplaintService complaintService = ComplaintService();

  bool isLoading = true;

  ComplaintModel? complaint;

  List<ComplaintLogModel> logs = [];

  @override
  void initState() {
    super.initState();
    loadComplaintDetails();
  }

  Future<void> loadComplaintDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await complaintService.getComplaintDetails(
        widget.complaintId,
      );

      if (result != null) {
        complaint = result['complaint'] as ComplaintModel;

        logs = result['logs'] as List<ComplaintLogModel>;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'resolved':
        return Colors.green;

      case 'in_progress':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  Widget buildComplaintCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint!.subject,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(complaint!.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                complaint!.status.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(complaint!.category),

            const SizedBox(height: 10),

            const Text(
              'Complaint Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(complaint!.complaintType),

            const SizedBox(height: 10),

            const Text(
              'Complaint Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(complaint!.complaintText),

            const SizedBox(height: 15),

            if (complaint!.adminRemarks.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Remarks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(complaint!.adminRemarks),
                  ),

                  const SizedBox(height: 15),
                ],
              ),

            const Divider(),

            Text(
              'Reported User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(complaint!.againstUserName),

            const SizedBox(height: 10),

            Text(
              'Created: ${complaint!.createdAt}',
              style: TextStyle(color: Colors.grey.shade700),
            ),

            if (complaint!.resolvedAt != null &&
                complaint!.resolvedAt!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Resolved: ${complaint!.resolvedAt}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complaint Timeline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (logs.isEmpty) const Text('No updates available.'),

            ...logs.map(
              (log) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: AppColors.primary),
                title: Text(log.note),
                subtitle: Text(log.createdAt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const LoadingWidget()
          : complaint == null
          ? const Center(child: Text('Complaint not found'))
          : RefreshIndicator(
              onRefresh: loadComplaintDetails,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  buildComplaintCard(),

                  const SizedBox(height: 10),

                  buildTimeline(),
                ],
              ),
            ),
    );
  }
}
