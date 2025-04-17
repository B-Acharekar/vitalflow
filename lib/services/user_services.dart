import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "http://10.0.2.2:5000"; // For Emulator
  // Change this to your Flask server URL if running on a real device

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

  static Future<Map<String, dynamic>> registerUser(String name,String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {  // Assuming 201 means "Created"
      return jsonDecode(response.body);
    } else {
      throw Exception("Signup failed: ${response.body}");
    }
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
