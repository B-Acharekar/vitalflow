import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StressService {
  static const String baseUrl = "http://10.0.2.2:5000";

  // Fetch Stress Level with Time Range
  static Future<Map<String, dynamic>> getStress(String timeRange) async {
    String? userId = await getUserId();
    if (userId == null) return Future.error("User not logged in");

    final response = await http.get(
      Uri.parse("$baseUrl/get-stress/$userId/$timeRange"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error("Error fetching stress: ${response.body}");
    }
  }
  

  // Retrieve User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
