import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageRepo {
  static const String _apiKey = 'dce8d048d70445279c7b81ff5a99708e'; // Replace with your Spoonacular API key
  static const String _baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  static const String _recipeDetailsUrl = 'https://api.spoonacular.com/recipes';

  // Function to generate recipe using Spoonacular API from given ingredients
  Future<String> generateRecipe(String ingredients) async {
    final String encodedIngredients = Uri.encodeComponent(ingredients);
    final Uri url = Uri.parse('$_baseUrl?query=$encodedIngredients&apiKey=$_apiKey');

    try {
      final response = await http.get(url);

      // Check if the API request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'results' is not null and contains at least one item
        if (data['results'] != null && data['results'].isNotEmpty) {
          String recipeTitle = data['results'][0]['title'] ?? 'No title available';
          String recipeUrl = data['results'][0]['sourceUrl'] ?? 'No URL available';
          int recipeId = data['results'][0]['id']; // Get the recipe ID for details call

          // Get additional details for the recipe
          String detailedRecipe = await _getRecipeDetails(recipeId);

          // Return the recipe title, URL, ingredients and detailed recipe information
          return 'Recipe: $recipeTitle\n\nIngredients:\n$ingredients\n\nDetailed Recipe:\n$detailedRecipe\n';
        } else {
          return 'No recipes found with the given ingredients.';
        }
      } else {
        return 'Error: Unable to fetch data from the API. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Fetch additional details for the recipe using the recipe ID
  Future<String> _getRecipeDetails(int recipeId) async {
    final Uri url = Uri.parse('$_recipeDetailsUrl/$recipeId/information?apiKey=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract detailed instructions and ingredients (only from the detailed recipe)
        String recipeInstructions = data['instructions'] ?? 'No instructions available.';
        List ingredients = data['extendedIngredients'] ?? [];
        String ingredientsList = ingredients.isNotEmpty
            ? ingredients.map((ingredient) => ingredient['original']).join('\n')
            : 'No ingredients available.';

        // Combine the instructions and ingredients into a final string
        return ' \n$recipeInstructions\n\nIngredients: \n$ingredientsList';
      } else {
        return 'Error: Unable to fetch recipe details.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
