import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';

class Functions {
  // 1. A private named constructor prevents instantiation
  Functions._();

  // 2. Define your global static methods here

  /// Formats a double to a comma-separated currency string (e.g., $1,250,500.00)
  static String formatCurrency(double amount, int decimals) {
    // 1. Force exactly 2 decimal places
    String fixed = amount.toStringAsFixed(decimals);
    // 2. Split the string into the integer part and the decimal part
    List<String> parts = fixed.split('.');
    // 3. Use RegEx to inject commas every 3 digits from right-to-left
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    parts[0] = parts[0].replaceAllMapped(reg, (Match match) => '${match[1]},');
    // 4. Re-combine with the dollar sign
    return parts.join('.');
  }

  /// Validates if an email address is properly formatted
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Format date only
  static String formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  /// Format date and time
  static String formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  /// Converts a 24-hour time string (e.g., "14:30" or "24:00") to 12-hour AM/PM format
  static String convertTo12Hour(String time24) {
    // Handle empty or invalid formats safely
    if (time24.isEmpty || !time24.contains(':')) return time24;
    try {
      final parts = time24.split(':');
      int hours = int.parse(parts[0]);
      final String minutes = parts[1];
      // Handle the 24:00 edge case and normal midnight bounds
      if (hours == 24 || hours == 0) {
        return '12:$minutes AM';
      }
      // Determine AM or PM period
      final String period = hours >= 12 ? 'PM' : 'AM';
      // Convert hour to 12-hour format
      if (hours > 12) {
        hours -= 12;
      }
      return '$hours:$minutes $period';
    } catch (e) {
      // Return original string if parsing fails (e.g., bad inputs like "abc")
      return time24;
    }
  }

  /// Helper to quickly show a success SnackBar
  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Helper to quickly show a error SnackBar
  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Helper to quickly show a info SnackBar
  static void info(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.info,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 1. Pushes a new screen onto the navigation stack (Keeps previous screen alive)
  static Future<dynamic> navigateTo(BuildContext context, Widget targetScreen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  static Future<dynamic> navigateToAsync(
    BuildContext context,
    Widget targetScreen,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  /// 2. Replaces the current screen with a new one (Destroys previous screen)
  static void replaceWith(BuildContext context, Widget targetScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  /// Converts a string to Proper Case (Capitalizes first letter of every word)
  static String toProperCase(String text) {
    // Handle empty or whitespace-only strings safely
    if (text.trim().isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          // Capitalize the first letter and make the rest lowercase
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  // Helper functions for launching external apps
  static Future<void> launchPhone({required String phone}) async {
    final uri = Uri.parse('tel:$phone');

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  // Helper functions for launching external apps
  static Future<void> launchEmail({
    required String email,
    required String subject,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  // Helper functions for launching external apps
  static Future<void> launchWhatsApp({
    required String whatsappNumber,
    required String message,
  }) async {
    final cleanedNumber = whatsappNumber
        .replaceAll('+', '')
        .replaceAll(' ', '');

    final uri = Uri.parse(
      'https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  static Future<bool> confirm(
    BuildContext context,
    String message, {
    String title = 'Confirmation',
    String confirmText = 'Yes',
    String cancelText = 'No',
    Color confirmColor = Colors.red,
    IconData icon = Icons.help_outline,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static Future<void> infoDialog(
      BuildContext context,
      String message, {
        String title = 'Information',
      }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> successDialog(
      BuildContext context,
      String message,
      ) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> errorDialog(
      BuildContext context,
      String message,
      ) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
