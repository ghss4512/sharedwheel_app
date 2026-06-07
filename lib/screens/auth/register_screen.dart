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
          child: Container(
            margin: EdgeInsets.all(5),
            width: 500,
            decoration: BoxDecoration(
              border: BoxBorder.all(width: 5, color: Colors.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(height: 10),
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

                  const SizedBox(height: 20),

                  const Text(
                    'Join SharedWheel',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Create your account and start travelling smarter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),
                  CustomTextField(label: 'Full Name', icon: Icons.person),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Phone Number', icon: Icons.phone, keyboardType: TextInputType.phone,),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Password', icon: Icons.lock, obscureText: true,),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Confirm Password', icon: Icons.lock_outline, obscureText: true,),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text("Register As", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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

                      const SizedBox(width: 12),

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

                  const SizedBox(height: 30),

                  PrimaryButton(text: 'Create Account',
                    onPressed: () {
                      // Registration API call will go here
                    },
                  ),

                  const SizedBox(height: 25),

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
