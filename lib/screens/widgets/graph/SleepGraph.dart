import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepTrackerWidget extends StatelessWidget {
  final double sleepHours; // Actual sleep hours
  final double goalSleepHours; // Goal sleep hours

  const SleepTrackerWidget({
    Key? key,
    required this.sleepHours,
    required this.goalSleepHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sleepProgress = (sleepHours / goalSleepHours).clamp(0.0, 1.0);

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
                Icon(Icons.nightlight_round, color: Colors.blue, size: 28),
                SizedBox(width: 10),
                Text(
                  "Sleep Tracker",
                  style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Sleep Stats
            Text(
              "Hours Slept: ${sleepHours.toStringAsFixed(1)} hrs",
              style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Goal: ${goalSleepHours.toStringAsFixed(1)} hrs",
              style: GoogleFonts.poppins(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),

            // Sleep Progress Bar (Fixed)
            _buildSleepProgressBar(sleepProgress, context),

            // Completion Percentage
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(sleepProgress * 100).toInt()}% completed",
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepProgressBar(double progress, BuildContext context) {
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
          width: MediaQuery.of(context).size.width * 0.6 * progress, // Dynamic width
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
