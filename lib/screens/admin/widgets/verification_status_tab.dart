import 'package:flutter/material.dart';

import '../../../models/admin/driver_verification.dart';
import '../../../services/driver_verification_service.dart';
import '../verification_detail_screen.dart';

class VerificationStatusTab extends StatefulWidget {
  final String status;
  final VoidCallback? onRefreshCounts;

  const VerificationStatusTab({
    super.key,
    required this.status,
    this.onRefreshCounts,
  });

  @override
  State<VerificationStatusTab> createState() => _VerificationStatusTabState();
}

class _VerificationStatusTabState extends State<VerificationStatusTab> {
  final DriverVerificationService service = DriverVerificationService();

  List<DriverVerification> verifications = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(covariant VerificationStatusTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status != widget.status) {
      loadData();
    }
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    verifications = await service.getVerifications(status: widget.status);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (verifications.isEmpty) {
      return Center(child: Text('No ${widget.status} verifications'));
    }

    return RefreshIndicator(
      onRefresh: loadData,
      child: ListView.builder(
        itemCount: verifications.length,
        itemBuilder: (context, index) {
          final verification = verifications[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(verification.fullName),
              subtitle: Text(verification.phone),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VerificationDetailScreen(verification: verification),
                  ),
                );

                if (result == true) {
                  await loadData();
                  widget.onRefreshCounts?.call();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
