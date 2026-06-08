import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar (
        title: const Text("Change Password"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              const Icon(Icons.lock_reset, size: 80, color: AppColors.primary,),
              SizedBox(height: 20,),
              CustomTextField(label: "Current Password", icon: Icons.lock, obscureText: true, controller: currentPasswordController,),
              SizedBox(height: 15,),
              CustomTextField(label: "New Password", icon: Icons.lock, obscureText: true, controller: newPasswordController,),
              SizedBox(height: 15,),
              CustomTextField(label: "Confirm Password", icon: Icons.lock, obscureText: true, controller: confirmPasswordController,),
              SizedBox(height: 25,),
              PrimaryButton(text: "Update Password", onPressed: () {
                  if (newPasswordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Password do not match"),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully"),),
                  );
              }
              )
            ],
          ),
      ),
    );
  }
}
