import 'package:flutter/material.dart';
import 'package:soundscape/views/addbeat_page.dart';
import 'package:soundscape/views/explore_page.dart';
import 'package:soundscape/views/favorite_page.dart';
import 'package:soundscape/views/home_page.dart';
import 'package:soundscape/views/settings_page.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  List<Widget> screens = const [
    HomePage(),
    ExplorePage(),
    AddBeatPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Explore',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Add Beat',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF121212),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
