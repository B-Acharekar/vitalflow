import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/screens/widgets/journal/BodyMeasurementWidget.dart';
import 'package:vitalflow/screens/widgets/journal/HydrationWidget.dart';
import 'package:vitalflow/screens/widgets/journal/MentalHealthWidget.dart';
import 'package:vitalflow/screens/widgets/journal/SleepWidget.dart';
import 'package:vitalflow/screens/widgets/journal/VitalsWidget.dart';
import 'package:vitalflow/screens/widgets/journal/activity_widget.dart';
import 'package:vitalflow/services/day_rating_service.dart';
import 'package:vitalflow/services/stress_service.dart';
import 'package:vitalflow/services/water_intake_service.dart';
import 'package:vitalflow/utils/stress_utils.dart';
import '../utils/filter_utils.dart';
import '../utils/health_service.dart';
import '../utils/heart_rate_utils.dart';
import '../utils/sleep_utils.dart';
import '../utils/steps_utils.dart';
import '../utils/water_intake_utils.dart';

class BrowseScreen extends StatefulWidget {
  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  int _selectedIndex = 2;
  bool isLoading = true;
  int stepCount = 0;
  int goalStepCount = 10000;
  double heartRate = 0.0;
  double sleepHours = 6.0;
  double goalSleepHours = 7.5;
  String sleepQuality = "";
  double waterIntake = 3.0;
  double goalWaterIntake = 3.7;
  double stressLevel = 0.0;
  double dayRating = 7.0;
  double weight = 56.0;
  double goalWeight = 75.0;
  double height = 175.0;
  Map<String, bool> expandedSections = {};
  Map<String, TextEditingController> controllers = {};
  Map<String, TextEditingController> noteControllers = {};
  late Future<void> _initalLoadFuture;

  @override
  void initState() {
    super.initState();
    _initalLoadFuture = fetchData();
    fetchData();
    controllers = {
      "Steps": TextEditingController(),
      "Height": TextEditingController(),
      "Weight": TextEditingController(),
      "Water Intake": TextEditingController(),
      "Heart Rate": TextEditingController(),
      "Sleep Duration": TextEditingController(),
      "Stress Level": TextEditingController(),
      "Day Rating": TextEditingController(),
    };
    noteControllers = {
      "Day Rating": TextEditingController(),
      "Stress Level": TextEditingController(),
      "Water Intake": TextEditingController(),
    };
  }


  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/history');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/browse');
          break;
      }
    }
  }

  Future<void> fetchData() async {
    try {
      List<dynamic> waterRecords = await WaterIntakeUtils.fetchWater(
          timeRange: "today");
      double totalWater = 0.0;
      for (var record in waterRecords) {
        double intake = double.tryParse(record["water_intake_ml"].toString()) ??
            0.0;
        totalWater += intake / 1000.0; // Convert ml to L
      }

      List<dynamic> stepRecords = await StepsUtils.fetchStepCount(
          timeRange: "today");
      double totalSteps = 0.0;
      double stepsGoal = goalStepCount.toDouble();
      for (var record in stepRecords) {
        totalSteps += double.tryParse(record["steps_count"].toString()) ?? 0.0;
        if (record.containsKey("steps_goal")) {
          stepsGoal = double.tryParse(record["steps_goal"].toString()) ??
              goalStepCount.toDouble();
        }
      }

      List<dynamic> heartRecords = await HeartRateUtils.fetchHeartRate(
          timeRange: "today");
      double lastHeartRate = 0.0;
      if (heartRecords.isNotEmpty) {
        lastHeartRate =
            double.tryParse(heartRecords.last["heart_rate_bpm"].toString()) ??
                0.0;
      }

      List<dynamic> sleepRecords = await SleepUtils.fetchSleep(
          timeRange: "today");
      double totalSleep = 0.0;
      double sleepGoal = goalSleepHours; // Default goal
      if (sleepRecords.isNotEmpty) {
        var lastRecord = sleepRecords.last;
        totalSleep = double.parse((FilterUtils.calculateTotal(sleepRecords, "today", "sleep_duration_min", "timestamp") / 60).toStringAsFixed(1));
        sleepGoal = (lastRecord["sleep_goal"] is num)
            ? (lastRecord["sleep_goal"] / 60.0)
            : (double.tryParse(lastRecord["sleep_goal"].toString()) ?? 450.0) /
            60.0;
      }
      if (6.0 <= totalSleep && totalSleep <= sleepGoal) {
        sleepQuality = "Good";
      } else {
        sleepQuality = "Bad";
      }
      Map<String, dynamic> healthData = await HealthService.getHealth();
      List<dynamic> healthRecords = healthData["health_log"] ?? [];

      double lastWeight = 0.0;
      double lastHeight = 0.0;
      if (healthRecords.isNotEmpty) {
        lastWeight =
            double.tryParse(healthRecords.last["weight"].toString()) ?? 0.0;
        lastHeight =
            double.tryParse(healthRecords.last["height"].toString()) ?? 0.0;
      }

      List<dynamic> stressRecords = await StressUtils.fetchStress(
          timeRange: "today");
      double lastStressLevel = stressRecords.isNotEmpty ? (int.tryParse(
          stressRecords.last["stress_level"].toString()) ?? 50) / 10.0 : 6.0;

      Map<String, dynamic> dayRatingData = await DayRatingService.getDayRating(
          "today");
      double lastDayRating = double.tryParse(dayRatingData["day_rating"].toString())! / 10 ;

      setState(() {
        stepCount = totalSteps.toInt();
        goalStepCount = stepsGoal.toInt();
        heartRate = lastHeartRate;
        waterIntake = totalWater;
        sleepHours = totalSleep;
        print("Sleep: $sleepHours");
        goalSleepHours = sleepGoal;
        weight = lastWeight;
        height = lastHeight;
        stressLevel = lastStressLevel;
        dayRating = lastDayRating;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  void _handleStepCountChanged(int newStepCount) {
    setState(() {
      stepCount = newStepCount;
      StepsUtils.logUserSteps(stepCount.toDouble(), goal: goalStepCount.toDouble());
      fetchData();
    });
    // Optional: Logging, database save, toast, etc.
    print("User logged $stepCount steps");
  }

  void _handleHeartRateChanged(double newHR) {
    setState(() {
      heartRate = newHR;
      HeartRateUtils.logUserHeartRate(heartRate);
      fetchData();
    });
    print("Heart Rate updated: $heartRate BPM");
  }

  void _handleHeightChanged(double newHeight) {
    setState(() {
      height = newHeight;
      HealthService.logHealth(weight, height);
      fetchData();
    });
    print("Height updated: $height cm");
  }

  void _handleWeightChanged(double newWeight) {
    setState(() {
      weight = newWeight;
      HealthService.logHealth(weight, height);
      fetchData();
    });
    print("Weight updated: $weight kg");
  }

  void _handleSleepHoursChanged(double newSleepHours) {
    setState(() {
      // print(newSleepHours);
      double previousSleepHr = sleepHours;
      sleepHours = newSleepHours + previousSleepHr;
      double sleepDuration = newSleepHours * 60 ;
      print(sleepDuration.toInt());
      SleepUtils.logUserSleep(sleepDuration.toInt());
      fetchData();
    });
    print("Updated sleep duration: $sleepHours hrs");
  }

  void _handleGoalSleepHoursChanged(double newGoalSleepHours) {
    setState(() {
      goalSleepHours = newGoalSleepHours;
      fetchData();
    });
    print("Updated sleep goal: $goalSleepHours hrs");
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleHydrationNoteSubmitted(String note) async {
    try {
      await WaterIntakeService.logAnylzWaterIntake(note);
      _showSnack("Water logged successfully: $note");
      fetchData();
    } catch (e) {
      _showSnack("Something went wrong: $e");
    }
  }

  void _handleLogStress(String note, double? value) async {
    try {
      await StressService.logAnlyzStress(note);
      _showSnack("Stress logged successfully");
      // update state if needed
      fetchData();
    } catch (e) {
      _showSnack("Failed to log stress");
    }
  }

  void _handleLogDayScore(String note, double? value) async {
    try {
      await DayRatingService.logAnlyzDayRating(note);
      _showSnack("Day Score logged successfully");
      // update state if needed
      fetchData();
    } catch (e) {
      _showSnack("Failed to log day score");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121D2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
        title: Text(
          'Wellness Journal',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      ),

      body:
      isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActivityWidget(stepCount: stepCount,
              goalSteps: goalStepCount,
              onStepCountChanged: _handleStepCountChanged,),
            SizedBox(height: 10),
            VitalsWidget(heartRate: heartRate,
              onHeartRateChanged: _handleHeartRateChanged,),
            SizedBox(height: 10),
            BodyMeasurementWidget(height: height,
              weight: weight,
              onHeightChanged: _handleHeightChanged,
              onWeightChanged: _handleWeightChanged,),
            SizedBox(height: 10),
            SleepWidget(sleepHours: sleepHours,
              goalSleepHours: goalSleepHours,
              onSleepHoursChanged: _handleSleepHoursChanged,
              onGoalSleepHoursChanged: _handleGoalSleepHoursChanged,),
            SizedBox(height: 10),
            HydrationWidget(
              waterIntake: waterIntake,
              onNoteSubmitted: _handleHydrationNoteSubmitted,),
            SizedBox(height: 10),
            MentalHealthWidget(
              stressLevel: stressLevel,
              dayScore: dayRating,
              onLogStress: _handleLogStress,
              onLogDayScore: _handleLogDayScore,),

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