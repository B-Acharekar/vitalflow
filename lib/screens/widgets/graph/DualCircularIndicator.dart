import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class DualCircularIndicator extends StatelessWidget {
  final double value1;
  final double max1;
  final double value2;
  final double max2;
  final String label1;
  final String label2;
  final Color color1;
  final Color color2;

  // Constructor
  const DualCircularIndicator({
    required this.value1,
    required this.max1,
    required this.value2,
    required this.max2,
    required this.label1,
    required this.label2,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Circular Indicator
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 10.0,
          animation: true,
          percent: (value1 / max1).clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$value1",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
              ),
              Text(
                "${value2}",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w500),
              ),
            ],
          ),
          progressColor: color1,
          backgroundColor: Colors.transparent,
          circularStrokeCap: CircularStrokeCap.round,
        ),

        // Inner Circular Indicator (Smaller Circle)
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          animation: true,
          percent: (value2 / max2).clamp(0.0, 1.0),
          progressColor: color2,
          backgroundColor: Colors.transparent,
          circularStrokeCap: CircularStrokeCap.round,
        ),

        // Displaying the second value outside (below)
        Positioned(
          bottom: -22, // Moves text slightly down
          child: Row(
            children: [
              Icon(Icons.star, color: color2, size: 16),
              SizedBox(width: 5),
              Text(
                "${value2.toInt()} $label2",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
