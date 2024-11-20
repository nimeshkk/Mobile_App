import 'package:app/components/BottomTab.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Emergency Services',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF2C3E50),
            size: 28,
          ),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 220.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              viewportFraction: 0.85,
            ),
            items: [
              'assets/B.png',
              'assets/B.png',
              'assets/B.png',
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: screenWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(i, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const Text(
                  'Emergency Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                buildCard(
                  title: 'Report a Disaster',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.warning_rounded,
                  iconColor: Color(0xFFE74C3C),
                ),
                buildCard(
                  title: 'Emergency Info',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.info_rounded,
                  iconColor: Color(0xFF3498DB),
                ),
                buildCard(
                  title: 'Shelter Locator',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.home_rounded,
                  iconColor: Color(0xFF27AE60),
                ),
                buildCard(
                  title: 'First Aid Guide',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.medical_services_rounded,
                  iconColor: Color(0xFFF39C12),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTab(), 
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
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            // Handle card tap
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
