import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterIntakeCard extends StatelessWidget {
  final int water;
  const WaterIntakeCard({super.key, required this.water});

  // This method provides an insight based on the number of water taken
  String _insightWater(double waterIntake) {
    if (waterIntake < 1000) {
      return "You're drinking too little water! Stay hydrated for better health.";
    } else if (waterIntake < 2500) {
      return "Your water intake is moderate. Try to drink more if needed.";
    } else {
      return "You're well-hydrated! Keep up the good habit. 💧";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the water count
    String insightMessage = _insightWater(water.toDouble());

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
          // Row to show Icon and water info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.local_drink, color: Colors.blueAccent, size: 30),
              ),
              const SizedBox(width: 20),
              // water info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Water Intake", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "$water ml",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between water and insight message

          // Display the insight message below the water count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
