import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth/login.dart';
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
  bool isFetchingMore = false;
  int page = 1;
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Desserts',
    'Breakfast',
    'Salads',
    'Vegan',
    'Chicken'
  ];

  final Map<String, String> categoryMapping = {
    'All': '',
    'Desserts': 'dessert',
    'Breakfast': 'breakfast',
    'Salads': 'salad',
    'Vegan': 'vegan',
    'Chicken': 'chicken',
  };

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    fetchFoodTriviaOrJokes();
  }

  Future<void> fetchRecipes({bool isLoadMore = false}) async {
    setState(() {
      if (isLoadMore) {
        isFetchingMore = true;
      } else {
        isLoading = true;
      }
    });

    final categoryTag = categoryMapping[selectedCategory] ?? '';
    final url =
        'https://api.spoonacular.com/recipes/random?number=10&tags=$categoryTag&apiKey=dce8d048d70445279c7b81ff5a99708e';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (isLoadMore) {
            recipes.addAll(data['recipes']);
          } else {
            recipes = data['recipes'];
          }
          filteredRecipes = recipes;
          isLoading = false;
          isFetchingMore = false;
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
      print(e.toString());
    }
  }

  Future<void> fetchFoodTriviaOrJokes() async {
    final jokeUrl =
        'https://api.spoonacular.com/food/jokes/random?apiKey=dce8d048d70445279c7b81ff5a99708e';
    final triviaUrl =
        'https://api.spoonacular.com/food/trivia/random?apiKey=dce8d048d70445279c7b81ff5a99708e';

    try {
      final jokeResponse = await http.get(Uri.parse(jokeUrl));
      final triviaResponse = await http.get(Uri.parse(triviaUrl));

      if (jokeResponse.statusCode == 200 && triviaResponse.statusCode == 200) {
        final jokeData = json.decode(jokeResponse.body);
        final triviaData = json.decode(triviaResponse.body);

        final randomContent = (DateTime.now().second % 2 == 0)
            ? jokeData['text']
            : triviaData['text'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 1),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Did You Know?',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          randomContent,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
      }
    } catch (e) {
      print('Error fetching trivia or jokes: $e');
    }
  }


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

  void loadMoreRecipes() {
    if (!isFetchingMore) {
      page += 1;
      fetchRecipes(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D4C41),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your image path
              height: 50, // Adjust the height of the image
              width: 50,  // Adjust the width of the image
            ),
            const SizedBox(width: 10), // Space between the image and the text
            Text(
              'Flavamo',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
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
            TextField(
              controller: searchController,
              onChanged: searchRecipes,
              decoration: InputDecoration(
                hintText: 'Search Recipes',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                          page = 1;
                          fetchRecipes();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == category
                            ? Colors.brown[300]
                            : Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredRecipes.isEmpty
                  ? const Center(child: Text('No recipes found'))
                  : NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!isFetchingMore &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    loadMoreRecipes();
                    return true;
                  }
                  return false;
                },
                child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                recipe['image'],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe['title'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                'Prep time: ${recipe['readyInMinutes']} min',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
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
            if (isFetchingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
