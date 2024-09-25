import 'package:app/home.dart';
import 'package:flutter/material.dart';


class BottomTab extends StatelessWidget {
  const BottomTab({Key? key, required int selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Resources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: 0, // Default index
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      },
    );
  }
}
