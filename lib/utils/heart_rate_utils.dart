import 'package:flutter/material.dart';
import '../services/heart_rate_service.dart';

class HeartRateUtils {
  static Future<void> logHeartRate(BuildContext context, double heartRateBpm, Function refreshData) async {
    try {
      await HeartRateService.logHeartRate(heartRateBpm);

      // ✅ Refresh UI after logging
      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged Heart Rate: $heartRateBpm bpm!")),
      );
    } catch (e) {
      print("Error logging heart rate: $e");
    }
  }
}
