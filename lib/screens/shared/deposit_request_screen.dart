import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/payment_settings_model.dart';
import '../../services/wallet_service.dart';
import '../../utils/functions.dart';

class DepositRequestScreen extends StatefulWidget {
  const DepositRequestScreen({super.key});

  @override
  State<DepositRequestScreen> createState() => _DepositRequestScreenState();
}

class _DepositRequestScreenState extends State<DepositRequestScreen> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final referenceController = TextEditingController();
  final remarksController = TextEditingController();
  final WalletService service = WalletService();
  PaymentSettingsModel? settings;
  bool isSubmitting = false;
  String paymentMethod = 'JazzCash';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  void dispose() {
    amountController.dispose();
    referenceController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Add Funds'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: formKey,
          child: Column(
            children: [
              if (settings != null)
                Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('JazzCash: ${settings!.jazzCashNumber}'),
                        Text('EasyPaisa: ${settings!.easyPaisaNumber}'),
                        const SizedBox(height: 10),
                        Text('Bank: ${settings!.bankName}'),
                        Text('Title: ${settings!.accountTitle}'),
                        Text('Account: ${settings!.accountNumber}'),
                        const SizedBox(height: 10),
                        const Text(
                          'Send payment first, then submit the transaction reference below.',
                        ),
                      ],
                    ),
                  ),
                ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      DropdownButtonFormField<String>(
                        initialValue: paymentMethod,
                        items: const [
                          DropdownMenuItem(
                            value: 'JazzCash',
                            child: Text('JazzCash'),
                          ),

                          DropdownMenuItem(
                            value: 'EasyPaisa',
                            child: Text('EasyPaisa'),
                          ),

                          DropdownMenuItem(
                            value: 'Bank',
                            child: Text('Bank Transfer'),
                          ),
                        ],

                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.currency_exchange),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Amount is required';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        controller: referenceController,
                        decoration: const InputDecoration(
                          labelText: 'Transaction Reference',
                          prefixIcon: Icon(Icons.receipt),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Reference number is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 2),
                      TextFormField(
                        controller: remarksController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Remarks (Optional)',
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                          onPressed: isSubmitting ? null : submitRequest,
                          child: Text(
                            isSubmitting ? 'Submitting...' : 'Submit Request',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 2),

              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'After sending payment through JazzCash, EasyPaisa or Bank Transfer, submit the transaction reference number. Your request will be reviewed by admin before funds are added to your wallet.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await service.submitDepositRequest(
        amount: double.parse(amountController.text.trim()),
        method: paymentMethod,
        referenceNo: referenceController.text.trim(),
        remarks: remarksController.text.trim(),
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Functions.success(context, result['message']);
        Navigator.pop(context, true);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    }
    if (!mounted) return;
    setState(() {
      isSubmitting = false;
    });
  }

  Future<void> loadSettings() async {
    settings = await service.getPaymentSettings();
    if (!mounted) return;
    setState(() {});
  }
}
