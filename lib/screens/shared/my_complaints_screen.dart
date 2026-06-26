import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/complaint_model.dart';
import '../../services/complaint_service.dart';
import '../../utils/app_session.dart';
import '../../widgets/loading_widget.dart';
import 'complaint_details_screen.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final ComplaintService complaintService = ComplaintService();

  bool isLoading = true;

  List<ComplaintModel> complaints = [];

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    if (AppSession.userId == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      complaints = await complaintService.getMyComplaints(AppSession.userId!);
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

  Widget buildComplaintCard(ComplaintModel complaint) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(height: 5),

            Text(complaint.againstUserName),

            const SizedBox(height: 5),

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
              builder: (_) => ComplaintDetailsScreen(complaintId: complaint.id),
            ),
          ).then((_) {
            loadComplaints();
          });
        },
      ),
    );
  }

  Widget buildBody() {
    if (complaints.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_problem_outlined, size: 80, color: Colors.grey),

            SizedBox(height: 10),

            Text('No complaints found'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadComplaints,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return buildComplaintCard(complaints[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Complaints'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading ? const LoadingWidget() : buildBody(),
    );
  }
}
