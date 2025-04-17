import '../services/water_intake_service.dart';

class WaterIntakeUtils {
  static Future<List<dynamic>> fetchWater({String timeRange = "today"}) async {
    try {
      Map<String, dynamic> waterData = await WaterIntakeService.getWaterIntake(timeRange);
      List<dynamic> waterRecord = waterData["water_intake"] ?? [];
      return waterRecord;
    } catch (e) {
      return Future.error("Error fetching step data: $e");
    }
  }

  static Future<Map<String, dynamic>> logUserWaterIntake(double waterIntake) async {
    try {
      return await WaterIntakeService.logWaterIntake(waterIntake.toString());
    } catch (e) {
      return Future.error("Error logging steps: $e");
    }
  }
}
