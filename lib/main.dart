import 'package:flutter/material.dart';

import 'Screens/home_screen.dart';

void main() {
  runApp(const BasraGameApp());
}

class BasraGameApp extends StatelessWidget {
  const BasraGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basra Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
