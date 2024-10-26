import 'package:app/home.dart';
import 'package:app/report_disaster.dart';
import 'package:flutter/material.dart';


class BottomTab extends StatefulWidget {
  final int initialIndex;
  
  const BottomTab({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      
      // Navigation logic based on selected index
      switch (index) {
        case 0:
          if (!(context.widget is MyHomePage)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
          break;
        case 1:
          if (!(context.widget is Report_disater)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Report_disater()),
            );
          }
          break;
        case 2:
          // Profile page navigation would go here
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning_rounded),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: const Color(0xFF2C3E50),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
}