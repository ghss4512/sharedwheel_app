import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/settings_service.dart';
import '../../utils/functions.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final SettingsService settingsService = SettingsService();
  String supportEmail = '';
  String supportPhone = '';
  String whatsappNumber = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    supportEmail = await settingsService.getSetting(
      'support_email',
      'ghss4512@gmail.com',
    );
    supportPhone = await settingsService.getSetting(
      'support_phone',
      '+923027890743',
    );
    whatsappNumber = await settingsService.getSetting(
      'whats_app',
      '+923027890743',
    );
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Contact Support'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.support_agent,
                    size: 60,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Need Help?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Our support team is here to help.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email Support'),
              subtitle: Text(supportEmail),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Functions.launchEmail(email: supportEmail, subject: 'SharedWheel Support');
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Phone Support'),
              subtitle: Text(supportPhone),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Functions.launchPhone(phone: supportPhone);
              }
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.chat, color: Colors.teal),
              title: const Text('WhatsApp'),
              subtitle: Text(whatsappNumber),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Functions.launchWhatsApp(whatsappNumber: whatsappNumber, message: 'Hello SharedWheel Support');
              }
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('Report an Issue'),
              subtitle: const Text('Submit a complaint or bug report'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Open complaint screen
              },
            ),
          ),

          const SizedBox(height: 20),

          Card(
            color: AppColors.primary.withAlpha(15),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Support Hours\n\n'
                'Monday - Saturday\n'
                '09:00 AM - 06:00 PM',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
