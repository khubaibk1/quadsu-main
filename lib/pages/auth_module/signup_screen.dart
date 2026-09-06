import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/pages/auth_module/login_screen.dart';
import 'package:quadsu_app/pages/auth_module/otp_verification_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/sendgrid_service.dart';
import '../../functions/validation_functions.dart';

class SignupScreen extends StatefulWidget {
  // Removed required userType constructor
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // --- OLD LOGIC CONTROLLERS ---
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController(); // Required for backend
  final TextEditingController aboutController = TextEditingController(); // For Guide Referral

  // --- STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- MARKETING INFO (Student Only) ---
  String? _selectedHearAboutUs;
  final List<String> _hearAboutOptions = [
    'Google', 'YouTube', 'Yahoo', 'Bing',
    'One of our Quad Guides', 'One of our students',
    'Word of mouth', 'In the news', 'Other'
  ];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddress.dispose();
    password.dispose();
    confirmPassword.dispose();
    pinCodeController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  // --- UNIFIED SUBMIT FUNCTION ---
  Future<void> _handleRegistration(MyAuthProvider myAuthProvider, String selectedUserType) async {
    if (formKey.currentState!.validate()) {

      // 1. Prepare Data
      Map<String, dynamic> requestData = {
        ApiKeys.email: emailAddress.text.trim(),
        ApiKeys.firstName: firstNameController.text.trim(),
        ApiKeys.lastName: lastNameController.text.trim(),
        ApiKeys.zip_code: pinCodeController.text.trim(),
        ApiKeys.password: password.text.trim(),
        ApiKeys.type: selectedUserType,
      };

      // Specific Logic based on Button Clicked
      if (selectedUserType == UserType.student) {
        if (_selectedHearAboutUs != null) {
          requestData[ApiKeys.hearAboutStatus] = _selectedHearAboutUs;
        }
      } else {
        // If Guide, add referral if present
        if (aboutController.text.isNotEmpty) {
          requestData[ApiKeys.referredBy] = aboutController.text.trim();
        }
      }

      // 2. Generate OTP & Send Email (Client Side)
      EasyLoading.show(status: 'Sending Verification Code...');
      
      String otp = SendGridService.generateOtp();
      bool emailSent = await SendGridService.sendOtpEmail(emailAddress.text.trim(), otp);
      
      EasyLoading.dismiss();

      if (emailSent) {
        // 3. Navigate to OTP Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              requestData: requestData, // Pass the form data forward
              userType: selectedUserType,
              correctOtp: otp, // Pass the code generated here to check against
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send verification email. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // ---------- LOGO ----------
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 180,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.shield_outlined, size: 80, color: Colors.orange),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- TITLE ----------
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ---------- INPUTS ----------
                      // Note: We use First/Last Name separately to match backend controllers
                      _buildInput(firstNameController, "First Name",
                          validator: (val) => ValidationFunction.requiredValidation(val)),
                      const SizedBox(height: 14),

                      _buildInput(lastNameController, "Last Name",
                          validator: (val) => ValidationFunction.requiredValidation(val)),
                      const SizedBox(height: 14),

                      _buildInput(emailAddress, "Email",
                          inputType: TextInputType.emailAddress,
                          validator: (val) => ValidationFunction.emailValidation(val)),
                      const SizedBox(height: 14),

                      _buildInput(password, "Password",
                          isPassword: true,
                          isVisible: _isPasswordVisible,
                          onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          validator: (val) => ValidationFunction.passwordValidation(val)),
                      const SizedBox(height: 14),

                      _buildInput(confirmPassword, "Confirm Password",
                          isPassword: true,
                          isVisible: _isConfirmPasswordVisible,
                          onVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                          validator: (val) => ValidationFunction.confirmPasswordValidation(val, password.text)),

                      const SizedBox(height: 14),

                      // Zip code is usually required by backend for location
                      _buildInput(pinCodeController, "Zip Code",
                          inputType: TextInputType.number,
                          validator: (val) => ValidationFunction.requiredValidation(val)),

                      const SizedBox(height: 25),

                      // ---------- ROLES SELECTION ----------
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "I want to:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Consumer<MyAuthProvider>(
                          builder: (context, myAuthProvider, child) {
                            return Row(
                              children: [
                                // -------- FIND GUIDE BUTTON (STUDENT) --------
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _handleRegistration(myAuthProvider, UserType.student),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff2B368B),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Find a Guide",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // -------- BE A GUIDE BUTTON (GUIDE) --------
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _handleRegistration(myAuthProvider, UserType.guide),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffF99B20),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Be a Guide",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15, // Slightly adjusted font size to fit
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),

                      const SizedBox(height: 30),

                      // ---------- LOGIN LINK ----------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              CustomNavigation.pushAndRemoveUntil(
                                context: context,
                                screen: const LoginPage(),
                              );
                            },
                            child: const Text(
                              "Login Now",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffF99B20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Terms footer
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text.rich(
                          TextSpan(
                            text: "By using Quads U, you agree to the ",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                            children: [
                              TextSpan(
                                text: "Terms",
                                style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: "."),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- HELPER: INPUT BUILDER ----------
  Widget _buildInput(
      TextEditingController controller,
      String hint, {
        bool isPassword = false,
        bool isVisible = false,
        VoidCallback? onVisibilityToggle,
        TextInputType inputType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      keyboardType: inputType,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: const Color(0xffF3F5F9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff2B368B), width: 1),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onVisibilityToggle,
        )
            : null,
      ),
    );
  }
}