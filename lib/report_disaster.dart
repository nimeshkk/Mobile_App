import 'package:app/components/BottomTab.dart';
import 'package:flutter/material.dart';

class Report_disater extends StatelessWidget {
  const Report_disater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF0F1),
      appBar: AppBar(
        title: Text('Report a Disaster'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                  title: 'Fire',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning_rounded,
                  iconColor: Color(0xFFE74C3C),
                ),
                buildCard(
                  title: 'Flood',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning_rounded,
                  iconColor: Color(0xFFE74C3C),
                ),
                buildCard(
                  title: 'Earthquake',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning_rounded,
                  iconColor: Color(0xFFE74C3C),
                ),
                buildCard(
                  title: 'Tornado',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning_rounded,
                  iconColor: Color(0xFFE74C3C),
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
    required String title,
    required String imagePath,
    required Color cardColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
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
          Image.asset(
            imagePath
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}
