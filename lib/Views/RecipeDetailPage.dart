import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailPage extends StatelessWidget {
  final dynamic recipe;
  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe['title'],
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                recipe['image'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Recipe Title
            Center(
              child: Text(
                recipe['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Recipe Summary
            if (recipe['summary'] != null)
              Text(
                'Summary: ${recipe['summary']?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')}',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            const SizedBox(height: 20),

            // Ingredients Section
            Text(
              'Ingredients',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...recipe['extendedIngredients'].map<Widget>((ingredient) {
              return Text(
                '- ${ingredient['original']}',
                style: GoogleFonts.poppins(fontSize: 16),
              );
            }).toList(),
            const SizedBox(height: 20),

            // Instructions Section
            Text(
              'Instructions',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              recipe['instructions'] ?? 'No instructions available.',
              style: GoogleFonts.poppins(fontSize: 16),textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // Additional Info (optional)
            if (recipe['readyInMinutes'] != null)
              Text(
                'Ready in: ${recipe['readyInMinutes']} minutes',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (recipe['servings'] != null)
              Text(
                'Servings: ${recipe['servings']}',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
