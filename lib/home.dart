import 'package:app/components/BottomTab.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
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
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Image.asset(i, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                buildCard(
                  title: 'Report a Disaster',
                  imagePath: 'assets/B.png',
                  cardColor: Color.fromARGB(255, 255, 255, 255),
                ),
                buildCard(
                  title: 'Emergency Info',
                  imagePath: 'assets/B.png',
                  cardColor: Color.fromARGB(255, 255, 255, 255),
                ),
                buildCard(
                  title: 'Shelter Locator',
                  imagePath: 'assets/B.png',
                  cardColor: Color.fromARGB(255, 255, 255, 255),
                ),
                buildCard(
                  title: 'First Aid Guide',
                  imagePath: 'assets/B.png',
                  cardColor: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTab(
        selectedIndex: _selectedIndex,
  
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String imagePath,
    required Color cardColor,
  }) {
    return SizedBox(
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: InkWell(
          onTap: () {
            // Handle card tap
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
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
