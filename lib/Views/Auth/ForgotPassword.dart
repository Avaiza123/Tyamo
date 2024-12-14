import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/views/home_screen.dart'; // Import the Home screen

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false; // To manage the loading state

  // Function to handle Reset Password button press
  void _onResetPasswordPress() {
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
            content: const Text("A password reset link has been sent to your email!"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to login screen
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
      // No AppBar in Scaffold to ensure the transparent one is used
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/recipe-background1.jpg"), // Replace with your background image path
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
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // Transparent AppBar as part of Stack
                SafeArea(
                  child: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Image on the left
                        Container(
                          width: 50, // Adjust the width as necessary
                          height: 50, // Adjust the height as necessary
                          child: Image.asset("assets/logo.png"), // Replace with your logo path
                        ),
                        const SizedBox(width: 10), // Space between logo and text
                        Text(
                          "Flavamo",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 25, color: const Color(0xB3FFFFFF)),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent, // Transparent AppBar
                    elevation: 0, // Remove shadow
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.home,
                            size: 34,
                            color: Colors.white),
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
                // Forgot Password content
                Column(
                  children: [
                    const SizedBox(height: 38),
                    Row(
                      children: [

                        Text(
                          "  Forgot Password ",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: const Color(0xB3FFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height:40),
                // Email TextField for Forgot Password
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
                const SizedBox(height: 30),
                // Reset Password Button
                ElevatedButton(
                  onPressed: _onResetPasswordPress,
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
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
