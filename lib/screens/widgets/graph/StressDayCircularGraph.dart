import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/screens/widgets/graph/DualCircularIndicator.dart';

class StressDayCircularGraph extends StatelessWidget {
  final double stressLevel;
  final double dayRating ;

  const StressDayCircularGraph({
    required this.stressLevel,
    required this.dayRating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            SizedBox(height: 22), // Increased spacing for better readability
            DualCircularIndicator(
              value1: stressLevel,
              max1: 10,
              value2: dayRating, max2: 10,
              label1: "S-Level.",
              label2: "D-Rating",
              color1: Colors.red,
              color2: Colors.orange
              ),
            SizedBox(height: 22), // Increased spacing for better readability
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.self_improvement, color: Colors.red, size: 22), // Stress Icon
                SizedBox(width: 4),
                Text(
                  "S-Level: $stressLevel",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 6),
                Icon(Icons.star, color: Colors.orange, size: 22), // Day Rating Icon
                SizedBox(width: 4),
                Text(
                  "D-Rating: $dayRating",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
