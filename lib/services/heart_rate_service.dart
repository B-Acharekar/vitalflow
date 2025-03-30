import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HeartRateService {
  static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device

  //  **Log Heart Rate**
  static Future<Map<String, dynamic>> logHeartRate(double heartRateBpm) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/log-heart-rate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "heart_rate_bpm": heartRateBpm,
      }),
    );

    print("Heart Rate Log Response: ${response.body}"); //  Debugging

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error logging heart rate: ${response.body}");
    }
  }

  //  **Get Heart Rate**
  static Future<Map<String, dynamic>> getHeartRate() async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/get-heart-rate/$userId?range=today"),
      headers: {"Content-Type": "application/json"},
    );

    // print("Heart Rate API Response: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error fetching heart rate: ${response.body}");
    }
  }

  //  **Retrieve User ID**
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
