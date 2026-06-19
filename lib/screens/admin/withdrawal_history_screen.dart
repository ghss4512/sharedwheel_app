import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/admin/pending_withdrawal_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  const WithdrawalHistoryScreen({super.key});

  @override
  State<WithdrawalHistoryScreen> createState() =>
      _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  final AdminService service = AdminService();

  List<PendingWithdrawalModel> withdrawals = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    withdrawals = await service.getWithdrawalHistory();

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
        title: const Text('Withdrawal History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadData,

        child: isLoading
            ? const LoadingWidget()
            : withdrawals.isEmpty
            ? const EmptyStateWidget(message: 'No withdrawal history found')
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
                          Text(
                            item.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(item.phone),

                          const SizedBox(height: 10),

                          Text(
                            'Amount: Rs. ${Functions.formatCurrency(item.amount, 0)}',
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Method: ${Functions.toProperCase(item.method)}',
                          ),

                          Text('Title: ${item.accountTitle}'),

                          Text('Account: ${item.accountNumber}'),

                          if (item.remarks.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Remarks: ${item.remarks}'),
                            ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.status == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(Functions.formatDateTime(item.createdAt)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
