import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/profile_service.dart';
import '../../utils/functions.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool isSaving = false;

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final result = await ProfileService().changePassword(
        currentPassword: currentController.text.trim(),
        newPassword: newController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, 'Password changed successfully');
        Navigator.pop(context);
      } else {
        Functions.error(context, result['message'] ?? 'Unable to change password',
        );
      }
    } catch (e) {
      Functions.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: currentController,
              obscureText: obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureCurrent ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureCurrent = !obscureCurrent;
                    });
                  },
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: newController,
              obscureText: obscureNew,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNew ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureNew = !obscureNew;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Minimum 6 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: confirmController,
              obscureText: obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirm ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirm = !obscureConfirm;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value != newController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isSaving ? 'Updating...' : 'Update Password'),
                onPressed: isSaving ? null : changePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
