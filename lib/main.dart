import 'package:flutter/material.dart';

import 'Views/Auth/login.dart';

void main() {
  runApp(const Tyamo());
}

class Tyamo extends StatelessWidget {
  const Tyamo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tyamo',
      home: Login(),
    );
  }
}

