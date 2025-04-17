import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SleepService {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device
  static const String baseUrl = "http://192.168.197.43:5000";

  // Log Sleep Data
  static Future<Map<String, dynamic>> logSleep(int sleepDuration, String sleepQuality, {int? sleepGoal}) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/log-sleep"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "sleep_duration_min": sleepDuration, // Sleep duration in minutes
        "sleep_quality": sleepQuality, // Sleep quality score (e.g., 1-10)
        "sleep_goal": sleepGoal, // Sleep goal (optional)
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error logging sleep: ${response.body}");
    }
  }

  // Get Sleep Data
  static Future<Map<String, dynamic>> getSleep(String timeRange) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/get-sleep/$userId?range=$timeRange"),
      headers: {"Content-Type": "application/json"},
    );

    // print("Sleep API Response: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Fix: Ensure we correctly access "sleep" from API
      List<dynamic> sleepRecords = data["sleep"] ?? [];

      return {"sleep": sleepRecords};
    } else {
      return Future.error("Error fetching sleep data: ${response.body}");
    }
  }

  // Retrieve Stored User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
