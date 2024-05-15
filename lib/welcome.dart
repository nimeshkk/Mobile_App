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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/B.png',
              width: 300,
              height: 300,
            ),
          ),
          const SizedBox(height: 5.0),
          const Text(
            'Welcome',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 2.0),
          const SizedBox(
            width: 220.0,
            child: Center(
              child: Text(
                'Before enjoying  services ',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 220.0,
            child: Center(
              child: Text(
                'Please register first',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const SizedBox(
            width: 320.0,
            child: Center(
              child: Text(
                'By logging in or registering, you have agreed to the',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 320.0,
            child: Center(
              child: Text(
                'Terms and Conditions and Privacy Policy.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
