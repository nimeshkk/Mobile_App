import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomTab extends StatefulWidget {
  final int initialIndex;
  
  const BottomTab({
    super.key,
    this.initialIndex = 0,
  });

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
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
          break;
        case 1:
          Navigator.pushNamed(context, '/report');
          break;
        case 2:
          Navigator.pushNamed(context, '/approved-reports');
          break;
        case 3:
          _showProfileMenu();
          break;
      }
    }
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/welcome',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
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
          icon: Icon(Icons.list),
          label: 'Reports',
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