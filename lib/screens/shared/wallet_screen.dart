import 'package:flutter/material.dart';
import '../shared/withdraw_request_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_transaction_model.dart';
import '../../services/wallet_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../utils/functions.dart';
import 'deposit_request_screen.dart';
import 'deposit_requests_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  final WalletService walletService = WalletService();
  WalletModel wallet = WalletModel(balance: 0);
  List<WalletTransactionModel> transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadWallet,
        child: isLoading
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Balance Card
                  buildBalanceCard(),

                  const SizedBox(height: 25),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Deposit Requests'),
                      subtitle: const Text(
                        'View pending, approved and rejected deposits',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Functions.navigateTo(
                          context,
                          const DepositRequestsScreen(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Recent Transactions
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  if (transactions.isEmpty)
                    EmptyStateWidget(message: 'No transactions found'),
                  ...transactions.map(
                    (transaction) => transactionCard(
                      icon: getTransactionIcon(transaction.transactionType),
                      title: formatTransactionType(transaction.transactionType),
                      description: transaction.description,
                      date: Functions.formatDateTime(transaction.createdAt),
                      amount:
                          '${transaction.amount >= 0 ? '+' : ''}Rs. ${Functions.formatCurrency(transaction.amount, 0)}',
                      amountColor: transaction.amount >= 0
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 10),
          Text(
            'Rs. ${Functions.formatCurrency(wallet.balance, 0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DepositRequestScreen(),
                      ),
                    );

                    if (result == true) {
                      loadWallet();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: const Text(
                    'Add Funds',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Functions.navigateToAsync(context, WithdrawRequestScreen());
                    loadWallet();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Withdraw',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget transactionCard({
    required IconData icon,
    required String title,
    required String description,
    required String date,
    required String amount,
    required Color amountColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(25),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [if (description.isNotEmpty) Text(description), Text(date)],
        ),
        trailing: Text(
          amount,
          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  IconData getTransactionIcon(String type) {
    switch (type) {
      case 'deposit':
        return Icons.add_circle;
      case 'withdrawal':
        return Icons.account_balance_wallet;
      case 'ride_payment':
        return Icons.directions_car;
      case 'ride_refund':
        return Icons.refresh;
      case 'ride_earning':
        return Icons.payments;
      case 'no_show_penalty':
        return Icons.warning;
      default:
        return Icons.receipt_long;
    }
  }

  String formatTransactionType(String type) {
    switch (type) {
      case 'ride_payment':
        return 'Ride Payment';

      case 'ride_refund':
        return 'Ride Refund';

      case 'ride_earning':
        return 'Ride Earnings';

      case 'no_show_penalty':
        return 'No Show Penalty';

      case 'cancellation_fee':
        return 'Cancellation Fee';

      case 'withdrawal':
        return 'Withdrawal';

      case 'deposit':
        return 'Deposit';

      default:
        return Functions.toProperCase(type.replaceAll('_', ' '));
    }
  }

  Future<void> refreshData() async {
    await loadWallet();
  }

  Future<void> loadWallet() async {
    setState(() {
      isLoading = true;
    });
    try {
      final results = await Future.wait([
        walletService.getWallet(),
        walletService.getTransactions(),
      ]);

      wallet = results[0] as WalletModel;
      transactions = results[1] as List<WalletTransactionModel>;
    } catch (e) {
      debugPrint('Wallet Error: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}
