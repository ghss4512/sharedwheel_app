import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../utils/functions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobile;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.mobile,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthService authService = AuthService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Functions.error(context, 'Please fill all fields.');
      return;
    }

    if (password.length < 6) {
      Functions.error(context, 'Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      Functions.error(context, 'Passwords do not match.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await authService.resetPassword(
        mobile: widget.mobile,
        otp: widget.otp,
        newPassword: password,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, e.toString());
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
        title: const Text('Reset Password'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 25),

              Icon(Icons.lock_reset, size: 90, color: AppColors.primary),

              const SizedBox(height: 20),

              const Text(
                'Create New Password',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your password must contain at least 6 characters.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 35),

              CustomTextField(
                controller: passwordController,
                label: 'New Password',
                icon: Icons.lock,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 35),

              PrimaryButton(
                text: isLoading ? 'Updating...' : 'Reset Password',
                onPressed: isLoading ? null : resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
