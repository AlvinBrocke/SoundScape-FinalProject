import 'package:flutter/material.dart';
import '../views/addbeat_page.dart';
import '../views/explore_page.dart';
import '../views/favorite_page.dart';
import '../views/home_page.dart';
import '../views/settings_page.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;
  const NavBar({super.key, required this.currentIndex});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  void _navigateToPage(BuildContext context, Widget page, int index) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    ).then((_) {
      setState(() {
        selectedIndex = index;
      });
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _navigateToPage(context, const HomePage(), index);
        break;
      case 1:
        _navigateToPage(context, const ExplorePage(), index);
        break;
      case 2:
        _navigateToPage(context, const AddBeatPage(), index);
        break;
      case 3:
        _navigateToPage(context, const FavoritePage(), index);
        break;
      case 4:
        _navigateToPage(context, const SettingsPage(), index);
        break;
      default:
        _navigateToPage(context, const HomePage(), index);
    }
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 2:
        return Icons.add;
      case 3:
        return Icons.favorite_border;
      case 4:
        return Icons.settings_outlined;
      default:
        return Icons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 42, 25, 39),
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _getIcon(0),
                color: selectedIndex == 0 ? Colors.purple : Colors.white,
                size: 30,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                _getIcon(1),
                color: selectedIndex == 1 ? Colors.purple : Colors.white,
                size: 30,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            FloatingActionButton(
              backgroundColor: Colors.purple,
              child: Icon(
                _getIcon(2),
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                _getIcon(3),
                color: selectedIndex == 3 ? Colors.purple : Colors.white,
                size: 30,
              ),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(
                _getIcon(4),
                color: selectedIndex == 4 ? Colors.purple : Colors.white,
                size: 30,
              ),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
