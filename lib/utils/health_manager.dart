import 'package:flutter/services.dart';

class HealthManager {
  static const platform = MethodChannel('vitalflow/health');

  Future<int> fetchStepCount() async {
    try {
      return await platform.invokeMethod<int>('getStepCount') ?? 0;
    } catch (e) {
      print("Failed to get step count: $e");
      return 0;
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
