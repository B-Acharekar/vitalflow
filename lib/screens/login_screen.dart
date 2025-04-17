import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/screens/ForgotPasswordScreen.dart';
import 'package:vitalflow/services/user_services.dart';
import 'package:vitalflow/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar("Please fill in both fields.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await UserService.loginUser(email, password);
      showSnackBar("Login Successful!", color: Colors.green);

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showSnackBar("Invalid email or password");
      print("Login Failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and width using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF121D2C),
      body: SingleChildScrollView(  // Added for scrollability
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24), // Consistent padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the top for better scrolling
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Use Flexible to allow for responsive spacing
              SizedBox(height: screenHeight * 0.1),  // Adjust height based on screen size

              // App Logo with dynamic height based on screen size
              Image.asset(
                'assets/vitalflow_logo.png',
                height: screenHeight * 0.2, // 20% of screen height
              ),
              SizedBox(height: 25),

              // Welcome Text
              Text(
                "Welcome Back",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.08, // 8% of screen width for responsiveness
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),

              // Subtitle
              Text(
                "Login to continue tracking your health",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045, // 4.5% of screen width for subtitle size
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Email Field
              _buildTextField(
                hintText: "Email",
                icon: Icons.email,
                controller: emailController,
              ),
              SizedBox(height: 15),

              // Password Field with Visibility Toggle
              _buildTextField(
                hintText: "Password",
                icon: Icons.lock,
                controller: passwordController,
                isPassword: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: 5),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()), // Replace with ForgotPasswordScreen() when ready
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25),

              // Login Button (Styled Like Get Started)
              GestureDetector(
                onTap: isLoading ? null : login,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: screenWidth * 0.6, // Button width relative to screen width
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
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Signup Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: GoogleFonts.poppins(
                    color: Colors.blueAccent,
                    fontSize: 16,
                  ),
                ),
              ),
              // Use Flexible at the end to make sure everything fits within screen size
              SizedBox(height: screenHeight * 0.1),  // Add flexible spacing
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.white54),
        filled: true,
        fillColor: Color(0xFF0A0F2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
