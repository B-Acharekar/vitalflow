import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/services/steps_service.dart';
import 'package:vitalflow/utils/health_manager.dart';
import 'package:vitalflow/services/water_intake_service.dart';
import 'dart:async';

import '../services/day_rating_service.dart';
import '../services/heart_rate_service.dart';
import '../services/sleep_service.dart';
import '../services/stress_service.dart';
import '../utils/health_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthManager healthManager = HealthManager();
  int stepCount = 0;
  int goalStepCount = 10000;
  double heartRate = 0.0;
  double sleepHours = 6.0;
  double goalSleepHours = 7.5;
  double waterIntake = 3.0;
  double goalWaterIntake = 3.7;
  double stressLevel = 0.0;
  double dayRating = 7;    // Add this variable
  double weight = 56.0;
  double goalWeight = 75.0;
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

    try {
      if (steps != 0 && bpm != 0 && kg != 0) {
        await StepService.logSteps(steps.toDouble(), stepsGoal: 10000);
        await HeartRateService.logHeartRate(bpm);
        await HealthService.logHealth(kg, 170);
      } else {
        steps = 0;
        bpm = 0;
        kg = 0;
      }
    } catch (e) {
      print("Error Logging data: $e");
      setState(() => isLoading = false);
    }

    try {
      //  Fetch Water Intake Data
      Map<String, dynamic> waterData = await WaterIntakeService.getWaterIntake();
      List<dynamic> waterRecords = waterData["water_intake"] ?? [];

      double totalWater = 0.0;
      for (var record in waterRecords) {
        double intake = double.tryParse(record["water_intake_ml"].toString()) ?? 0.0;
        totalWater += intake / 1000.0; // Convert ml to L
      }
      // print("totalwater:$totalWater");
      //  Fetch Step Count Data
      Map<String, dynamic> stepData = await StepService.getSteps();
      List<dynamic> stepRecords = stepData["steps"] ?? [];

      double totalSteps = 0.0;
      double stepsGoal = goalStepCount.toDouble();
      for (var record in stepRecords) {
        totalSteps += double.tryParse(record["steps_count"].toString()) ?? 0.0;
        if (record.containsKey("steps_goal")) {
          stepsGoal = double.tryParse(record["steps_goal"].toString()) ?? goalStepCount.toDouble();
        }
      }

      // Fetch Heart Rate Data
      Map<String, dynamic> heartData = await HeartRateService.getHeartRate();
      List<dynamic> heartRecords = heartData["heart_rate_log"] ?? [];

      double lastHeartRate = 0.0;
      if (heartRecords.isNotEmpty) {
        lastHeartRate = double.tryParse(heartRecords.last["heart_rate_bpm"].toString()) ?? 0.0;
      }

      //  Fetch Sleep Data
      Map<String, dynamic> sleepData = await SleepService.getSleep();
      List<dynamic> sleepRecords = sleepData["sleep"] ?? [];

      double totalSleep = 0.0;
      double sleepGoal = goalSleepHours; // Default goal

      if (sleepRecords.isNotEmpty) {
        var lastRecord = sleepRecords.last;

        // Convert minutes to hours
        totalSleep = (lastRecord["sleep_duration_min"] is num)
            ? (lastRecord["sleep_duration_min"] / 60.0)
            : (double.tryParse(lastRecord["sleep_duration_min"].toString()) ?? 0.0) / 60.0;

        sleepGoal = (lastRecord["sleep_goal"] is num)
            ? (lastRecord["sleep_goal"] / 60.0)
            : (double.tryParse(lastRecord["sleep_goal"].toString()) ?? 450.0) / 60.0;
      }

      // Debugging output
      // print(" Sleep: $totalSleep hrs, Goal: $sleepGoal hrs, Quality: $lastSleepQuality");

      //Fetch Weight data
      Map<String, dynamic> healthData = await HealthService.getHealth();
      List<dynamic> healthRecords = healthData["health_log"] ?? [];  //  Corrected key

      double lastWeight = 0.0;
      if (healthRecords.isNotEmpty) {
        lastWeight = double.tryParse(healthRecords.last["weight"].toString()) ?? 0.0;
      }

      // print(" Weight: $lastWeight kg");
      // fetch stress level
      Map<String, dynamic> stressData = await StressService.getStress("today");
      List<dynamic> stressRecords = stressData["stress_logs"] ?? [];

      int lastStressLevel = 50;
      if (stressRecords.isNotEmpty) {
        lastStressLevel = int.tryParse(stressRecords.last["stress_level"].toString()) ?? 50;
      }

      // print(" Stress Level (): ${lastStressLevel/10}");

      //fetch day rating
      Map<String, dynamic> dayRatingData = await DayRatingService.getDayRating("67d9832aeb911e7404571917");

      // print(" Raw Day Rating Response: $dayRatingData");  // Debugging step

      double lastDayRating = 5.0;  // Default rating

      if (dayRatingData.containsKey("day_rating")) {
        lastDayRating = double.tryParse(dayRatingData["day_rating"].toString()) ?? 5.0;
      }

      // print(" Day Rating Parsed: $lastDayRating");  // Check parsed value

      // print(" Day Rating: $lastDayRating");
      setState(() {
        stepCount = totalSteps.toInt();
        goalStepCount = stepsGoal.toInt();
        heartRate = lastHeartRate > 0 ? lastHeartRate : 120.0;
        waterIntake = totalWater > 0 ? totalWater : 1.0;
        sleepHours = totalSleep > 0 ? totalSleep : 0.0;
        goalSleepHours = sleepGoal > 0 ? sleepGoal : 7.5;
        weight = lastWeight > 0 ? lastWeight : 66;
        stressLevel = lastStressLevel > 0 ? lastStressLevel / 10.0 : 6.0; //  Divide by 10 to match UI
        dayRating = lastDayRating;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
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
      bottomNavigationBar: _buildBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            _buildHeartStepCircularGraphs(),
            SizedBox(height: 20),
            _buildSleepWidget(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWaterIntake(),
                _buildStressDayCircularGraphs(),
              ],
            ),
            SizedBox(height: 20),
            _buildWeightProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartStepCircularGraphs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            _dualCircularIndicator(
                heartRate, 200,
                stepCount.toDouble(), goalStepCount.toDouble(),
                "Heart Rate", "Steps",
                Colors.green, Colors.blue
            ),
            SizedBox(height: 10), // Space between the graph and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text("Heart Rate: ${heartRate.toInt()} bpm",
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold)),

                SizedBox(width: 20), // Space between Heart Rate & Steps

                Icon(Icons.directions_walk, color: Colors.blue, size: 20),
                SizedBox(width: 5),
                Text("Steps: ${stepCount.toInt()}",
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold)),
              ],
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildStressDayCircularGraphs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            SizedBox(height: 22), // Increased spacing for better readability
            _dualCircularIndicator(
                stressLevel, 10,
                dayRating, 10,
                "Stress Lvl.", "Day Rating",
                Colors.red, Colors.orange
            ),
            SizedBox(height: 22), // Increased spacing for better readability
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.self_improvement, color: Colors.red, size: 22), // Stress Icon
                SizedBox(width: 6),
                Text(
                  "Stress Lvl: ${stressLevel}",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 12),
                Icon(Icons.star, color: Colors.orange, size: 22), // Day Rating Icon
                SizedBox(width: 6),
                Text(
                  "Day Rating: ${dayRating}",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }


  Widget _dualCircularIndicator(
      double value1, double max1, double value2, double max2,
      String label1, String label2, Color color1, Color color2) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Circular Indicator
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 10.0,
          animation: true,
          percent: (value1 / max1).clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${value1}",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
              ),
              Text(
                "${value2}",
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w500),
              ),
            ],
          ),
          progressColor: color1,
          backgroundColor: Colors.grey.shade900,
          circularStrokeCap: CircularStrokeCap.round,
        ),

        // Inner Circular Indicator (Smaller Circle)
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          animation: true,
          percent: (value2 / max2).clamp(0.0, 1.0),
          progressColor: color2,
          backgroundColor: Colors.grey.shade900,
          circularStrokeCap: CircularStrokeCap.round,
        ),

        // Displaying the second value outside (below)
        Positioned(
          bottom: -22, // Moves text slightly down
          child: Row(
            children: [
              Icon(Icons.star, color: color2, size: 16),
              SizedBox(width: 5),
              Text(
                "${value2.toInt()} $label2",
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSleepWidget() {
    double sleepProgress = (sleepHours / goalSleepHours).clamp(0.0, 1.0);

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.nightlight_round, color: Colors.blue, size: 28),
                SizedBox(width: 10),
                Text(
                  "Sleep Tracker",
                  style: GoogleFonts.roboto(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Hours Slept: ${sleepHours.toStringAsFixed(1)} hrs",
              style: GoogleFonts.roboto(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Goal: ${goalSleepHours.toStringAsFixed(1)} hrs",
              style: GoogleFonts.roboto(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            //  Sleep Progress Bar (Fixed)
            Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,  // Makes it responsive
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.6 * sleepProgress, //  Dynamic width
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(sleepProgress * 100).toInt()}% completed",
                style: GoogleFonts.roboto(
                  color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildWaterIntake() {
    double waterProgress = (waterIntake / goalWaterIntake).clamp(0.0, 1.0);

    return Column(
      children: [
        Text("Water Intake",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w700),

        ),
        SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Bottle Shape (Outer Container)
            Container(
              width: 50,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
            // Water Level (Inner Container)
            Container(
              width: 50,
              height: 150 * waterProgress, // Adjust height based on intake
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text("${waterIntake.toStringAsFixed(1)} / ${goalWaterIntake.toStringAsFixed(1)} L",
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w700)
        ),
      ],
    );
  }

  Widget _buildWeightProgress() {
    double weightProgress = (weight / goalWeight).clamp(0.0, 1.0);

    return Card(
      color:Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.deepOrange, size: 28),
                SizedBox(width: 10),
                Text(
                  "Weight Progress",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Current Weight: $weight kg",
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w700),
            ),
            Text(
              "Goal: $goalWeight kg",
              style: GoogleFonts.roboto(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            // Weight Progress Bar
            Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 12,
                  width: 200 * weightProgress, // Adjust width dynamically
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(weightProgress * 100).toInt()}% achieved",
                style: GoogleFonts.roboto(color: Colors.deepOrangeAccent, fontSize: 12,fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor:Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
      ],
    );
  }
}
