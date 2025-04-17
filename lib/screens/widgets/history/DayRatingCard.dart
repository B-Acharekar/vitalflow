import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DayRatingCard extends StatelessWidget {
  final double dayRating;
  const DayRatingCard({super.key, required this.dayRating});

  // This method provides an insight based on the number of dayRating taken
  String _insightDayRating(double rating) {
    if (rating <= 30) {
      return "Your day wasn't great. Try to rest and find ways to improve tomorrow. 🌅";
    } else if (rating <= 70) {
      return "An average day! Keep striving for a better one. 💪";
    } else {
      return "You're having an amazing day! Enjoy and keep the positivity going. 🌟";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the insight message based on the dayRating count
    String insightMessage = _insightDayRating(dayRating);

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
          // Row to show Icon and dayRating info
          Row(
            children: [
              // Icon - iOS feel
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.emoji_events, color: Colors.yellowAccent, size: 30),
              ),
              const SizedBox(width: 20),
              // dayRating info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Day Score", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[900])),
                  Text(
                    "$dayRating",
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),  // Spacing between dayRating and insight message

          // Display the insight message below the dayRating count
          Text(
            insightMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
