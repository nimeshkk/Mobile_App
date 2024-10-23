import 'package:app/signIn.dart';
import 'package:app/signup.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
      ),
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 180, 218, 250), Color.fromARGB(255, 45, 111, 186)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80), 
                Center(
                  child: Image.asset(
                    'assets/B.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Disaster Management',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: Text(
                      'A platform to help you in times of need.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100.0),
                
                SizedBox(
                  width: 300, 
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5.0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300, 
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5.0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: Text(
                      'By logging in or registering, you have agreed to the Terms and Conditions and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
