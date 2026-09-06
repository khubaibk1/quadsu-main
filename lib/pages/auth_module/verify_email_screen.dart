import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart'; // Removed to avoid error, used standard fonts
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // Logic Controller (If your backend supports code entry later)
  final TextEditingController _codeController = TextEditingController();

  // Design Colors
  final Color _darkBlue = const Color(0xff2B368B);
  final Color _orange = const Color(0xffF99B20);
  final Color _lightGrayBg = const Color(0xffF3F5F9);

  @override
  Widget build(BuildContext context) {
    // Get user email safely
    String userEmail = userDataNotifier.value?.email ?? "your email";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Replaced custom logout logic here so user can go back/logout
            var provider = Provider.of<MyAuthProvider>(context, listen: false);
            provider.logoutPopup(context);
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              var provider = Provider.of<MyAuthProvider>(context, listen: false);
              provider.logoutPopup(context);
            },
            icon: const Icon(Icons.logout, color: Colors.black, size: 20),
            label: const Text("Logout", style: TextStyle(color: Colors.black)),
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 60, // Adjusted for AppBar
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),

                        /// ---------------- LOGO ----------------
                        Center(
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: 170,
                            height: 110,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.shield_outlined, size: 80, color: Colors.orange),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ---------------- TITLE ----------------
                        const Text(
                          "Verify Email",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),

                        Text(
                          "Please check your inbox at\n$userEmail", // Dynamic Email
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// ---------------- ICON ----------------
                        Icon(Icons.mark_email_read_outlined, size: 80, color: _orange),

                        const SizedBox(height: 20),

                        /// ---------------- BODY TEXT ----------------
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "We have sent a verification link/code to your email. Please verify to continue.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// ---------------- INPUT FIELD (Visual Only if backend is link-based) ----------------
                        /*
                           NOTE: Your old code implies a link-based verification (no code entry).
                           I kept this field here to match your requested UI, but it currently
                           doesn't trigger anything specific in your old logic provider.
                           If you have a verifyCode() function, call it in the button below.
                        */
                        Center(
                          child: SizedBox(
                            width: 240,
                            child: TextField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Enter 6-digit code",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 78, 77, 77),
                                  fontSize: 14,
                                ),
                                counterText: "",
                                filled: true,
                                fillColor: _lightGrayBg,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.grey[350],
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// ---------------- RESEND LOGIC ----------------
                        Consumer<MyAuthProvider>(
                            builder: (context, myAuthProvider, child) {
                              return GestureDetector(
                                onTap: () {
                                  myAuthProvider.resendEmail(context, email: userEmail);
                                },
                                child: Text(
                                  "Resend Email",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                              );
                            }
                        ),

                        const SizedBox(height: 25),

                        /// ---------------- BUTTON ----------------
                        Consumer<MyAuthProvider>(
                            builder: (context, myAuthProvider, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String code = _codeController.text.trim();
                                    if (code.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Please enter the verification code")),
                                      );
                                      return;
                                    }
                                    if (code.length != 6) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Code must be 6 digits")),
                                      );
                                      return;
                                    }
                                    // TODO: Call verify code API when backend is ready
                                    // myAuthProvider.verifyEmailCode(context, email: userEmail, code: code);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Verification API not implemented yet. Please use the link in your email.")),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _darkBlue,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Verify Code",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ],
                    ),

                    /// ---------------- FOOTER ----------------
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: "By using Quads U, you agree to the ",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            TextSpan(text: "."),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}