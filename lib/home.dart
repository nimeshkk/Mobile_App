import 'package:app/components/BottomTab.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  static var page;

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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF2C3E50),
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color(0xFF2C3E50),
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF2C3E50),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reports',
                child: Row(
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 8),
                    Text('View Reports'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  // Navigate to profile
                  break;
                case 'reports':
                  Navigator.pushNamed(context, '/approved-reports');
                  break;
                case 'logout':
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/welcome',
                    (route) => false,
                  );
                  break;
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 220.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              enlargeFactor: 0.15,
              viewportFraction: 0.6,
              enableInfiniteScroll: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
              'assets/disaster1.png',
              'assets/disaster2.png',
              'assets/disaster3.png',
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        i,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
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
                  iconColor: const Color(0xFFE74C3C),
                  onTap: () {
                    Navigator.pushNamed(context, '/report');
                  },
                ),
                buildCard(
                  title: 'View Disaster',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.list_alt_rounded,
                  iconColor: const Color(0xFF3498DB),
                  onTap: () {
                    Navigator.pushNamed(context, '/approved-reports');
                  },
                ),
                buildCard(
                  title: 'About',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF27AE60),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                buildCard(
                  title: 'Weather Updates',
                  imagePath: 'assets/B.png',
                  cardColor: Colors.white,
                  icon: Icons.wb_sunny_rounded,
                  iconColor: const Color(0xFFF39C12),
                  onTap: () {
                    Navigator.pushNamed(context, '/weather');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomTab(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 125, 205),
              ),
              child: Text(
                'Disaster Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Report Disaster'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/report');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('View Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/approved-reports');
              },
            ),
            const Divider(),
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
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String imagePath,
    required Color cardColor,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
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
          onTap: onTap, // Use the passed onTap callback
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
