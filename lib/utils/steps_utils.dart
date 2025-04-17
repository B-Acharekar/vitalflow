import '../services/steps_service.dart';

class StepsUtils {
  static void logUserSteps(double steps,{double goal = 10000}) async {
    try {

      Map<String, dynamic> response = await StepService.logSteps(steps, stepsGoal: goal);

      print("Step log response: $response");
    } catch (error) {
      print("Error logging steps: $error");
    }
  }

  static Future<List<dynamic>> fetchStepCount({String timeRange = "today"}) async {
    try {
      Map<String, dynamic> stepData = await StepService.getSteps(timeRange);
      List<dynamic> stepRecords = stepData["steps"] ?? [];
      return stepRecords;
    } catch (e) {
      return Future.error("Error fetching step data: $e");
    }
  }

  static Future<Map<String, dynamic>> logStepCount(double stepsCount, {double? stepsGoal}) async {
    try {
      return await StepService.logSteps(stepsCount, stepsGoal: stepsGoal);
    } catch (e) {
      return Future.error("Error logging steps: $e");
    }
  }
}

