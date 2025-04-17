import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class HydrationWidget extends StatelessWidget {
  final double waterIntake;
  final Function(String) onNoteSubmitted; // Note will be sent to backend

  const HydrationWidget({
    required this.waterIntake,
    required this.onNoteSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();

    return Card(
      color: Color(0xFF0A0F2C).withOpacity(0.2),// Semi-transparent background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ExpansionTile(
            title: Text("Hydration", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Water Intake", "${waterIntake.toStringAsFixed(1)} L"),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                style: GoogleFonts.roboto(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Enter a hydration note (e.g., 'Drank 2 bottles')",
                  hintStyle: GoogleFonts.roboto(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String note = noteController.text.trim();
                  if (note.isNotEmpty) {
                    onNoteSubmitted(note); // Send note to parent
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Note submitted!", style: GoogleFonts.roboto())),
                    );
                  }
                },
                child: Text("Log Note", style: GoogleFonts.roboto(color: Colors.white)),
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
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );
}
