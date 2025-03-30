import 'package:flutter/material.dart';
import '../services/steps_service.dart';

class StepsUtils {
  static Future<void> logSteps(BuildContext context, dynamic stepsCount, Function refreshData, {double? stepsGoal}) async {
    try {
      // Ensure correct conversion
      double steps = double.tryParse(stepsCount.toString()) ?? 0.0;

      await StepService.logSteps(steps, stepsGoal: stepsGoal);

      // Refresh data after logging
      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged $stepsCount steps!")),
      );
    } catch (e) {
      print("Error logging steps: $e");
    }
  }
}
