import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DayRatingService {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Change for real device
  static const String baseUrl = "http://192.168.197.43:5000";
  /// Fetch Day Rating
  static Future<Map<String, dynamic>> getDayRating(String timeRange) async {
    String? userId = await getUserId();
    try {
      final response = await http.get(Uri.parse("$baseUrl/day-rating/get?user_id=$userId&time_range=$timeRange"));
      // print("${response.body}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to fetch day rating"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  /// Log New Day Rating
  static Future<Map<String, dynamic>> logDayRating(double dayRating) async {
    String? userId = await getUserId();
    try {
      final Uri url = Uri.parse("$baseUrl/day-rating/log");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId, "day_rating": dayRating}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to log day rating"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> logAnlyzDayRating(String note) async {
    String? userId = await getUserId();
    try {
      final Uri url = Uri.parse("$baseUrl/day-rating/log");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId, "user_note": note}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to log day rating"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}

