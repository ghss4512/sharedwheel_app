import 'package:flutter/material.dart';

class AppNavigator {
  static Future<dynamic> push(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  static Future<dynamic> replace(BuildContext context, Widget screen,) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  static Future<dynamic> pushAndRemoveAll(BuildContext context, Widget screen) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
          (route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}