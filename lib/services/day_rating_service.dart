import 'dart:convert';
import 'package:http/http.dart' as http;

class DayRatingService {
  static const String baseUrl = "http://10.0.2.2:5000/";

  /// Fetch Day Rating
  static Future<Map<String, dynamic>> getDayRating(String userId, {String timeRange = "today"}) async {
    try {
      final Uri url = Uri.parse("$baseUrl/day-rating/get?user_id=$userId&time_range=$timeRange");
      final response = await http.get(url);
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
  static Future<Map<String, dynamic>> logDayRating(String userId, double dayRating) async {
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
}
