import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tyamo/Views/home_screen.dart';
import 'login.dart'; // Import the Login page

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isLoading = false; // To manage the loading state

  // Function to handle signup button press
  void _onSignupPress() {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    // Simulating a network request with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Hide loading spinner after 2 seconds
      });

      // Display a popup after the operation is complete
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Your account has been created successfully!"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Image and overlay
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/recipe-background1.jpg"), // Update with your image path
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Content Overlay to darken the background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Transparent AppBar as part of Stack
                SafeArea(
                  child: AppBar(
                    title: Text(
                      "Flavamo",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 30, color: const Color(0xB3FFFFFF)),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent, // Transparent AppBar
                    elevation: 0, // Remove shadow
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.home,
                          size: 34,
                          color: Colors.white,),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Form content goes here
                Column(
                  children: [
                    const SizedBox(height:20),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset("assets/logo.png"), // Logo
                        ),
                        Text(
                          " Sign up ",
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            color: const Color(0xB3FFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 20),
                // Email TextField
                TextField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.alternate_email_sharp,
                      size: 18,
                    ),
                    prefixIconColor: const Color(0xff00205c),
                    label: Text(
                      "Email",
                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Password TextField
                TextField(
                  textAlign: TextAlign.start,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.password_sharp,
                      size: 18,
                    ),
                    prefixIconColor: const Color(0xff00205c),
                    label: Text(
                      "Password",
                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Button
                ElevatedButton(
                  onPressed: _onSignupPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Match the HomeScreen button color
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Sign Up",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xB3FFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
