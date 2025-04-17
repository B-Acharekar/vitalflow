import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

class ActivityWidget extends StatelessWidget {
  final int stepCount;
  final int goalSteps;
  final Function(int) onStepCountChanged; // Callback for logging

  const ActivityWidget({
    required this.stepCount,
    required this.goalSteps,
    required this.onStepCountChanged, // Pass in the logging function
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF0A0F2C).withOpacity(0.2),// Semi-transparent background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded corners
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect for glassmorphism
          child: ExpansionTile(
            title: Text("Activity", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent.withOpacity(0.1), // Glass effect
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Steps", stepCount),
              _metricRow("Step Goal", goalSteps),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showStepCountDialog(context); // Show dialog to input steps
                },
                child: Text("Log Step Count", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricRow(String label, int value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text("$value", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );

  // Function to show dialog for entering step count
  void _showStepCountDialog(BuildContext context) {
    final TextEditingController stepController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1976D2) ,
        title: Text("Enter Step Count", style: TextStyle(color: Colors.white)),
        content: TextField(
          style: TextStyle(color: Colors.white),
          controller: stepController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Steps",
            hintStyle: TextStyle(color: Colors.white70), // Soft white hint
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
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              final enteredSteps = int.tryParse(stepController.text);
              if (enteredSteps != null) {
                onStepCountChanged(enteredSteps); // Log the custom step count
                Navigator.of(context).pop(); // Close dialog
              } else {
                // Show error if invalid input
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid number")));
              }
            },
            child: Text("Log", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
