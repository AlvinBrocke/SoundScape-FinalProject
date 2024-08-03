import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/views/Layout.dart';
import 'package:soundscape/views/auth/signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          }

          if (snapshot.data != null) {
            return const Layout();
          }

          // if they are null, we are not logged in
          return Scaffold(
            backgroundColor: const Color(0x00161616),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      'assets/images/welcomepage.jpg',
                      fit: BoxFit
                          .cover, // Ensures the image covers the entire screen
                    ),
                  ),
                ),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/Logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Welcome to Soundscape! Discover, review, and share music with our comprehensive reviews and personalized recommendations. Join a vibrant community of music enthusiasts and dive deep into every beat. Let your musical journey begin!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple, // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
