import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController nameController = TextEditingController(text: 'Abdul Ghafoor');
  final TextEditingController phoneController = TextEditingController(text: '+92 300 1234567');
  final TextEditingController emailController = TextEditingController(text: 'abdul@example.com');
  final TextEditingController cityController = TextEditingController(text: 'Lahore');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                CircleAvatar(
                  backgroundColor:
                  AppColors.primary,
                  child: IconButton(
                    onPressed: () {

                      // Pick Image

                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            CustomTextField(
              label: 'Full Name',
              icon: Icons.person,
              controller: nameController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Email Address',
              icon: Icons.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'City',
              icon: Icons.location_city,
              controller: cityController,
            ),

            const SizedBox(height: 25),

            PrimaryButton(
              text: 'Save Changes',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully',),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}