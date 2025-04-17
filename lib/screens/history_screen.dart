import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/screens/widgets/history/DayRatingCard.dart';
import 'package:vitalflow/screens/widgets/history/HeartRateCard.dart';
import 'package:vitalflow/screens/widgets/history/SleepCard.dart';
import 'package:vitalflow/screens/widgets/history/StepCard.dart';
import 'package:vitalflow/screens/widgets/history/StressCard.dart';
import 'package:vitalflow/screens/widgets/history/WaterIntakeCard.dart';
import 'package:vitalflow/screens/widgets/history/WeightCard.dart';
import '../utils/filter_utils.dart';
import '../utils/sleep_utils.dart';
import '../utils/water_intake_utils.dart';
import '../utils/health_service.dart';
import '../services/day_rating_service.dart';
import '../utils/heart_rate_utils.dart';
import '../utils/steps_utils.dart';
import '../utils/stress_utils.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;
  String _selectedRange = "today";
  double water = 0.0, sleep = 0.0, heartRate = 0.0, weight = 0.0, dayRating = 0.0;
  int steps = 0, stress = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<dynamic> waterRecords = await WaterIntakeUtils.fetchWater(timeRange: _selectedRange);
      List<dynamic> stepRecords = await StepsUtils.fetchStepCount(timeRange: _selectedRange);
      List<dynamic> heartRecords = await HeartRateUtils.fetchHeartRate(timeRange: _selectedRange);
      List<dynamic> sleepRecords = await SleepUtils.fetchSleep(timeRange: _selectedRange);
      Map<String, dynamic> healthData = await HealthService.getHealth();
      List<dynamic> healthRecords = healthData["health_log"] ?? [];
      List<dynamic> stressRecords = await StressUtils.fetchStress(timeRange: _selectedRange);
      Map<String, dynamic> dayRatingData = await DayRatingService.getDayRating(_selectedRange);

      setState(() {
        water = FilterUtils.calculateAvgTotal(waterRecords, _selectedRange, "water_intake_ml", "timestamp");
        steps = FilterUtils.calculateAvgTotal(stepRecords, _selectedRange, "steps_count", "timestamp").toInt();
        if (_selectedRange == "today"){
          heartRate = double.tryParse(heartRecords.last["heart_rate_bpm"].toString()) ?? 0.0;
        } else{
          heartRate = FilterUtils.calculateAvgTotal(heartRecords, _selectedRange, "heart_rate_bpm", "date");
        }
        sleep = FilterUtils.calculateAvgTotal(sleepRecords, _selectedRange, "sleep_duration_min", "timestamp")/60;
        weight = healthRecords.isNotEmpty ? double.tryParse(healthRecords.last["weight"].toString()) ?? 0.0 : 0.0;
        stress = FilterUtils.calculateAvgTotal(stressRecords, _selectedRange, "stress_level", "timestamp").toInt();
        if (stress == 0) {
          stress = 70;
        }
        dayRating = double.tryParse(dayRatingData["day_rating"].toString()) ?? 5.0;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _updateRange(String range) {
    setState(() => _selectedRange = range);
    _fetchData();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate to the corresponding page
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
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
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
          'Vital History',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab("Today", "today"),
                _buildTab("Week", "week"),
                _buildTab("Month", "month"),
              ],
            ),
          ),
        ),
      ),


      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                StepsCard(steps: steps),
                HeartRateCard(heartRate: heartRate),
                SleepCard(sleepHours: sleep),
                WaterIntakeCard(water: water.toInt()),
                StressCard(stress: stress.toDouble()),
                DayRatingCard(dayRating: dayRating),
                WeightCard(weight: weight),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
          _fetchData();
        },
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

  Widget _buildTab(String title, String range) {
    final isSelected = _selectedRange == range;
    return GestureDetector(
      onTap: () => _updateRange(range),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blueAccent : Colors.white,
          ),
        ),
      ),
    );
  }
}