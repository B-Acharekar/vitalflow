import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class VitalsWidget extends StatelessWidget {
  final double heartRate;
  final void Function(double) onHeartRateChanged;

  const VitalsWidget({
    required this.heartRate,
    required this.onHeartRateChanged,
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
            title: Text(
              "Vitals",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Heart Rate (BPM)", heartRate),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showHeartRateDialog(context),
                child: Text("Log Heart Rate", style: GoogleFonts.poppins(color: Colors.white)),
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
        Text("$value", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );

  void _showHeartRateDialog(BuildContext context) {
    final TextEditingController heartRateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1976D2) ,
        title: Text("Log Heart Rate", style: GoogleFonts.poppins(color: Colors.white)),
        content: TextField(
          style: GoogleFonts.poppins(color: Colors.white),
          controller: heartRateController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Heart Rate (BPM)",
            hintStyle: GoogleFonts.poppins(color: Colors.white70), // Soft white hint
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              final double? enteredHR = double.tryParse(heartRateController.text);
              if (enteredHR != null) {
                onHeartRateChanged(enteredHR);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a valid number")),
                );
              }
            },
            child: Text("Log", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
