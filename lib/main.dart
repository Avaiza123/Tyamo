import 'package:flutter/material.dart';
import 'views/auth/login.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const Tyamo());
}

class Tyamo extends StatelessWidget {
  const Tyamo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tyamo Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}
