import 'package:flutter/material.dart';
import 'package:inshort_app/presentation/pages/bookmark/book_mark_screen.dart';
import 'package:inshort_app/presentation/pages/home/home_screen.dart';
import 'package:inshort_app/presentation/pages/search/search_screen.dart';



class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    BookmarksScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Bookmarks',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.black,
    border: const Border(
      top: BorderSide(
        color: Colors.white12, // Light grey/white-ish border
        width: 1,               // You can adjust this
      ),
    ),
  ),
  child: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: _onTabTapped,
    items: _items,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.transparent, // Must be transparent
    elevation: 0,
  ),
),

    );
  }
}
