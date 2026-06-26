import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../utils/functions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final mobileController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    final mobile = mobileController.text.trim();

    if (mobile.isEmpty) {
      Functions.error(context, 'Please enter mobile number.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await authService.forgotPassword(mobile: mobile);

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        // Development Only
        if (result['otp'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Development OTP : ${result['otp']}')),
          );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpScreen(mobile: mobile)),
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
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Icon(Icons.lock_reset, size: 90, color: AppColors.primary),

              const SizedBox(height: 20),

              const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Enter your registered mobile number.\nWe will send you a verification code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 35),

              CustomTextField(
                controller: mobileController,
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: isLoading ? 'Sending...' : 'Send OTP',
                onPressed: isLoading ? null : sendOtp,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
