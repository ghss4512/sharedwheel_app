import 'package:flutter/material.dart';
import 'package:shared_wheel/screens/auth/forgot_password_screen.dart';
import '../driver/driver_dashboard_screen.dart';
import '../passenger/passenger_dashboard_screen.dart';
import '../../services/auth_service.dart';
import '../../utils/app_session.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/functions.dart';
import '../../models/user_model.dart';
import '../admin/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login', style: TextStyle(fontSize: 20),),
            Text("Sign in to continue using SharedWheel", style: TextStyle(fontSize: 15),)
          ],
        ),
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: BoxBorder.all(width: 3, color: Colors.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            width: 500,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 40),

                  CustomTextField(
                    label: 'Email or Phone',
                    icon: Icons.person,
                    keyboardType: TextInputType.phone,
                    controller: loginController,
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Functions.navigateTo(context, ForgotPasswordScreen());
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(text: 'Login', onPressed: login),

                  const SizedBox(height: 10),

                  const Text(
                    'Travel Smarter Together',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (loginController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Functions.error(context, "Please enter login credentials.");
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService().login(
        loginInput: loginController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result["success"] == true) {
        final UserModel user = UserModel.fromJson(result["user"]);
        AppSession.userId = user.id;
        AppSession.userType = user.userType;
        AppSession.fullName = user.fullName;
        AppSession.phone = user.phone;
        AppSession.email = user.email;

        if (!mounted) return;

        if (user.userType == 'admin') {
          Functions.replaceWith(context, AdminDashboardScreen());
        } else if (user.userType == 'passenger') {
          Functions.replaceWith(context, PassengerDashboardScreen());
        } else if (user.userType == 'driver') {
          Functions.replaceWith(context, DriverDashboardScreen());
        }
      }
      else {
        Functions.error(context, result["message"].toString());
      }
    } catch (e) {
      Functions.error(context, e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
