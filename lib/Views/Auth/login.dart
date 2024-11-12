import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart'; // Import the Signup page
import '/views/home_screen.dart'; // Import the Home screen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false; // To manage the loading state

  // Function to handle login button press
  void _onLoginPress() {
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
            content: const Text("You are logged in successfully!"),
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
                  Colors.black.withOpacity(0.7),
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
                    title: Text(
                      "Flavamo",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,fontSize: 30, color: const Color(0xB3FFFFFF)),
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
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          child: Image.asset("assets/logo.png"),
                        ),
                        Text(
                          "  Login ",
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
                const SizedBox(height: 20),
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
                // Login Button
                ElevatedButton(
                  onPressed: _onLoginPress,
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
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
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
                          MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
