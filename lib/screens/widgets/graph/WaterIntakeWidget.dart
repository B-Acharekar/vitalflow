import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterIntakeWidget extends StatelessWidget {
  final double waterIntake; // Example water intake in liters
  final double goalWaterIntake;

  const WaterIntakeWidget({
    required this.waterIntake,
    required this.goalWaterIntake,
});

  @override
  Widget build(BuildContext context) {
    double waterProgress = (waterIntake / goalWaterIntake).clamp(0.0, 1.0);

    return Column(
      children: [
        Text("Water Intake",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w700),

        ),
        SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Bottle Shape (Outer Container)
            Container(
              width: 50,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
            // Water Level (Inner Container)
            Container(
              width: 50,
              height: 150 * waterProgress, // Adjust height based on intake
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text("${waterIntake.toStringAsFixed(1)} / ${goalWaterIntake.toStringAsFixed(1)} L",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w700)
        ),
      ],
    );
  }
}
