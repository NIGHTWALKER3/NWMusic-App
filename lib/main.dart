import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // 🔥 black theme like Spotify
      home: const MainScreen(), // 🔥 Home / Search / Library
    );
  }
}
