import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class StressCard extends StatelessWidget {
  final double stress;
  const StressCard({super.key, required this.stress});

  // This method provides an insight based on the number of stress taken
  String _insightStress(double stress) {
    if (stress >= 70) {
      return "Your stress level is high! Consider visiting a doctor or therapist.";
    } else if (stress >= 40) {
      return "Moderate stress detected. Try changing your environment, drinking water, and relaxing.";
    } else {
      return "Your stress level is low. Stay happy! 😊";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the stress count
    String insightMessage = _insightStress(stress);

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
          // Row to show Icon and stress info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.sentiment_dissatisfied, color: Colors.deepOrange, size: 30),
              ),
              const SizedBox(width: 20),
              // stress info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stress Level", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "$stress",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between stress and insight message

          // Display the insight message below the stress count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
