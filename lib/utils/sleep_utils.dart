import '../services/sleep_service.dart';

class SleepUtils {
  //log
  static void logUserSleep(int sleepDuration, {int sleepGoal = 450}) async {
    String sleepQuality = "";
    if (300< sleepDuration && sleepDuration < sleepGoal){
      sleepQuality = "Good";
    } else {
      sleepQuality = "Bad";
    }
    try {
      Map<String, dynamic> response = await SleepService.logSleep(sleepDuration,sleepQuality,sleepGoal: sleepGoal);
      print("Step log response: $response");
    } catch (error) {
      print("Error logging steps: $error");
    }
  }
  // fetch
  static Future<List<dynamic>> fetchSleep({String timeRange = "today"}) async {
    try {
      Map<String, dynamic> sleepData = await SleepService.getSleep(timeRange);
      List<dynamic> sleepRecords = sleepData["sleep"] ?? [];
      return sleepRecords;
    } catch (e) {
      return Future.error("Error fetching step data: $e");
    }
  }
}
