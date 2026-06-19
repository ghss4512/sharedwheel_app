import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/admin_service.dart';
import '../../utils/functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AdminService service = AdminService();
  bool isLoading = true;
  bool isSaving = false;
  final appNameController = TextEditingController();
  final supportEmailController = TextEditingController();
  final supportPhoneController = TextEditingController();
  final commissionController = TextEditingController();
  final minWithdrawalController = TextEditingController();
  final maxWithdrawalController = TextEditingController();
  final jazzCashController = TextEditingController();
  final easyPaisaController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();
  final driverWaitingTimeController = TextEditingController();
  final noShowPenaltyController = TextEditingController();
  final cancellationDeductionController = TextEditingController();
  bool maintenanceMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  void dispose() {
    appNameController.dispose();
    supportEmailController.dispose();
    supportPhoneController.dispose();
    commissionController.dispose();
    minWithdrawalController.dispose();
    maxWithdrawalController.dispose();
    jazzCashController.dispose();
    easyPaisaController.dispose();
    bankNameController.dispose();
    accountTitleController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  Future<void> loadSettings() async {
    try {
      final settings = await service.getAllSettings();
      appNameController.text = settings.getValue('app_name');
      supportEmailController.text = settings.getValue('support_email');
      supportPhoneController.text = settings.getValue('support_phone');
      commissionController.text = settings.getValue('commission_percentage');
      minWithdrawalController.text = settings.getValue('minimum_withdrawal');
      maxWithdrawalController.text = settings.getValue('maximum_withdrawal');
      jazzCashController.text = settings.getValue('jazzcash_number');
      easyPaisaController.text = settings.getValue('easypaisa_number');
      bankNameController.text = settings.getValue('bank_name');
      accountTitleController.text = settings.getValue('account_title');
      accountNumberController.text = settings.getValue('account_number');
      driverWaitingTimeController.text = settings.getValue(
        'driver_waiting_time',
      );
      noShowPenaltyController.text = settings.getValue(
        'no_show_penalty_percent',
      );
      cancellationDeductionController.text = settings.getValue(
        'cancellation_deduction_percentage',
      );
      maintenanceMode = settings.getValue('maintenance_mode') == '1';
    } catch (e) {
      if (!mounted) return;
      Functions.error(context, e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    setState(() {
      isSaving = true;
    });

    try {
      await service.updateSetting(
        key: 'app_name',
        value: appNameController.text.trim(),
      );

      await service.updateSetting(
        key: 'support_email',
        value: supportEmailController.text.trim(),
      );

      await service.updateSetting(
        key: 'support_phone',
        value: supportPhoneController.text.trim(),
      );

      await service.updateSetting(
        key: 'commission_percentage',
        value: commissionController.text.trim(),
      );

      await service.updateSetting(
        key: 'minimum_withdrawal',
        value: minWithdrawalController.text.trim(),
      );

      await service.updateSetting(
        key: 'maximum_withdrawal',
        value: maxWithdrawalController.text.trim(),
      );

      await service.updateSetting(
        key: 'jazzcash_number',
        value: jazzCashController.text.trim(),
      );

      await service.updateSetting(
        key: 'easypaisa_number',
        value: easyPaisaController.text.trim(),
      );

      await service.updateSetting(
        key: 'bank_name',
        value: bankNameController.text.trim(),
      );

      await service.updateSetting(
        key: 'account_title',
        value: accountTitleController.text.trim(),
      );

      await service.updateSetting(
        key: 'account_number',
        value: accountNumberController.text.trim(),
      );

      await service.updateSetting(
        key: 'driver_waiting_time',
        value: driverWaitingTimeController.text.trim(),
      );

      await service.updateSetting(
        key: 'no_show_penalty_percent',
        value: noShowPenaltyController.text.trim(),
      );

      await service.updateSetting(
        key: 'cancellation_deduction_percentage',
        value: cancellationDeductionController.text.trim(),
      );

      await service.updateSetting(
        key: 'maintenance_mode',
        value: maintenanceMode ? '1' : '0',
      );

      if (!mounted) return;

      Functions.success(context, 'Settings saved successfully');
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, e.toString());
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  buildSection(
                    title: 'General',
                    children: [
                      buildField(
                        controller: appNameController,
                        label: 'App Name',
                      ),

                      buildField(
                        controller: supportEmailController,
                        label: 'Support Email',
                      ),

                      buildField(
                        controller: supportPhoneController,
                        label: 'Support Phone',
                      ),
                    ],
                  ),

                  buildSection(
                    title: 'Wallet Settings',
                    children: [
                      buildField(
                        controller: commissionController,
                        label: 'Commission %',
                      ),

                      buildField(
                        controller: minWithdrawalController,
                        label: 'Minimum Withdrawal',
                      ),

                      buildField(
                        controller: maxWithdrawalController,
                        label: 'Maximum Withdrawal',
                      ),
                    ],
                  ),

                  buildSection(
                    title: 'Ride Rules',
                    children: [
                      buildField(
                        controller: driverWaitingTimeController,
                        label: 'Driver Waiting Time (Minutes)',
                      ),

                      buildField(
                        controller: noShowPenaltyController,
                        label: 'No Show Penalty %',
                      ),

                      buildField(
                        controller: cancellationDeductionController,
                        label: 'Cancellation Deduction %',
                      ),
                    ],
                  ),
                  buildSection(
                    title: 'Payment Methods',
                    children: [
                      buildField(
                        controller: jazzCashController,
                        label: 'JazzCash Number',
                      ),
                      buildField(
                        controller: easyPaisaController,
                        label: 'EasyPaisa Number',
                      ),

                      buildField(
                        controller: bankNameController,
                        label: 'Bank Name',
                      ),

                      buildField(
                        controller: accountTitleController,
                        label: 'Account Title',
                      ),

                      buildField(
                        controller: accountNumberController,
                        label: 'Account Number',
                      ),
                    ],
                  ),

                  buildSection(
                    title: 'System',
                    children: [
                      SwitchListTile(
                        value: maintenanceMode,
                        title: const Text('Maintenance Mode'),
                        onChanged: (value) {
                          setState(() {
                            maintenanceMode = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : saveSettings,
                      icon: const Icon(Icons.save),
                      label: Text(isSaving ? 'Saving...' : 'Save Settings'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}