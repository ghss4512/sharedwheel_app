import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/admin/pending_deposit_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class PendingDepositsScreen extends StatefulWidget {
  const PendingDepositsScreen({super.key});

  @override
  State<PendingDepositsScreen> createState() => _PendingDepositsScreenState();
}

class _PendingDepositsScreenState extends State<PendingDepositsScreen> {
  final AdminService service = AdminService();

  List<PendingDepositModel> deposits = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDeposits();
  }

  Future<void> loadDeposits() async {
    deposits = await service.getPendingDeposits();

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
        title: const Text('Pending Deposits'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadDeposits,

        child: isLoading
            ? const LoadingWidget()
            : deposits.isEmpty
            ? const EmptyStateWidget(message: 'No pending deposits')
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: deposits.length,
                itemBuilder: (context, index) {
                  final item = deposits[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item.phone),
                          const SizedBox(height: 10),
                          Text('Amount: Rs. ${item.amount.toStringAsFixed(0)}'),
                          const SizedBox(height: 5),
                          Text(item.description),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    approveDeposit(item.id);
                                  },
                                  child: const Text('Approve'),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    rejectDeposit(item.id);
                                  },
                                  child: const Text('Reject'),
                                ),
                              ),
                            ],
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

  Future<void> approveDeposit(int transactionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Approve Deposit'),
        content: const Text('Are you sure you want to approve this deposit?'),
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

    final result = await service.approveDeposit(transactionId);

    if (!mounted) return;

    if (result['success'] == true) {
      Functions.success(context, result['message']);

      loadDeposits();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> rejectDeposit(int transactionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Deposit'),
        content: const Text('Are you sure you want to reject this deposit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final result = await service.rejectDeposit(transactionId);
    if (!mounted) return;
    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadDeposits();
    } else {
      Functions.error(context, result['message']);
    }
  }
}
