import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; // Ensure this is imported for navigation

class LoginAndSignPage extends StatefulWidget {
  const LoginAndSignPage({super.key});

  @override
  _LoginAndSignPageState createState() => _LoginAndSignPageState();
}

class _LoginAndSignPageState extends State<LoginAndSignPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = true; // Toggle between sign-in and sign-up

  Future<void> _handleAuth() async {
    try {
      if (_isSignIn) {
        // Sign in
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Navigate to home or another page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Sign up
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Navigate to home or another page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  _isSignIn ? 'Login' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Phone number',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                  ),
                  style:
                      const TextStyle(color: Colors.white), // Input text color
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                  ),
                  style:
                      const TextStyle(color: Colors.white), // Input text color
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    _isSignIn ? 'Login' : 'Sign Up',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Toggle between sign-in and sign-up
                    setState(() {
                      _isSignIn = !_isSignIn;
                    });
                  },
                  child: Text(
                    _isSignIn
                        ? "Don't have an account? Sign Up"
                        : 'Already have an account? Login',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                if (_isSignIn)
                  TextButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter your email')),
                        );
                        return;
                      }
                      try {
                        await _auth.sendPasswordResetEmail(
                          email: _emailController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset email sent!'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
