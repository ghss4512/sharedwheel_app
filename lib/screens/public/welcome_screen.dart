import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_info.dart';
import '../../utils/functions.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'about_screen.dart';
import 'contact_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_and_conditions_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;
  Timer? sliderTimer;

  final List<Map<String, dynamic>> slides = [
    {
      'icon': Icons.search,
      'title': 'Find Rides Easily',
      'subtitle': 'Search and book rides across Pakistan in seconds.',
    },
    {
      'icon': Icons.verified_user,
      'title': 'Trusted Drivers',
      'subtitle': 'Travel safely with verified and trusted drivers.',
    },
    {
      'icon': Icons.savings,
      'title': 'Save Travel Costs',
      'subtitle': 'Share rides and reduce your travel expenses.',
    },
  ];

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  void startAutoSlide() {
    sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!pageController.hasClients) {
        return;
      }
      int nextPage = currentPage + 1;
      if (nextPage >= slides.length) {
        nextPage = 0;
      }
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF4A90E2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),

                child: Column(
                  children: [
                    SizedBox(
                      height: 340,
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },

                        itemCount: slides.length,

                        itemBuilder: (context, index) {
                          final slide = slides[index];

                          return Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 92,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withAlpha(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(40),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),

                                  child: Icon(
                                    slide['icon'],
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                                ),

                                Text(
                                  slide['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  slide['subtitle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.white
                                : Colors.white54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Card(
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Ride Sharing Made Easy',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      child: Text(
                        'Connect with trusted drivers and passengers for safe and affordable travel.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Functions.navigateTo(context, const LoginScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: AppColors.primary.withAlpha(100),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Functions.navigateTo(context, const RegisterScreen());
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.primary.withAlpha(120),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Learn More',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    buildMenuTile(
                      context,
                      icon: Icons.info_outline,
                      title: 'About ${AppInfo.appName}',
                      screen: const AboutScreen(),
                    ),

                    buildMenuTile(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      screen: const PrivacyPolicyScreen(),
                    ),

                    buildMenuTile(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      screen: const TermsAndConditionsScreen(),
                    ),

                    buildMenuTile(
                      context,
                      icon: Icons.support_agent,
                      title: 'Contact Support',
                      screen: const ContactSupportScreen(),
                    ),

                    const SizedBox(height: 20),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              'Version ${AppInfo.version}',
                          style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AppInfo.copyright,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Made with ❤️ in Pakistan',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Functions.navigateTo(context, screen);
        },
      ),
    );
  }
}
