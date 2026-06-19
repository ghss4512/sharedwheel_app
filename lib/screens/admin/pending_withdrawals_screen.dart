import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/admin/pending_withdrawal_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class PendingWithdrawalsScreen extends StatefulWidget {
  const PendingWithdrawalsScreen({super.key});

  @override
  State<PendingWithdrawalsScreen> createState() =>
      _PendingWithdrawalsScreenState();
}

class _PendingWithdrawalsScreenState extends State<PendingWithdrawalsScreen> {
  final AdminService service = AdminService();
  List<PendingWithdrawalModel> withdrawals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWithdrawals();
  }

  Future<void> loadWithdrawals() async {
    try {
      withdrawals = await service.getPendingWithdrawals();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Pending Withdrawals'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadWithdrawals,
        child: isLoading
            ? const LoadingWidget()
            : withdrawals.isEmpty
            ? const EmptyStateWidget(message: 'No pending withdrawals')
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: withdrawals.length,
                itemBuilder: (context, index) {
                  final item = withdrawals[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.fullName, style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(item.phone),

                          const SizedBox(height: 10),

                          Text( 'Amount: Rs. ${Functions.formatCurrency(item.amount, 0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),

                          Text('Method: ${Functions.toProperCase(item.method)}',
                          ),

                          Text('Title: ${item.accountTitle}'),

                          Text('Account: ${item.accountNumber}'),

                          if (item.remarks.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Remarks: ${item.remarks}'),
                            ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    approveWithdrawal(item.id);
                                  },
                                  label: const Text('Approve'),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    rejectWithdrawal(item.id);
                                  },
                                  label: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            Functions.formatDateTime(item.createdAt),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> approveWithdrawal(int withdrawalId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Approve Withdrawal'),
        content: const Text(
          'Are you sure you want to approve this withdrawal request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    final result = await service.approveWithdrawal(withdrawalId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadWithdrawals();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> rejectWithdrawal(int withdrawalId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Withdrawal'),
        content: const Text(
          'Are you sure you want to reject this withdrawal request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await service.rejectWithdrawal(withdrawalId);

    if (!mounted) return;

    if (result['success'] == true) {
      Functions.success(context, result['message']);

      loadWithdrawals();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
