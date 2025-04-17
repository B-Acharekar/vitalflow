import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/user_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<String> securityQuestions = [
    'What is your pet’s name?',
    'What is your mother’s maiden name?',
    'What is your favorite color?',
    'What is your birthplace?',
    'What was your childhood nickname?',
  ];

  late String selectedQuestion;

  @override
  void initState() {
    super.initState();
    selectedQuestion = securityQuestions[0]; // Always matches list item
  }

  bool isLoading = false;

  void showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    String answer = answerController.text.trim();
    String newPassword = passwordController.text;

    if (email.isEmpty || answer.isEmpty || newPassword.isEmpty) {
      showSnackBar("Please fill all fields.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await UserService.forgotPassword(email, answer, newPassword);
      if (response['status'] == 'success') {
        showSnackBar("Password reset successfully!", color: Colors.green);
        Navigator.pop(context);
      } else {
        showSnackBar(response['message'] ?? "Reset failed.");
      }
    } catch (e) {
      showSnackBar("Error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121D2C),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                "Reset Password",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Answer your security question to reset your password.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Email Field
              TextField(
                controller: emailController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF0A0F2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 20),

              // Dropdown for Security Question
              DropdownButtonFormField<String>(
                value: selectedQuestion,
                onChanged: (value) => setState(() => selectedQuestion = value!),
                dropdownColor: Color(0xFF0A0F2C),
                iconEnabledColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF0A0F2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: securityQuestions.map((question) {
                  return DropdownMenuItem(
                    value: question,
                    child: Text(question, style: GoogleFonts.poppins(color: Colors.white)),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Answer Field
              TextField(
                controller: answerController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Answer",
                  hintStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF0A0F2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock_open, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 20),

              // New Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "New Password",
                  hintStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF0A0F2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 30),

              // Reset Button
              GestureDetector(
                onTap: isLoading ? null : resetPassword,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
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
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Back to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back to Login",
                  style: GoogleFonts.poppins(
                    color: Colors.blueAccent,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
