import 'package:app/components/BottomTab.dart';
import 'package:app/ReportForm.dart';
import 'package:flutter/material.dart';

class Report_disater extends StatefulWidget {
  const Report_disater({super.key});

  @override
  State<Report_disater> createState() => _Report_disaterState();
}

class _Report_disaterState extends State<Report_disater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        title: const Text('Report a Disaster'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                buildCard(
                  context: context,
                  title: 'Fire',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.local_fire_department,
                  iconColor: const Color(0xFFE74C3C),
                  disasterType: 'Fire',
                ),
                buildCard(
                  context: context,
                  title: 'Flood',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.water_damage,
                  iconColor: const Color(0xFF3498DB),
                  disasterType: 'Flood',
                ),
                buildCard(
                  context: context,
                  title: 'Earthquake',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.cyclone,
                  iconColor: const Color(0xFF8B4513),
                  disasterType: 'Earthquake',
                ),
                buildCard(
                  context: context,
                  title: 'Landslide',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.landscape,
                  iconColor: const Color(0xFF795548),
                  disasterType: 'Landslide',
                ),
                buildCard(
                  context: context,
                  title: 'Other',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning,
                  iconColor: const Color(0xFFFF9800),
                  disasterType: 'Other',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomTab(initialIndex: 1),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required Color cardColor,
    required IconData icon,
    required Color iconColor,
    required String disasterType,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportForm(disasterType: disasterType),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 60,
              color: iconColor,
            ),
            const SizedBox(height: 20.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}