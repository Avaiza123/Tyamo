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
      final recipe =
      await _repository.generateRecipe(_ingredientsController.text);
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
  void initState() {
    super.initState();
    // Add a listener to update the state when the text field changes
    _ingredientsController.addListener(() {
      setState(() {}); // Trigger rebuild to update button state
    });
  }

  @override
  void dispose() {
    _ingredientsController.dispose(); // Dispose the controller to free resources
    super.dispose();
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/4.png"),
            fit: BoxFit.cover, // Cover the screen without distortion
          ),
        ),
        child: Container(
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
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  // TextField for ingredients input
                  TextField(
                    controller: _ingredientsController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter ingredients separated by commas",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Generate Recipe Button
                  ElevatedButton(
                    onPressed: (_isLoading ||
                        _ingredientsController.text.trim().isEmpty)
                        ? null // Disable the button when loading or text is empty
                        : _generateRecipe, // Call the function when enabled
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading ||
                          _ingredientsController.text.trim().isEmpty
                          ? Colors.brown.shade200 // Lighter shade for disabled
                          : Colors.brown, // Regular brown color
                      disabledBackgroundColor:
                      Colors.brown.shade200, // Lighter shade for disabled
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) // Show loader when loading
                        : Text(
                      "Generate Recipe",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Display the generated recipe
                  _aiGeneratedRecipe.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _aiGeneratedRecipe,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : (_isLoading
                      ? Container() // No extra space while loading
                      : Container(
                    height: 200, // Prevent the white half-screen issue
                    alignment: Alignment.center,
                    child: Text(
                      "No recipe generated yet. Please enter ingredients and press 'Generate Recipe'.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}