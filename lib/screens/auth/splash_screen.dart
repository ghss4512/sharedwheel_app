import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/functions.dart';
import '../public/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // checkLogin()
    welcomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D6EFD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),

              child: const Icon(
                Icons.directions_car,
                size: 70,
                color: Color(0xFF0D6EFD),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'SharedWheel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Travel Smarter Together',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> welcomeScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Functions.replaceWith(context, const WelcomeScreen());
  }

  // Future<void> checkLogin() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   final bool loggedIn = await AppSession.loadSession();
  //   if (!mounted) return;
  //   if (loggedIn) {
  //     if (AppSession.userType == 'passenger') {
  //       Functions.replaceWith(context, PassengerDashboardScreen());
  //     } else if (AppSession.userType == 'driver') {
  //       Functions.replaceWith(context, DriverDashboardScreen());
  //     } else if (AppSession.userType == 'admin') {
  //       AdminDashboardScreen();
  //     }
  //   } else {
  //     Functions.replaceWith(context, LoginScreen());
  //     // AppNavigator.replace(context, const LoginScreen());
  //   }
  // }
}
