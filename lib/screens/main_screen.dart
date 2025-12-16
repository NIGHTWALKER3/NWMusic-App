import 'package:flutter/material.dart';
import 'genre_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    GenreScreen(),   // Home (for now)
    SearchScreen(),  // Search
    Center(child: Text("Library", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea( // 🔥 THIS IS THE KEY
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _screens[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: "Library",
            ),
          ],
        ),
      ),
    );
  }
}

