import '../services/heart_rate_service.dart';

class HeartRateUtils {
  static void logUserHeartRate(double heartRateBpm) async {
    try {
      Map<String, dynamic> response = await HeartRateService.logHeartRate(heartRateBpm);
      print("Step log response: $response");
    } catch (error) {
      print("Error logging steps: $error");
    }
  }
  static Future<List<dynamic>> fetchHeartRate({String timeRange = "today"}) async {
    try {
      Map<String, dynamic> heartData = await HeartRateService.getHeartRate(timeRange);
      List<dynamic> heartRecords = heartData["heart_rate_log"] ?? [];
      return heartRecords;
    } catch (e) {
      return Future.error("Error fetching step data: $e");
    }
  }
}
