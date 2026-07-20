import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/pages/auth_module/forget_screen.dart';
import 'package:quadsu_app/pages/auth_module/signup_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import '../../functions/validation_functions.dart';
import '../../services/custom_navigation_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // --- LOGIC: Controllers ---
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // --- UI STATE ---
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailAddress.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height to help with responsive spacing
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents background squishing
      body: Stack(
        children: [
          // --- 1. BACKGROUND IMAGE ---
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/launch.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- 2. DARK OVERLAY (Optional - for better text readability) ---
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // --- 3. MAIN CONTENT ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: loginFormKey,
                child: Column(
                  children: [
                    // Top spacing (Adjust this to move everything up or down)
                    SizedBox(height: screenHeight * 0.1),

                    // --- LOGO & APP NAME ---
                    Image.asset(
                      "assets/images/logou.png",
                      height: 130, // Adjusted size to match image
                    ),
                    const Spacer(flex: 1), // smaller space

                    const SizedBox(height: 30),

                    // --- WELCOME TEXT ---
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Connect with college guides',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- EMAIL FIELD ---
                    TextFormField(
                      controller: emailAddress,
                      validator: (val) =>
                          ValidationFunction.emailValidation(val),
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // White background like image
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // --- PASSWORD FIELD ---
                    TextFormField(
                      controller: password,
                      validator: (val) =>
                          ValidationFunction.passwordValidation(val),
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // White background like image
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),

                    // --- FORGOT PASSWORD ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          CustomNavigation.push(
                            context: context,
                            screen: const ForgetPasswordScreen(),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- SIGN IN BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Consumer<MyAuthProvider>(
                        builder: (context, myAuthProvider, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (loginFormKey.currentState!.validate()) {
                                myAuthProvider.login(context,
                                    email: emailAddress.text.trim(),
                                    password: password.text.trim());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF2D3388), // Matches the blue/purple in image
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // --- SPACER ---
                    // This is the key: it fills all remaining space, pushing the Register text to the bottom
                    const Spacer(flex: 2), // smaller space

                    // --- REGISTER NOW (Bottom Footer) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomNavigation.push(
                              context: context,
                              screen: const SignupScreen(),
                            );
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              color:
                                  Color(0xFFF79E1B), // Orange color from image
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom padding to lift it off the edge slightly
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
