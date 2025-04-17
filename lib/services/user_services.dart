import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device
  // Change this to your Flask server URL if running on a real device
  static const String baseUrl = "http://192.168.197.43:5000";

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Extract user ID correctly from nested object
      if (data.containsKey("user") && data["user"].containsKey("id")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", data["user"]["id"].toString());  // Convert to String
      } else {
        print("Login Failed: 'user_id' is missing in the response.");
      }

      return data;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> registerUser(
      String name,
      String email,
      String password,
      String securityQuestion,
      String securityAnswer,
      ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "security_question": securityQuestion,
        "security_answer": securityAnswer,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Signup failed: ${response.body}");
    }
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  static Future<void> fetchAndStoreUsername() async {
    String? userId = await getUserId();
    if (userId == null) return;

    final response = await http.post(
      Uri.parse("$baseUrl/get_username"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String name = data["name"] ?? "Guest";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", name);
    } else {
      print("Failed to fetch username: ${response.body}");
    }
  }

  // Forgot Password Functionality
  static Future<Map<String, dynamic>> forgotPassword(String email, String securityAnswer, String newPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/forgot_password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "security_answer": securityAnswer,
        "new_password": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);  // Password reset successful
    } else {
      throw Exception("Password reset failed: ${response.body}");
    }
  }
}
