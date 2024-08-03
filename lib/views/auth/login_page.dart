import 'package:flutter/material.dart';
import 'package:soundscape/models/user_model.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/service/firestore_service.dart';
import 'package:soundscape/views/Layout.dart';
import 'signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Perform login action
        authService.login(
          _emailController.text,
          _passwordController.text,
        );

        debugPrint(authService.currentUser().toString());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Login successful!',
                  style: TextStyle(color: Colors.white)),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Layout()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                e.message!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Discover, review, and share your music',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputField(
                            label: 'Email',
                            controller: _emailController,
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            validator: _passwordValidator,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              // Handle forgot password
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 70),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                // textStyle: const TextStyle(color: Colors.white),
                                backgroundColor: const Color(0xFF343434),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSocialButton(
                            'Google',
                            'assets/images/google_logo.png',
                            () async {
                              try {
                                // google log in
                                UserCredential userCredential =
                                    await authService.googleAuth();

                                // check if user already exists in firestore
                                bool result =
                                    await userExist(userCredential.user!.uid);
                                if (result) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            'User has been logged in!',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const Layout()),
                                    );
                                  }
                                } else {
                                  // add user to firestore
                                  UserModel user = UserModel(
                                    id: userCredential.user!.uid,
                                    email: userCredential.user!.email!,
                                    username: userCredential.user!.displayName!,
                                    url: userCredential.user!.photoURL!,
                                    beatsId: [],
                                    likedBeatsId: [],
                                  );
                                  addUser(user);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            'User added to Firestore!',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const Layout()),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        e.message!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _navigateToSignUp,
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF343434),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String text, String assetPath, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          assetPath,
          height: 24,
          width: 24,
        ),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF343434),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
}
