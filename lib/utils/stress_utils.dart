import '../services/stress_service.dart';

class StressUtils {
// Log User Stress Function
  static void logUserStress(int stressLevel, {String note = ""}) async {
    try {
      // Call the backend service to log stress
      Map<String, dynamic> response = await StressService.logStress(stressLevel, note: note);

      print("Stress log response: $response");
    } catch (error) {
      print("Error logging stress: $error");
    }
  }

  static Future<List<dynamic>> fetchStress({String timeRange = "today"}) async {
    try {
      Map<String, dynamic> stressData = await StressService.getStress(timeRange);
      List<dynamic> stressRecords = stressData["stress_logs"] ?? [];
      return stressRecords;
    } catch (e) {
      return Future.error("Error fetching step data: $e");
    }
  }
}
