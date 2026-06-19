import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/admin/pending_deposit_model.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({super.key});

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  final AdminService service = AdminService();
  List<PendingDepositModel> deposits = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    deposits = await service.getDepositHistory();
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
        title: const Text('Deposit History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadData,
        child: isLoading
            ? const LoadingWidget()
            : deposits.isEmpty
            ? const EmptyStateWidget(message: 'No deposit history found')
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: deposits.length,
                itemBuilder: (context, index) {
                  final item = deposits[index];
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
                          Text('Amount: Rs. ${Functions.formatCurrency(item.amount, 0)}',),
                          const SizedBox(height: 5),
                          Text(item.description),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4,),
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