import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import to format date


import 'package:vitalflow/screens/widgets/graph/SleepGraph.dart';
import 'package:vitalflow/screens/widgets/graph/WaterAndStressDayGraph.dart';
import 'package:vitalflow/screens/widgets/graph/WeightProgress.dart';
import 'package:vitalflow/screens/widgets/graph/heart_step_graph.dart';


// Service
import '../services/steps_service.dart';
import '../services/day_rating_service.dart';
import '../services/heart_rate_service.dart';
// Utils
import '../services/user_services.dart';
import '../utils/filter_utils.dart';
import '../utils/heart_rate_utils.dart';
import '../utils/steps_utils.dart';
import '../utils/stress_utils.dart';
import '../utils/health_manager.dart';
import '../utils/health_service.dart';
import '../utils/sleep_utils.dart';
import '../utils/water_intake_utils.dart';

import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Home is index 0

  // final List<Widget> _screens = [
  //   HomeScreenContent(), // Extracted actual Home content
  //   // HistoryScreen(),
  //   Center(child: Text("More Section")), // Placeholder for More tab
  // ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/history');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/browse');
      }
    }
  }

  final HealthManager healthManager = HealthManager();
  String? username;
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
  int previousSteps = 0;
  double previousHr = 0.0;
  String formattedDate = DateFormat("MMMM d").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    initializeApp();
    loadUsername();
  }

  void initializeApp() async {
    await loadPreviousValues();
    fetchData();// then fetch
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) => fetchData());
  }

void loadUsername() async {
  // Optional: Refresh username from backend
  await UserService.fetchAndStoreUsername(); // 🔄 Refreshes name from server

  // Get the name from local storage
  String? name = await UserService.getUsername();

  setState(() {
    username = name ?? "Guest"; // Set to a default if null
  });
}

  Future<void>  loadPreviousValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      previousSteps = prefs.getInt('previousSteps') ?? 0;
      previousHr = prefs.getDouble('previousHr') ?? 0.0;
    });
  }

  Future<void>  savePreviousValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('previousSteps', previousSteps);
    await prefs.setDouble('previousHr', previousHr);
  }


  void fetchData() async {
    setState(() => isLoading = true);
    try {
      int steps = await healthManager.fetchStepCount();
      print("Steps log: $steps");
      print("previous step: $previousSteps");

      double bpm = await healthManager.fetchHeartRate();
      print("Heart Rate: $bpm");

      double kg = await healthManager.fetchWeight();
      print("Weight: $kg");
      await savePreviousValues(); // ✅ ADD THIS

      if (steps != 0 || bpm != 0 || kg != 0) {
        try {
          if(steps != previousSteps && steps!=0){
            int acutalStep = steps - previousSteps;
            if(acutalStep > 0){
              print("acutalStep: $acutalStep");
              await StepService.logSteps((acutalStep).toDouble(), stepsGoal: 10000);
              previousSteps = steps;
            }
          }
          if(bpm!= previousHr && bpm!=0){
            double actualHr = bpm - previousHr;
            await HeartRateService.logHeartRate(actualHr);
            previousHr = bpm;
          }
          if(kg != 0){
            await HealthService.logHealth(kg, 170); // Assuming 170 cm as height
          }
        } catch (e) {
          print("Error Logging data: $e");
        }
      } else {
        print("One or more health values are 0, skipping logging.");
      }
    } catch (e) {
      print("Error fetching health data: $e");
    } finally {
      setState(() => isLoading = false); // Always stop loading spinner
    }


    try {
      //  Fetch Water Intake Data
      List<dynamic> waterRecords = await WaterIntakeUtils.fetchWater(
          timeRange: "today");
      double totalWater = 0.0;
      for (var record in waterRecords) {
        double intake = double.tryParse(record["water_intake_ml"].toString()) ??
            0.0;
        totalWater += intake / 1000.0; // Convert ml to L
      }
      // print("totalwater:$totalWater");
      //  Fetch Step Count Data
      List<dynamic> stepRecords = await StepsUtils.fetchStepCount(timeRange: "today");

      double totalSteps = 0.0;
      double stepsGoal = goalStepCount.toDouble();
      for (var record in stepRecords) {
        totalSteps += double.tryParse(record["steps_count"].toString()) ?? 0.0;
        if (record.containsKey("steps_goal")) {
          stepsGoal = double.tryParse(record["steps_goal"].toString()) ?? goalStepCount.toDouble();
        }
      }

      // Fetch Heart Rate Data
      List<dynamic> heartRecords = await HeartRateUtils.fetchHeartRate(timeRange: "today");

      double lastHeartRate = 0.0;
      if (heartRecords.isNotEmpty) {
        lastHeartRate = double.tryParse(heartRecords.last["heart_rate_bpm"].toString()) ?? 0.0;
      }

      //  Fetch Sleep Data
      List<dynamic> sleepRecords = await SleepUtils.fetchSleep(timeRange: "today");

      double totalSleep = 0.0;
      double sleepGoal = goalSleepHours; // Default goal

      if (sleepRecords.isNotEmpty) {
        var lastRecord = sleepRecords.last;

        // Convert minutes to hours
        totalSleep = double.parse((FilterUtils.calculateTotal(sleepRecords, "today", "sleep_duration_min", "timestamp") / 60).toStringAsFixed(1));

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
      List<dynamic> stressRecords = await StressUtils.fetchStress(timeRange: "today");

      int lastStressLevel = 50;
      if (stressRecords.isNotEmpty) {
        lastStressLevel = int.tryParse(stressRecords.last["stress_level"].toString()) ?? 50;
      }

      // print(" Stress Level (): ${lastStressLevel/10}");

      //fetch day rating
      Map<String, dynamic> dayRatingData = await DayRatingService.getDayRating("today");

      // print(" Raw Day Rating Response: $dayRatingData");  // Debugging step

      double lastDayRating = 0.0;  // Default rating

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
        dayRating = lastDayRating/10.0;
        dayRating = double.parse(dayRating.toStringAsFixed(1));
        isLoading = false;
      });
    } catch (e) {
      Future.error("Error fetching data: $e");
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
      backgroundColor: Color(0xFF121D2C),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40), // kToolbarHeight = 56, so total = 96
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D47A1), // Dark indigo blue
                  Color(0xFF1976D2), // Primary blue
                  Color(0xFF42A5F5), // Lighter electric blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          title: Container(
            height: kToolbarHeight + 40, // Total height = 96
            padding: const EdgeInsets.only(left: 32.0),
            alignment: Alignment.centerLeft, // Align content vertically center & left
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $username',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            HeartStepGraph(
              heartRate: heartRate,
              stepCount: stepCount.toDouble(),
              goalStepCount: goalStepCount.toDouble(),
            ),
            SizedBox(height: 25),
            SleepTrackerWidget(sleepHours: sleepHours, goalSleepHours: goalSleepHours),
            SizedBox(height: 25),
            WaterAndStressDayGraph(waterIntake: waterIntake,goalWaterIntake: goalWaterIntake,stressLevel: stressLevel,dayRating: dayRating),
            SizedBox(height: 25),
            WeightProgressWidget(weight: weight, goalWeight: goalWeight),
            SizedBox(height:25),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.symmetric(vertical: 10),
          // icon breathing space
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A0F2C), // Deep navy blue (almost black)
                Color(0xFF1B2B4B), // Dark muted blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),            borderRadius: BorderRadius.circular(40), // more rounded
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(icon: Icons.home, index: 0),
              _buildNavItem(icon: Icons.history, index: 1),
              _buildNavItem(icon: Icons.more_horiz, index: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Dark indigo blue
              Color(0xFF1976D2), // Primary blue
              Color(0xFF42A5F5), // Lighter electric blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Content"));
  }
}