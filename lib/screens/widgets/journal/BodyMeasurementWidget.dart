import 'package:flutter/material.dart';
import 'dart:ui';

class BodyMeasurementWidget extends StatelessWidget {
  final double height;
  final double weight;
  final void Function(double) onHeightChanged;
  final void Function(double) onWeightChanged;

  const BodyMeasurementWidget({
    required this.height,
    required this.weight,
    required this.onHeightChanged,
    required this.onWeightChanged,
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
              "Body Measurements",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _metricRow("Height (cm)", height),
              _metricRow("Weight (kg)", weight),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _showInputDialog(context, "Height (cm)", onHeightChanged),
                    child: Text("Log Height", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
                  ),
                  ElevatedButton(
                    onPressed: () => _showInputDialog(context, "Weight (kg)", onWeightChanged),
                    child: Text("Log Weight", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1976D2)),
                  ),
                ],
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
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text("$value", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    ),
  );

  void _showInputDialog(BuildContext context, String label, void Function(double) onChanged) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1976D2) ,
        title: Text("Log $label", style: TextStyle(color: Colors.white)),
        content: TextField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter $label",
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              final double? enteredValue = double.tryParse(controller.text);
              if (enteredValue != null) {
                onChanged(enteredValue);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a valid number")),
                );
              }
            },
            child: Text("Log", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
