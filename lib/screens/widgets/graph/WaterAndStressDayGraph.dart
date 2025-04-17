import 'package:flutter/material.dart';

import 'StressDayCircularGraph.dart';
import 'WaterIntakeWidget.dart';

class WaterAndStressDayGraph extends StatelessWidget {
  final double waterIntake; // Example water intake in liters
  final double goalWaterIntake;
  final double stressLevel;
  final double dayRating ;

  const WaterAndStressDayGraph({
    required this.waterIntake,
    required this.goalWaterIntake,
    required this.stressLevel,
    required this.dayRating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF0A0F2C).withOpacity(0.2),// Semi-transparent background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WaterIntakeWidget(waterIntake: waterIntake,goalWaterIntake: goalWaterIntake,), // Assuming this widget shows water intake info
                StressDayCircularGraph(stressLevel: stressLevel,dayRating: dayRating), // Assuming this widget shows stress day graph
              ],
            ),
          ],
        ),
      ),
    );
  }
}
