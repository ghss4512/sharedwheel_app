import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/deposit_request_model.dart';
import '../../services/wallet_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class DepositRequestsScreen extends StatefulWidget {
  const DepositRequestsScreen({super.key});

  @override
  State<DepositRequestsScreen> createState() => DepositRequestsScreenState();
}

class DepositRequestsScreenState extends State<DepositRequestsScreen> {
  final WalletService service = WalletService();

  List<DepositRequestModel> requests = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      requests = await service.getDepositRequests();
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
        title: const Text('Deposit Requests'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: loadRequests,
        child: isLoading
            ? const LoadingWidget()
            : requests.isEmpty
            ? const EmptyStateWidget(message: 'No deposit requests found')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.account_balance_wallet),
                      ),

                      title: Text(
                        'Rs. ${Functions.formatCurrency(request.amount, 0)}',
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(request.description),
                          Text(Functions.formatDateTime(request.createdAt)),
                        ],
                      ),

                      trailing: buildStatusBadge(request.status),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildStatusBadge(String status) {
    Color color = Colors.orange;

    if (status == 'approved') {
      color = Colors.green;
    }

    if (status == 'rejected') {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
