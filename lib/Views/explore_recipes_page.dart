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
      backgroundColor: Color(0xFF6D4C41),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
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
                  ? Center(child: CircularProgressIndicator())
                  : filteredRecipes.isEmpty
                  ? Center(child: Text('No recipes found'))
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
                  physics: BouncingScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    double cardHeight =
                    (recipe['title'].length > 30) ? 100.0 : 150.0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                                recipe: recipe),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                recipe['image'],
                                height: cardHeight * 0.6,
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
