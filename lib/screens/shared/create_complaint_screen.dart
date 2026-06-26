import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/complaint_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class CreateComplaintScreen extends StatefulWidget {
  final int rideId;
  final int againstUserId;
  final String againstUserName;

  const CreateComplaintScreen({
    super.key,
    required this.rideId,
    required this.againstUserId,
    required this.againstUserName,
  });

  @override
  State<CreateComplaintScreen> createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  final ComplaintService complaintService = ComplaintService();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();
  bool isSubmitting = false;
  String selectedCategory = 'other';
  final List<String> categories = [
    'ride',
    'driver',
    'passenger',
    'payment',
    'wallet',
    'withdrawal',
    'app_issue',
    'other',
  ];

  Future<void> submitComplaint() async {
    if (AppSession.userId == null) {
      Functions.error(context, 'User not found.');
      return;
    }

    if (subjectController.text.trim().isEmpty) {
      Functions.error(context, 'Subject is required.');
      return;
    }

    if (complaintController.text.trim().isEmpty) {
      Functions.error(context, 'Please enter complaint details.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await complaintService.createComplaint(
        rideId: widget.rideId,
        complainantId: AppSession.userId!,
        againstUserId: widget.againstUserId,
        category: selectedCategory,
        complaintType: selectedCategory,
        subject: subjectController.text.trim(),
        complaintText: complaintController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        Navigator.pop(context, true);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, 'Unable to submit complaint.');
    }

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void dispose() {
    subjectController.dispose();
    complaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Report User'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isSubmitting
          ? const LoadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.report_problem,
                            size: 60,
                            color: Colors.orange,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            widget.againstUserName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text('User being reported'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.replaceAll('_', ' ')),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: complaintController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Complaint Details',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  PrimaryButton(
                    text: 'Submit Complaint',
                    onPressed: submitComplaint,
                  ),
                ],
              ),
            ),
    );
  }
}
