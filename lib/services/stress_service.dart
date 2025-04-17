import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StressService {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device
  static const String baseUrl = "http://192.168.197.43:5000";

  static Future<Map<String, dynamic>> logStress( int stressLevel, {String note = ""}) async {
    const String apiUrl = "/log-stress"; // Replace with actual backend URL
  String? userId = await getUserId();
  if (userId == null) {
    return Future.error("User not logged in");
  }
  try {
    final response = await http.post(
      Uri.parse("$baseUrl$apiUrl"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "stress_level": stressLevel,
        "note": note,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // Return decoded JSON response
    } else {
      throw Exception("Failed to log stress: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    throw Exception("Error logging stress: $e");
  }
}
  static Future<Map<String, dynamic>> logAnlyzStress( String note ) async {
    const String apiUrl = "/log-stress"; // Replace with actual backend URL
    String? userId = await getUserId();
    if (userId == null) {
      return Future.error("User not logged in");
    }
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$apiUrl"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "note": note,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // Return decoded JSON response
      } else {
        throw Exception("Failed to log stress: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error logging stress: $e");
    }
  }

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
