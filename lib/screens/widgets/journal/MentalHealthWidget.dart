import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class MentalHealthWidget extends StatelessWidget {
  final double stressLevel;
  final double dayScore;
  final Function(String note, double? stressValue) onLogStress;
  final Function(String note, double? dayScoreValue) onLogDayScore;

  const MentalHealthWidget({
    required this.stressLevel,
    required this.dayScore,
    required this.onLogStress,
    required this.onLogDayScore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF0A0F2C).withOpacity(0.2),// Semi-transparent background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ExpansionTile(
            title: Text("Mental Health", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Stress Level", stressLevel),
              _metricRow("Day Score", dayScore),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showInputDialog(context, "Stress Level", onLogStress),
                child: Text("Log Stress", style: GoogleFonts.poppins(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showInputDialog(context, "Day Score", onLogDayScore),
                child: Text("Log Day Score", style: GoogleFonts.poppins(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricRow(String label, double value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
        Text(value.toStringAsFixed(1), style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );

  void _showInputDialog(BuildContext context, String title, Function(String, double?) onSubmit) {
    final TextEditingController valueController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1976D2), // Blue background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Log $title",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Value Input
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter $title value (optional)",
                hintStyle: GoogleFonts.poppins(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Note Input
            TextField(
              controller: noteController,
              maxLines: 3,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: title == "Stress Level"
                    ? "How are you feeling right now?"
                    : "How was your day so far?",
                hintStyle: GoogleFonts.poppins(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              final note = noteController.text.trim();
              final value = double.tryParse(valueController.text);
              onSubmit(note, value);
              Navigator.of(context).pop();
            },
            child: Text("Submit", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
