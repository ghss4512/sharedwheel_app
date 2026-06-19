import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharedwheel_app/utils/app_config.dart';
import '../../services/driver_verification_service.dart';
import '../../constants/app_colors.dart';

class DriverVerificationScreen extends StatefulWidget {
  const DriverVerificationScreen({super.key});

  @override
  State<DriverVerificationScreen> createState() =>
      _DriverVerificationScreenState();
}

class _DriverVerificationScreenState extends State<DriverVerificationScreen> {
  final ImagePicker picker = ImagePicker();
  File? cnicFront;
  File? cnicBack;
  File? drivingLicense;
  File? vehicleRegistration;
  bool isSubmitting = false;
  final DriverVerificationService verificationService =
      DriverVerificationService();
  String verificationStatus = 'not_submitted';
  String remarks = '';

  String cnicFrontUrl = '';
  String cnicBackUrl = '';
  String drivingLicenseUrl = '';
  String vehicleRegistrationUrl = '';

  bool get canUpload {
    return verificationStatus == 'not_submitted' ||
        verificationStatus == 'rejected';
  }

  Future<void> pickImage(Function(File) onSelected) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    final image = await picker.pickImage(source: source, imageQuality: 80);

    if (image == null) {
      return;
    }

    onSelected(File(image.path));

    setState(() {});
  }

  Future<void> submitVerification() async {
    if (cnicFront == null ||
        cnicBack == null ||
        drivingLicense == null ||
        vehicleRegistration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all documents.')),
      );
      // Functions.error(context, 'Please select all documents.')
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await verificationService.submitVerification(
        cnicFront: cnicFront!,
        cnicBack: cnicBack!,
        drivingLicense: drivingLicense!,
        vehicleRegistration: vehicleRegistration!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Verification submitted.')),
      );
      // Functions.success(context, result['message'] ?? 'Verification submitted.')

      await loadStatus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      // Functions.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> loadStatus() async {
    try {
      final result = await verificationService.getStatus();
      if (result['success'] != true) {
        return;
      }
      if (result['submitted'] == true) {
        final verification = result['verification'];
        cnicFrontUrl = verification['cnic_front'] ?? '';
        cnicBackUrl = verification['cnic_back'] ?? '';
        drivingLicenseUrl = verification['driving_license'] ?? '';
        vehicleRegistrationUrl = verification['vehicle_registration'] ?? '';
      }
      if (result['submitted'] == false) {
        verificationStatus = 'not_submitted';
      } else {
        verificationStatus = result['verification']['status'];
        remarks = result['verification']['remarks'] ?? '';
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget networkPreview(String path) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 180,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Image.network("${AppConfig.baseUrl}/$path", fit: BoxFit.cover),
    );
  }

  Widget documentTile({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: file == null
            ? const Icon(Icons.upload_file)
            : const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title),
        subtitle: Text(
          file == null ? 'Not selected' : file.path.split('/').last,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget imagePreview(File? file) {
    if (file == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Driver Verification'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 60,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Upload verification documents to become a verified driver.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: verificationStatus == 'approved'
                  ? Colors.green.shade50
                  : verificationStatus == 'rejected'
                  ? Colors.red.shade50
                  : verificationStatus == 'pending'
                  ? Colors.orange.shade50
                  : Colors.grey.shade100,

              child: ListTile(
                leading: Icon(
                  verificationStatus == 'approved'
                      ? Icons.verified
                      : verificationStatus == 'rejected'
                      ? Icons.cancel
                      : verificationStatus == 'pending'
                      ? Icons.pending
                      : Icons.upload_file,

                  color: verificationStatus == 'approved'
                      ? Colors.green
                      : verificationStatus == 'rejected'
                      ? Colors.red
                      : verificationStatus == 'pending'
                      ? Colors.orange
                      : Colors.grey,
                ),

                title: Text(
                  verificationStatus == 'approved'
                      ? 'Verification Approved'
                      : verificationStatus == 'rejected'
                      ? 'Verification Rejected'
                      : verificationStatus == 'pending'
                      ? 'Verification Pending'
                      : 'Verification Required',
                ),

                subtitle: Text(
                  verificationStatus == 'approved'
                      ? 'You are now a verified driver.'
                      : verificationStatus == 'rejected'
                      ? (remarks.isEmpty
                            ? 'Please upload new documents.'
                            : remarks)
                      : verificationStatus == 'pending'
                      ? 'Your documents are under review.'
                      : 'Please upload your documents for verification.',
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (verificationStatus != 'approved') ...[
              documentTile(
                title: 'CNIC Front',
                file: cnicFront,
                onTap: canUpload
                    ? () {
                        pickImage((file) {
                          setState(() {
                            cnicFront = file;
                          });
                        });
                      }
                    : () {},
              ),

              cnicFront != null
                  ? imagePreview(cnicFront)
                  : networkPreview(cnicFrontUrl),

              documentTile(
                title: 'CNIC Back',
                file: cnicBack,
                onTap: canUpload
                    ? () {
                        pickImage((file) {
                          setState(() {
                            cnicBack = file;
                          });
                        });
                      }
                    : () {},
              ),

              cnicFront != null
                  ? imagePreview(cnicBack)
                  : networkPreview(cnicBackUrl),

              documentTile(
                title: 'Driving License',
                file: drivingLicense,
                onTap: canUpload
                    ? () {
                        pickImage((file) {
                          setState(() {
                            drivingLicense = file;
                          });
                        });
                      }
                    : () {},
              ),

              cnicFront != null
                  ? imagePreview(drivingLicense)
                  : networkPreview(drivingLicenseUrl),

              documentTile(
                title: 'Vehicle Registration',
                file: vehicleRegistration,
                onTap: canUpload
                    ? () {
                        pickImage((file) {
                          setState(() {
                            vehicleRegistration = file;
                          });
                        });
                      }
                    : () {},
              ),

              cnicFront != null
                  ? imagePreview(vehicleRegistration)
                  : networkPreview(vehicleRegistrationUrl),
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: canUpload && !isSubmitting
                    ? submitVerification
                    : null,

                icon: const Icon(Icons.upload),

                label: Text(
                  verificationStatus == 'rejected'
                      ? 'Resubmit Verification'
                      : 'Submit Verification',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
