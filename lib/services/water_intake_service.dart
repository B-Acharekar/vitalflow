import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeService {
  static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device

  //  Log Water Intake
  static Future<Map<String, dynamic>> logWaterIntake(double waterIntakeMl) async {
    String? userId = await getUserId();
    if (userId == null) {
      return {"error": "User not logged in"};
    }

    final response = await http.post(
      Uri.parse("$baseUrl/log-water"), // Matches Flask API
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "water_intake_ml": waterIntakeMl,  //  Matches backend field name
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error logging water intake: ${response.body}");
    }
  }

  //  Get Water Intake
  static Future<Map<String, dynamic>> getWaterIntake() async {
    String? userId = await getUserId();
    if (userId == null) {
      return {"error": "User not logged in"};
    }

    final response = await http.get(
      Uri.parse("$baseUrl/get-water/$userId"), // Matches Flask API
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error fetching water intake: ${response.body}");
    }
  }

  //  Retrieve Stored User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id"); // Assumes user_id is stored after login
  }
}
