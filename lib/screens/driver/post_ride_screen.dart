import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PostRideScreen extends StatelessWidget {
  const PostRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Post Ride'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Post Ride Coming Soon', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}