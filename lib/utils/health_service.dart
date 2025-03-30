import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device

  //  Log Health Data (Weight & Height)
  static Future<Map<String, dynamic>> logHealth(double weight, double height) async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/log-health"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "weight": weight,
        "height": height,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error logging health data: ${response.body}");
    }
  }

  //  Get Health Data (Weight & Height)
  static Future<Map<String, dynamic>> getHealth() async {
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/get-health/$userId"),
      headers: {"Content-Type": "application/json"},
    );

    // print(" Full Health API Response: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error fetching health data: ${response.body}");
    }
  }

  //  Retrieve Stored User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
