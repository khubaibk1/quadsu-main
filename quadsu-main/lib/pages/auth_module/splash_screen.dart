import 'package:flutter/material.dart';
// REMOVED to stop error
import 'package:provider/provider.dart';
import 'package:quadsu_app/pages/auth_module/login_screen.dart';
import 'package:quadsu_app/pages/auth_module/signup_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // ✅ Existing Backend Logic
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyAuthProvider>(context, listen: false)
          .splashAuthentication(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/launch.png"), // Ensure this asset exists
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // --- LOGO ---
                  Image.asset(
                      "assets/images/logou.png", // Ensure this asset exists
                      height: 150
                  ),

                  const SizedBox(height: 24),

                  // --- WELCOME TEXT ---
                  const Text(
                    "Welcome to Quads U",
                    style: TextStyle( // ✅ Changed to standard TextStyle
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SansSerif', // Fallback font
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // --- DESCRIPTION TEXT ---
                  const Text(
                    "A peer-to-peer platform designed to connect current high school students with undergraduates to get real, firsthand insights about college majors, campus life, and academic experiences.",
                    style: TextStyle( // ✅ Changed to standard TextStyle
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),

                  // --- CREATE ACCOUNT BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Select User / Signup Flow
                        CustomNavigation.push(
                          context: context,
                          screen: const SignupScreen(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Create an account",
                        style: TextStyle( // ✅ Changed to standard TextStyle
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- LOGIN TEXT ---
                  GestureDetector(
                    onTap: () {
                      // Navigate to Login Page
                      CustomNavigation.push(
                          context: context,
                          screen: const LoginPage()
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}