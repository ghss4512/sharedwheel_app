import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userType = 'passenger';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const Text(
                    'Join SharedWheel',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Create your account and start travelling smarter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 8),
                  CustomTextField(label: 'Full Name', icon: Icons.person),
                  const SizedBox(height: 8),
                  CustomTextField(label: 'Phone Number', icon: Icons.phone, keyboardType: TextInputType.phone,),
                  const SizedBox(height: 8),
                  CustomTextField(label: 'Password', icon: Icons.lock, obscureText: true,),
                  const SizedBox(height: 8),
                  CustomTextField(label: 'Confirm Password', icon: Icons.lock_outline, obscureText: true,),
                  const SizedBox(height: 8),
                  Text("Register As", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('🚶 Passenger'),
                          selected: userType == 'passenger',
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: userType == 'passenger'
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              userType = 'passenger';
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('🚗 Driver'),
                          selected: userType == 'driver',
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: userType == 'driver'
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              userType = 'driver';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity, // Forces full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        foregroundColor: Colors.white, // Text and icon color
                      ),
                      onPressed: () {
                        //API Code
                      },
                      child: const Text('Create Account'),
                    ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('Login', style: TextStyle(fontSize: 20),),
                      ),
                    ],
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
