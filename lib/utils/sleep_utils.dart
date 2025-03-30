import 'package:flutter/material.dart';
import '../services/sleep_service.dart';

class SleepUtils {
  static Future<void> logSleep(BuildContext context, double sleepDuration, int sleepQuality, Function refreshData, {double? sleepGoal}) async {
    try {
      await SleepService.logSleep(sleepDuration, sleepQuality, sleepGoal: sleepGoal);

      // Refresh UI after logging
      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged Sleep: $sleepDuration min, Quality: $sleepQuality")),
      );
    } catch (e) {
      print("Error logging sleep: $e");
    }
  }
}
