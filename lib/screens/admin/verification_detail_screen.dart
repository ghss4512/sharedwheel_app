import 'package:flutter/material.dart';

import '../../models/admin/driver_verification.dart';
import '../../services/driver_verification_service.dart';
import '../../utils/functions.dart';

class VerificationDetailScreen extends StatefulWidget {
  final DriverVerification verification;

  const VerificationDetailScreen({super.key, required this.verification});

  @override
  State<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState extends State<VerificationDetailScreen> {
  final DriverVerificationService service = DriverVerificationService();

  final TextEditingController remarksController = TextEditingController();

  bool isSubmitting = false;

  static const String imageBaseUrl = 'https://sharedwheel.com/api/';

  @override
  void initState() {
    super.initState();

    remarksController.text = widget.verification.remarks;
  }

  Future<void> reviewVerification(String status) async {
    try {
      setState(() {
        isSubmitting = true;
      });

      final result = await service.reviewVerification(
        verificationId: widget.verification.id,
        status: status,
        remarks: remarksController.text,
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Operation failed.');
      }

      if (!mounted) return;

      Functions.success(
        context,
        status == 'approved'
            ? 'Verification approved.'
            : 'Verification rejected.',
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Widget documentCard({required String title, required String imagePath}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          if (imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                imageBaseUrl + imagePath,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Document not available'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verification = widget.verification;

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(verification.fullName),
                subtitle: Text(verification.phone),
              ),
            ),

            const SizedBox(height: 16),

            documentCard(
              title: 'CNIC Front',
              imagePath: verification.cnicFront,
            ),

            documentCard(title: 'CNIC Back', imagePath: verification.cnicBack),

            documentCard(
              title: 'Driving License',
              imagePath: verification.drivingLicense,
            ),

            documentCard(
              title: 'Vehicle Registration',
              imagePath: verification.vehicleRegistration,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: remarksController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (widget.verification.status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final confirmed = await showConfirmationDialog(
                                title: 'Approve Verification',
                                message: 'Are you sure you want to approve this driver verification?',
                              );

                              if (confirmed == true) {
                                reviewVerification('approved');
                              }
                            },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final confirmed = await showConfirmationDialog(
                                title: 'Reject Verification',
                                message: 'Are you sure you want to reject this driver verification?',
                              );

                              if (confirmed == true) {
                                reviewVerification('rejected');
                              }
                            },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),

          content: Text(message),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
