import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/complaint_model.dart';
import '../../services/admin_complaint_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'admin_complaint_details_screen.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  final AdminComplaintService complaintService = AdminComplaintService();

  bool isLoading = false;

  String selectedStatus = '';

  List<ComplaintModel> complaints = [];

  final List<Map<String, String>> filters = [
    {'label': 'All', 'value': ''},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'In Progress', 'value': 'in_progress'},
    {'label': 'Resolved', 'value': 'resolved'},
    {'label': 'Rejected', 'value': 'rejected'},
  ];

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    setState(() {
      isLoading = true;
    });

    try {
      complaints = await complaintService.getComplaints(status: selectedStatus);
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
      case 'pending':
        return Colors.orange;

      case 'in_progress':
        return Colors.blue;

      case 'resolved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Widget buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];

          final isSelected = selectedStatus == filter['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter['label']!),
              selected: isSelected,
              onSelected: (_) async {
                selectedStatus = filter['value']!;
                await loadComplaints();
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildComplaintCard(ComplaintModel complaint) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getStatusColor(complaint.status),
          child: const Icon(Icons.report_problem, color: Colors.white),
        ),

        title: Text(
          complaint.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text('Complainant: ${complaint.complainantName}'),

            Text('Against: ${complaint.againstUserName}'),

            const SizedBox(height: 4),

            Text(
              complaint.status.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                color: getStatusColor(complaint.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AdminComplaintDetailsScreen(complaintId: complaint.id),
            ),
          ).then((_) {
            loadComplaints();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Complaints'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: buildFilterChips()),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadComplaints,
              child: isLoading
                  ? const LoadingWidget()
                  : complaints.isEmpty
                  ? const EmptyStateWidget(message: 'No complaints found')
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        return buildComplaintCard(complaints[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
