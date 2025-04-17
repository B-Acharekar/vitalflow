import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalflow/services/user_services.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController securityAnswerController = TextEditingController();

  String selectedQuestion = 'What is your pet’s name?';
  bool isLoading = false;

  final List<String> securityQuestions = [
    'What is your pet’s name?',
    'What is your mother’s maiden name?',
    'What is your favorite color?',
    'What is your birthplace?',
    'What was your childhood nickname?',
  ];

  void showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> signup() async {
    setState(() {
      isLoading = true;
    });

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String securityAnswer = securityAnswerController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || securityAnswer.isEmpty) {
      showSnackBar("All fields are required");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await UserService.registerUser(name, email, password, selectedQuestion, securityAnswer);
      showSnackBar("Signup Successful! Please log in.", color: Colors.green);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      showSnackBar("Signup Failed: $e");
      print("Signup Failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121D2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              _buildTextField(hintText: "Full Name", icon: Icons.person, controller: nameController),
              SizedBox(height: 10),

              _buildTextField(hintText: "Email", icon: Icons.email, controller: emailController),
              SizedBox(height: 10),

              _buildTextField(hintText: "Password", icon: Icons.lock, controller: passwordController, isPassword: true),
              SizedBox(height: 10),

              // Security Question Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF0A0F2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Color(0xFF0A0F2C),
                  value: selectedQuestion,
                  isExpanded: true,
                  underline: SizedBox(),
                  iconEnabledColor: Colors.blueAccent,
                  style: GoogleFonts.poppins(color: Colors.white),
                  items: securityQuestions.map((String question) {
                    return DropdownMenuItem<String>(
                      value: question,
                      child: Text(question),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuestion = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),

              // Security Answer
              _buildTextField(
                hintText: "Answer to Security Question",
                icon: Icons.security,
                controller: securityAnswerController,
              ),
              SizedBox(height: 20),

              // Signup Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : signup,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Sign Up", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),

              SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Already have an account? Log in", style: GoogleFonts.poppins(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.white54),
        filled: true,
        fillColor: Color(0xFF0A0F2C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
      ),
    );
  }
}
