import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/wallet_service.dart';
import '../../utils/functions.dart';

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({super.key});

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();
  final remarksController = TextEditingController();
  final WalletService service = WalletService();
  bool isSubmitting = false;
  String method = 'jazzcash';

  @override
  void dispose() {
    amountController.dispose();
    accountTitleController.dispose();
    accountNumberController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isSubmitting = true;
    });
    try {
      final result = await service.submitWithdrawRequest(
        amount: double.parse(amountController.text.trim()),
        method: method,
        accountTitle: accountTitleController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Withdrawal Method',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: method,
                    items: const [
                      DropdownMenuItem(value: 'jazzcash', child: Text('JazzCash'),),
                      DropdownMenuItem(value: 'easypaisa', child: Text('EasyPaisa'),),
                      DropdownMenuItem(value: 'bank', child: Text('Bank Transfer'),),
                    ],
                    onChanged: (value) {
                      setState(() {
                        method = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: accountTitleController,
                    decoration: const InputDecoration(labelText: 'Account Title',),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Account title is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: accountNumberController,
                    decoration: const InputDecoration(labelText: 'Account Number',),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Account number is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Enter valid amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: remarksController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Remarks'),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
        ),
      ),
    );
  }
}