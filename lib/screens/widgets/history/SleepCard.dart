import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepCard extends StatelessWidget {
  final double sleepHours;
  const SleepCard({super.key, required this.sleepHours});

  // This method provides an insight based on the number of Sleep taken
  String _insightSleep(double sleepHours) {
    if (sleepHours < 5) {
      return "You're not getting enough sleep! Try to rest more for better health. 😴";
    } else if (sleepHours < 7) {
      return "Your sleep is slightly low. Aim for at least 7.5 hours for optimal rest.";
    } else if (sleepHours <= 8) {
      return "Great! Your sleep duration is in a healthy range. Keep it up! 🌙";
    } else {
      return "You're sleeping a lot! Ensure it’s quality sleep and stay active. ☀️";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the Sleep count
    String insightMessage = _insightSleep(sleepHours);

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
          // Row to show Icon and Sleep info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.nights_stay, color: Colors.teal, size: 30),
              ),
              const SizedBox(width: 20),
              // Sleep info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sleep", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "$sleepHours Hr",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between Sleep and insight message

          // Display the insight message below the Sleep count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
