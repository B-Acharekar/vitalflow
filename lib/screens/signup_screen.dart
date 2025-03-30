import 'package:flutter/material.dart';
import 'package:vitalflow/services/user_services.dart'; // Ensure correct import

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Track loading state

  void showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
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

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar("All fields are required");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var response = await UserService.registerUser(name, email, password);
      showSnackBar("Signup Successful! Please log in.", color: Colors.green);

      // Navigate back to Login Screen after 1 second
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () {
            Navigator.pop(context); // Go back to Login screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Name Field
              _buildTextField(
                hintText: "Full Name",
                icon: Icons.person,
                controller: nameController,
              ),
              SizedBox(height: 10),

              // Email Field
              _buildTextField(
                hintText: "Email",
                icon: Icons.email,
                controller: emailController,
              ),
              SizedBox(height: 10),

              // Password Field
              _buildTextField(
                hintText: "Password",
                icon: Icons.lock,
                controller: passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),

              // Signup Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : signup, // Disable while loading
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),

              SizedBox(height: 10),

              // Already have an account? Login
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Back to login screen
                },
                child: Text(
                  "Already have an account? Log in",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Input Field
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
      ),
    );
  }
}
