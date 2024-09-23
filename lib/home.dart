import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
          const SizedBox(height: 20.0),
          Expanded( // Use Expanded to fill the remaining space
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: (screenWidth > 600) ? 4 : 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  _buildSquareButton(context, 'Dashboard'),
                  _buildSquareButton(context, 'Report a Disaster'),
                  _buildSquareButton(context, 'Emergency Contacts'),
                  _buildSquareButton(context, 'More Features'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String label) {
    return Container(
      width: 150, // Fixed width
      height: 150, // Fixed height
      child: ElevatedButton(
        onPressed: () {
          // Handle navigation based on label
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 255, 255, 255),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
