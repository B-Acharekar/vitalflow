import 'package:flutter/material.dart';
import '../services/water_intake_service.dart';

class WaterIntakeUtils {
  static Future<void> logWaterIntake(BuildContext context, dynamic amountInLiters, Function refreshData) async {
    try {
      // Ensure correct conversion
      double amountInMl = (double.tryParse(amountInLiters.toString()) ?? 0.0) * 1000;

      await WaterIntakeService.logWaterIntake(amountInMl);

      // Refresh data after logging
      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged $amountInLiters L of water!")),
      );
    } catch (e) {
      print("Error logging water intake: $e");
    }
  }
}
