import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth/login.dart'; // Import the LoginPage
import 'RecipeDetailPage.dart';

class ExploreRecipesPage extends StatefulWidget {
  const ExploreRecipesPage({Key? key}) : super(key: key);

  @override
  _ExploreRecipesPageState createState() => _ExploreRecipesPageState();
}

class _ExploreRecipesPageState extends State<ExploreRecipesPage> {
  List<dynamic> recipes = [];
  List<dynamic> filteredRecipes = [];
  bool isLoading = true;
  bool isFetchingMore = false;  // To handle infinite scrolling
  int page = 1;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  // Function to fetch popular recipes from an API
  Future<void> fetchRecipes() async {
    final url = 'https://api.spoonacular.com/recipes/random?number=10&apiKey=dce8d048d70445279c7b81ff5a99708e'; // Replace with your API key
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recipes.addAll(data['recipes']);
          filteredRecipes = recipes;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  // Search function to filter recipes by name or ingredient
  void searchRecipes(String query) {
    final filtered = recipes.where((recipe) {
      final name = recipe['title'].toLowerCase();
      final ingredients = recipe['extendedIngredients']
          .map((ingredient) => ingredient['name'].toLowerCase())
          .join(' ');

      return name.contains(query.toLowerCase()) ||
          ingredients.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredRecipes = filtered;
    });
  }

  // Function to handle loading more recipes when scrolling
  void loadMoreRecipes() {
    if (!isFetchingMore) {
      setState(() {
        isFetchingMore = true;
      });
      page++;
      fetchRecipes();
      setState(() {
        isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8D6E63),  // Set background color to light brown
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Flavamo',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                // Navigate to the LoginPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // Navigate to LoginPage
                );
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: searchRecipes,
              onTap: () {
                // Clear the prewritten search text when tapped
                if (searchController.text == 'Search Recipes') {
                  searchController.clear();
                }
              },
              decoration: InputDecoration(

                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Loading Indicator
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (filteredRecipes.isEmpty)
              Center(child: Text('No recipes found')),
            // Recipe Cards with Infinite Scroll
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!isFetchingMore &&
                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    loadMoreRecipes();
                    return true;
                  }
                  return false;
                },
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];

                    // Dynamically adjust card height based on recipe name length
                    double cardHeight = (recipe['title'].length > 30) ? 100.0 : 150.0;

                    return GestureDetector(
                      onTap: () {
                        // Navigate to Recipe Detail Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: recipe), // Add your recipe detail page here
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            // Recipe Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                recipe['image'],
                                height: cardHeight * 0.6,  // Adjust image size dynamically
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Loading More Indicator
            if (isFetchingMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}