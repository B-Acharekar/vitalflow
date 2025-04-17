import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DualCircularIndicator.dart';

class HeartStepGraph extends StatelessWidget {
  final double heartRate;
  final double stepCount;
  final double goalStepCount;

  // Constructor
  const HeartStepGraph({
    required this.heartRate,
    required this.stepCount,
    required this.goalStepCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            DualCircularIndicator(
              value1: heartRate,
              max1: 180,
              value2: stepCount,
              max2: goalStepCount,
              label1: "Heart Rate",
              label2: "Steps",
              color1: Colors.green,
              color2: Colors.blue,
            ),
            SizedBox(height: 10), // Space between the graph and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text(
                  "Heart Rate: ${heartRate.toInt()} bpm",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20), // Space between Heart Rate & Steps
                Icon(Icons.directions_walk, color: Colors.blue, size: 20),
                SizedBox(width: 5),
                Text(
                  "Steps: ${stepCount.toInt()}",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
