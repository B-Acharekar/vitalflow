import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vitalflow/utils/health_manager.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthManager healthManager = HealthManager();
  int stepCount = 0;
  double heartRate = 0.0;
  double weight = 0.0;
  double sleepHours = 7.0;
  double waterIntake = 2.5;
  double stressLevel = 5.0;
  Timer? _timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) => fetchData());
  }

  void fetchData() async {
    setState(() => isLoading = true);

    int steps = await healthManager.fetchStepCount();
    double bpm = await healthManager.fetchHeartRate();
    double kg = await healthManager.fetchWeight();

    setState(() {
      stepCount = steps;
      heartRate = bpm;
      weight = kg;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('VitalFlow', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularProgress('Steps', stepCount.toDouble(), 10000, Colors.lightBlueAccent, Icons.directions_walk),
                _buildCircularProgress('Heart Rate', heartRate, 150, Colors.green, Icons.favorite),
              ],
            ),
            SizedBox(height: 20),
            _buildBarGraph('Weight', weight, 80, Colors.deepOrange, Icons.fitness_center),
            SizedBox(height: 20),
            _buildHorizontalBarGraph('Sleep Time', sleepHours, 8, Colors.pinkAccent, Icons.nightlight_round),
            SizedBox(height: 20),
            _buildHorizontalBarGraph('Water Intake (L)', waterIntake, 4, Colors.cyan, Icons.local_drink),
            SizedBox(height: 20),
            _buildCircularProgress('Stress Level', stressLevel, 10, Colors.orange, Icons.self_improvement),
            Spacer(),
            ElevatedButton(
              onPressed: isLoading ? null : fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: isLoading ? CircularProgressIndicator(color: Colors.black) : Text('Refresh Data'),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(String label, double value, double max, Color color, IconData icon) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value / max,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 24),
                    SizedBox(height: 5),
                    Text(value.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBarGraph(String label, double value, double max, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${value.toStringAsFixed(1)} kg', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade800,
          ),
          child: FractionallySizedBox(
            widthFactor: value / max,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalBarGraph(String label, double value, double max, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${value.toStringAsFixed(1)} hrs', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade800,
          ),
          child: FractionallySizedBox(
            widthFactor: value / max,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
