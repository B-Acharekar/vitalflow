import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeightCard extends StatelessWidget {
  final double weight;
  final double? goalWeight;

  const WeightCard({super.key, required this.weight, this.goalWeight});

  String _insightWeight(double weight, double? goal) {
    if (goal == null) return "Track your weight consistently to monitor your health. ⚖️";

    double diff = weight - goal;
    if (diff.abs() < 1) {
      return "You're right on target! Keep it up! 🎯";
    } else if (diff > 0) {
      return "You've exceeded your goal. Try maintaining or adjusting your fitness. 📉";
    } else {
      return "You're on the way to your goal. Keep pushing! 🏋️‍♂️";
    }
  }

  @override
  Widget build(BuildContext context) {
    String insight = _insightWeight(weight, goalWeight);

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
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.monitor_weight, color: Colors.green, size: 30),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Weight", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
                  Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  if (goalWeight != null)
                    Text(
                      "Goal: ${goalWeight!.toStringAsFixed(1)} kg",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            insight,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
