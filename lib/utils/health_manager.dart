import 'package:flutter/services.dart';


class HealthManager {
  static const platform = MethodChannel('vitalflow/health');

  Future<int> fetchStepCount() async {
    try {
      final int steps = await platform.invokeMethod('getStepCount') ?? 0;
      print("Steps: $steps");
      return steps;
    } catch (e) {
      print("Error fetching steps: $e");
      return 0; // Return default value in case of error
    }
  }


  Future<double> fetchHeartRate() async {
    try {
      return await platform.invokeMethod<double>('getHeartRate') ?? 0.0;
    } catch (e) {
      print("Failed to get heart rate: $e");
      return 0.0;
    }
  }

  Future<double> fetchWeight() async {
    try {
      return await platform.invokeMethod<double>('getWeight') ?? 0.0;
    } catch (e) {
      print("Failed to get weight: $e");
      return 0.0;
    }
  }

  // Future<double> fetchHeight() async {
  //   try {
  //     return await platform.invokeMethod<double>('getHeight') ?? 0.0;
  //   } catch (e) {
  //     print("Failed to get height: $e");
  //     return 0.0;
  //   }
  // }
}
