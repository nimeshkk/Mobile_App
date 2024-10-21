import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome.dart'; // Adjust the import according to your file structure
import 'signIn.dart'; // Adjust the import according to your file structure

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'An error occurred');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Invalid email address';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return value.length < 8 ? 'Password must be at least 8 characters' : null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm password is required';
    return value != _passwordController.text ? 'Passwords do not match' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WelcomePage()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          'assets/B.png', // Adjust the asset path according to your project structure
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Create Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please fill in the form to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _emailController,
                      validator: _validateEmail,
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscureText1,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscureText2,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createUserWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDividerWithText(),
                    const SizedBox(height: 24),
                    _buildSocialSignIn(),
                    const SizedBox(height: 24),
                    _buildSignInOption(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword ? obscureText : false,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(prefixIcon, color: Colors.blue),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or sign up with',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton('Google', 'assets/google.png'), 
      ],
    );
  }

  Widget _buildSocialButton(String title, String assetPath) {
    return Column(
      children: [
        Image.asset(assetPath, width: 40, height: 40),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildSignInOption() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
          children: const <TextSpan>[
            TextSpan(
              text: 'Sign In',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
