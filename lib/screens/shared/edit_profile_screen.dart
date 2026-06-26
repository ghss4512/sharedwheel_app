import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/profile_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await ProfileService().getProfile();
      if (profile == null) {
        return;
      }

      fullNameController.text = profile.fullName;
      emailController.text = profile.email;
      phoneController.text = profile.phone;
      cityController.text = profile.city;
      addressController.text = profile.address;

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isSaving = true;
    });

    try {
      final result = await ProfileService().updateProfile(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        address: addressController.text.trim(),
      );
      if (!mounted) return;
      if (result['success'] == true) {
        AppSession.fullName = fullNameController.text.trim();
        AppSession.email = emailController.text.trim();
        AppSession.phone = phoneController.text.trim();
        Navigator.pop(context, true);
      } else {
        Functions.error(context, 'Unable to update profile');
      }
    } catch (e) {
      Functions.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isSaving ? 'Saving...' : 'Save Changes'),
                onPressed: isSaving ? null : saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
