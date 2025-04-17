import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121D2C),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24), // Added horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),

            // Enlarged Logo
            Image.asset(
              'assets/vitalflow_logo.png',
              height: 200,
            ),
            SizedBox(height: 25),

            // App Title
            Text(
              "Welcome to VitalFlow",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Centering the text
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              "Your all-in-one health tracker",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Ensuring it's centered
            ),
            SizedBox(height: 40),

            // Animated Button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: 220,
                height: 55,
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
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade900.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Motivational Tagline
            Text(
              "Stay fit, stay healthy",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
