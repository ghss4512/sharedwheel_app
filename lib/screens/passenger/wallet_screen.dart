import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Wallet',),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BALANCE CARD
            Container(
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
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Rs. 12,500',
                    style: TextStyle(
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),

                          icon: const Icon(
                            Icons.add,
                            color: AppColors.primary,
                          ),

                          label: const Text(
                            'Add Funds',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'Withdraw',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // TRANSACTION HISTORY
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            transactionCard(
              icon: Icons.directions_car,
              title: 'Ride Payment',
              date: '10 Jun 2026',
              amount: '- Rs. 1,800',
              amountColor: AppColors.danger,
            ),

            transactionCard(
              icon: Icons.refresh,
              title: 'Refund',
              date: '08 Jun 2026',
              amount: '+ Rs. 500',
              amountColor: AppColors.success,
            ),

            transactionCard(
              icon: Icons.card_giftcard,
              title: 'Bonus Credit',
              date: '05 Jun 2026',
              amount: '+ Rs. 1,000',
              amountColor: AppColors.success,
            ),

            transactionCard(
              icon: Icons.account_balance_wallet,
              title: 'Withdrawal',
              date: '01 Jun 2026',
              amount: '- Rs. 3,000',
              amountColor: AppColors.danger,
            ),

            const SizedBox(height: 25),

            PrimaryButton(
              text: 'View Full History',
              onPressed: () {
                // Transaction History Screen

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionCard({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color amountColor,

  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          AppColors.primary.withAlpha(25),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}