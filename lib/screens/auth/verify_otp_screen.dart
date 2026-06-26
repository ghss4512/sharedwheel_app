import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../utils/functions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String mobile;

  const VerifyOtpScreen({super.key, required this.mobile});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final AuthService authService = AuthService();
  final otpController = TextEditingController();
  bool isLoading = false;
  int remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    Future.doWhile(() async {
      if (!mounted) return false;
      if (remainingSeconds == 0) {
        return false;
      }
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        remainingSeconds--;
      });
      return remainingSeconds > 0;
    });
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      Functions.error(context, 'Please enter the 6-digit OTP.');
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final result = await authService.verifyResetOtp(
        mobile: widget.mobile,
        otp: otp,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Functions.success(context, result['message']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordScreen(mobile: widget.mobile, otp: otp),
          ),
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

  Future<void> resendOtp() async {
    final result = await authService.forgotPassword(mobile: widget.mobile);
    if (!mounted) return;
    if (result['success']) {
      setState(() {
        remainingSeconds = 60;
      });
      startTimer();
      Functions.success(context, 'OTP sent successfully.');
    } else {
      Functions.error(context, result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Icon(Icons.sms, size: 90, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                'OTP Verification',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the verification code sent to\n${widget.mobile}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 35),
              CustomTextField(
                controller: otpController,
                label: '6-digit OTP',
                icon: Icons.password,
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 10),
              Text(
                remainingSeconds == 0
                    ? 'OTP Expired'
                    : 'Expires in $remainingSeconds seconds',
                style: TextStyle(
                  color: remainingSeconds == 0 ? Colors.red : Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: isLoading ? 'Verifying...' : 'Verify OTP',
                onPressed: isLoading ? null : verifyOtp,
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: remainingSeconds == 0 ? resendOtp : null,

                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
