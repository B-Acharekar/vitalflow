import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class HeartRateCard extends StatelessWidget {
  final double heartRate;
  const HeartRateCard({super.key, required this.heartRate});

  // This method provides an insight based on the number of HeartRate taken
  String _insightHeartRate(double heartRate) {
    if (heartRate > 100) {
      return "Your heart rate is high! Consider resting and monitoring your health.";
    } else if (heartRate < 60) {
      return "Your heart rate is low. If you feel dizzy, consult a doctor.";
    } else {
      return "Your heart rate is normal. Keep maintaining a healthy lifestyle!";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the HeartRate count
    String insightMessage = _insightHeartRate(heartRate);

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
          // Row to show Icon and HeartRate info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.favorite, color: Colors.red, size: 30),
              ),
              const SizedBox(width: 20),
              // HeartRate info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Heart Rate", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "${heartRate.toInt()} bpm",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between HeartRate and insight message

          // Display the insight message below the HeartRate count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
