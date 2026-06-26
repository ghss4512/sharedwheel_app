import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/complaint_log_model.dart';
import '../../models/complaint_model.dart';
import '../../services/admin_complaint_service.dart';
import '../../services/complaint_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

class AdminComplaintDetailsScreen extends StatefulWidget {
  final int complaintId;

  const AdminComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<AdminComplaintDetailsScreen> createState() =>
      _AdminComplaintDetailsScreenState();
}

class _AdminComplaintDetailsScreenState
    extends State<AdminComplaintDetailsScreen> {
  final ComplaintService complaintService = ComplaintService();

  final AdminComplaintService adminService = AdminComplaintService();

  bool isLoading = true;

  ComplaintModel? complaint;

  List<ComplaintLogModel> logs = [];

  @override
  void initState() {
    super.initState();
    loadComplaint();
  }

  Future<void> loadComplaint() async {
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

  Future<void> updateStatusDialog() async {
    String selectedStatus = complaint?.status ?? 'pending';

    final remarksController = TextEditingController(
      text: complaint?.adminRemarks ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Update Status'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'in_progress',
                        child: Text('In Progress'),
                      ),
                      DropdownMenuItem(
                        value: 'resolved',
                        child: Text('Resolved'),
                      ),
                      DropdownMenuItem(
                        value: 'rejected',
                        child: Text('Rejected'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        selectedStatus = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: remarksController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Admin Remarks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await adminService.updateComplaintStatus(
                    complaintId: widget.complaintId,
                    status: selectedStatus,
                    remarks: remarksController.text.trim(),
                  );

                  if (!mounted) return;
                  if (response['success'] == true) {
                    Navigator.pop(context, true);
                  } else {
                    Functions.error(context, response['message']);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    if (result == true) {
      await loadComplaint();
    }
  }

  Future<void> addLogDialog() async {
    final noteController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Investigation Note'),
        content: TextField(
          controller: noteController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter investigation note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await adminService.addComplaintLog(
                complaintId: widget.complaintId,
                note: noteController.text.trim(),
              );

              if (!mounted) {
                return;
              }

              if (response['success'] == true) {
                Navigator.pop(context, true);
              } else {
                Functions.error(context, response['message']);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      await loadComplaint();
    }
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
              onRefresh: loadComplaint,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint!.subject,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Chip(
                            backgroundColor: getStatusColor(complaint!.status),
                            label: Text(
                              complaint!.status
                                  .replaceAll('_', ' ')
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text('Complainant: ${complaint!.complainantName}'),

                          Text('Against: ${complaint!.againstUserName}'),

                          const Divider(),

                          Text(complaint!.complaintText),

                          if (complaint!.adminRemarks.isNotEmpty)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(complaint!.adminRemarks),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Update Status'),
                          onPressed: updateStatusDialog,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.note_add),
                          label: const Text('Add Note'),
                          onPressed: addLogDialog,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Timeline',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...logs.map(
                    (log) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(log.note),
                        subtitle: Text(log.createdAt),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
