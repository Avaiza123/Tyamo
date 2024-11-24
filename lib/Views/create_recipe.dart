import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Repository/home_page_repo.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final TextEditingController _ingredientsController = TextEditingController();
  String _aiGeneratedRecipe = "";
  bool _isLoading = false;
  final HomePageRepo _repository = HomePageRepo();

  // Function to generate recipe using Spoonacular API
  Future<void> _generateRecipe() async {
    setState(() {
      _isLoading = true;
      _aiGeneratedRecipe = ""; // Clear previous recipe
    });

    try {
      final recipe = await _repository.generateRecipe(_ingredientsController.text);
      setState(() {
        _aiGeneratedRecipe = recipe; // Set the generated recipe
      });
    } catch (e) {
      setState(() {
        _aiGeneratedRecipe = "Error: $e"; // Handle error case
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop the loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(  // Make the body scrollable
        child: Container(
          width: double.infinity, // Ensure the container takes the full width
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/4.png"),
              fit: BoxFit.cover, // Ensures the image covers the screen without distortion
              alignment: Alignment.center, // Center the image for better coverage
            ),
          ),
          child: Column(
            children: [
              // Content Overlay with gradient for readability
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),  // For spacing below the app bar
                      Text(
                        "Create Your Recipe",
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xB3FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter ingredients to generate a custom recipe",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: const Color(0xB3FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // TextField widget for ingredients
                      TextField(
                        controller: _ingredientsController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter ingredients separated by commas",
                          hintStyle:
                          GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Generate Recipe Button
                      ElevatedButton(
                        onPressed: _isLoading || _ingredientsController.text.isEmpty
                            ? null
                            : _generateRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, // Brown background
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Generate Recipe",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Generated Recipe Text
                      _aiGeneratedRecipe.isNotEmpty
                          ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _aiGeneratedRecipe,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }
}
