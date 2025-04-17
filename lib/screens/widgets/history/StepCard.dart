import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class StepsCard extends StatelessWidget {
  final int steps;
  const StepsCard({super.key, required this.steps});

  // This method provides an insight based on the number of steps taken
  String _insightSteps(int steps) {
    if (steps < 3000) {
      return "You're not moving enough! Try to walk more for better fitness.";
    } else if (steps < 8000) {
      return "You're moderately active. Keep going!";
    } else {
      return "Great job! You're achieving excellent daily activity levels.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the steps count
    String insightMessage = _insightSteps(steps);

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row to show Icon and Steps info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.directions_walk, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 20),
              // Steps info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Steps", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "$steps",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between steps and insight message

          // Display the insight message below the steps count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
