import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StepService {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device
  static const String baseUrl = "http://192.168.197.43:5000";

  // ✅ Log Steps
  static Future<Map<String, dynamic>> logSteps(double stepsCount, {double? stepsGoal}) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/log-steps"), // ✅ Matches Flask API
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "steps_count": stepsCount,
        "steps_goal": stepsGoal ?? null,  // ✅ Explicitly send null if not provided
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error logging steps: ${response.body}");
    }
  }

  // ✅ Get Steps
  static Future<Map<String, dynamic>> getSteps(String timeRange) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/get-steps/$userId?range=$timeRange"), // ✅ Corrected
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error fetching steps: ${response.body}");
    }
  }

  // ✅ Retrieve Stored User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id"); // Assumes user_id is stored after login
  }
}
