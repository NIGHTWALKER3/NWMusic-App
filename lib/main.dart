import 'package:flutter/material.dart';
import 'screens/genre_screen.dart';

void main() {
  runApp(const MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenreScreen(),
    );
  }
}

