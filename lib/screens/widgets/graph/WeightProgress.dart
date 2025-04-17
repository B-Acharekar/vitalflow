import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeightProgressWidget extends StatelessWidget {
  final double weight; // Current weight
  final double goalWeight; // Goal weight

  const WeightProgressWidget({
    Key? key,
    required this.weight,
    required this.goalWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double weightProgress = (weight / goalWeight).clamp(0.0, 1.0);

    return Card(
      color: Color(0xFF0A0F2C).withOpacity(0.2),// Semi-transparent background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.deepOrange, size: 28),
                SizedBox(width: 10),
                Text(
                  "Weight Progress",
                  style: GoogleFonts.roboto(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Weight Stats
            Text(
              "Current Weight: ${weight.toStringAsFixed(1)} kg",
              style: GoogleFonts.roboto(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Goal: ${goalWeight.toStringAsFixed(1)} kg",
              style: GoogleFonts.roboto(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),

            // Weight Progress Bar
            _buildProgressBar(weightProgress, context),

            // Completion Percentage
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(weightProgress * 100).toInt()}% achieved",
                style: GoogleFonts.roboto(
                  color: Colors.deepOrangeAccent, fontSize: 12, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, BuildContext context) {
    return Stack(
      children: [
        // Background bar
        Container(
          height: 12,
          width: double.infinity, // Makes it responsive
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Progress bar
        Container(
          height: 12,
          width: MediaQuery.of(context).size.width * 0.8 * progress, // Adjust width dynamically
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
