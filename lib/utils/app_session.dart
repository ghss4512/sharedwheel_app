import 'package:shared_preferences/shared_preferences.dart';
class AppSession {
  static int? userId;
  static String? userType;
  static String? fullName;
  static String? phone;
  static String? email;

  static Future<void> saveSession({
    required int userId,
    required String fullName,
    required String userType,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('full_name', fullName);
    await prefs.setString('user_type', userType);
    await prefs.setString('phone', phone);
    await prefs.setString('email', email);
  }

  static Future<bool> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('user_id');
    fullName = prefs.getString('full_name');
    userType = prefs.getString('user_type');
    phone = prefs.getString('phone');
    email = prefs.getString('email');

    return userId != null;
  }

  static Future<void> clearSession() async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();

    userId = null;
    fullName = null;
    userType = null;
    phone = null;
    email = null;
  }
}