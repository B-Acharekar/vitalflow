import 'package:flutter/material.dart';
import 'dart:ui'; // For blur
import 'package:google_fonts/google_fonts.dart';

class SleepWidget extends StatelessWidget {
  final double sleepHours;
  final double goalSleepHours;
  final Function(double) onSleepHoursChanged;
  final Function(double) onGoalSleepHoursChanged;

  const SleepWidget({
    required this.sleepHours,
    required this.goalSleepHours,
    required this.onSleepHoursChanged,
    required this.onGoalSleepHoursChanged,
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
            title: Text("Sleep", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Sleep Duration", "$sleepHours hrs"),
              _metricRow("Sleep Goal", "$goalSleepHours hrs"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showSleepDialog(context),
                child: Text("Log Sleep", style: GoogleFonts.poppins(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );

  void _showSleepDialog(BuildContext context) {
    final TextEditingController sleepController = TextEditingController();
    final TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1976D2) ,
        title: Text("Update Sleep Info", style: GoogleFonts.poppins(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sleepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter sleep duration (hrs)",
                hintStyle: GoogleFonts.poppins(color: Colors.white70), // Soft white hint
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: GoogleFonts.poppins(color: Colors.white),
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter sleep goal (hrs)",
                hintStyle: GoogleFonts.poppins(color: Colors.white70), // Soft white hint
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
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
              final sleep = double.tryParse(sleepController.text);
              final goal = double.tryParse(goalController.text);

              if (sleep != null) onSleepHoursChanged(sleep);
              if (goal != null) onGoalSleepHoursChanged(goal);

              Navigator.of(context).pop();
            },
            child: Text("Save", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
