import 'package:app/signIn.dart';
import 'package:app/signup.dart';
import 'package:app/public_report_view.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    try {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ));
      
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOutBack,
      ));
      
      // Start animation after a small delay to ensure everything is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _animationController != null) {
          _animationController!.forward();
        }
      });
    } catch (e) {
      print('Error initializing animations: $e');
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 166, 216, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // If animations are not ready, show content without animation
    if (_fadeAnimation == null || _slideAnimation == null) {
      return _buildMainContent();
    }

    return FadeTransition(
      opacity: _fadeAnimation!,
      child: SlideTransition(
        position: _slideAnimation!,
        child: _buildMainContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        
        // Logo/Image
        Hero(
          tag: 'logo',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/B.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.emergency,
                      size: 100,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Title
        const Text(
          'Disaster Management',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Subtitle
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'A platform to help you in times of need.\nReport emergencies and stay informed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Color.fromARGB(179, 0, 0, 0),
              height: 1.5,
            ),
          ),
        ),
        
        const SizedBox(height: 60),
        
        // Action Buttons
        _buildActionButtons(),
        
        const SizedBox(height: 40),
        
        // Terms and Privacy
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'By using this app, you agree to our Terms and Conditions and Privacy Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              color: Color.fromARGB(179, 0, 0, 0),
            ),
          ),
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Sign Up Button
        SizedBox(
          width: 280,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 8.0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Login Button
        SizedBox(
          width: 280,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signin');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              side: BorderSide(color: Colors.blue.shade600, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
 
      ],
    );
  }


}
