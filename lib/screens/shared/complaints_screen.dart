import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text("My Complaints"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          complaintCard(
            title: 'Driver arrived late',
            complaintNo: 'CMP-1001',
            status: 'Pending',
            statusColor: Colors.orange,
            date: '10 Jun 2026',
          ),

          complaintCard(
            title: 'Wrong fare charged',
            complaintNo: 'CMP-1002',
            status: 'In Progress',
            statusColor: Colors.blue,
            date: '08 Jun 2026',
          ),

          complaintCard(
            title: 'Driver behaviour issue',
            complaintNo: 'CMP-1003',
            status: 'Resolved',
            statusColor: AppColors.success,
            date: '05 Jun 2026',
          ),
        ],
      ),
    );
  }

  Widget complaintCard({
    required String title,
    required String complaintNo,
    required String status,
    required Color statusColor,
    required String date,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),

        leading: const CircleAvatar(child: Icon(Icons.report_problem)),

        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Complaint #: $complaintNo'),
            Text('Date: $date'),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(38),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          // Open Complaint Details
        },
      ),
    );
  }
}
