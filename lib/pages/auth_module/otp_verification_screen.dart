import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/sendgrid_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OtpVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> requestData;
  final String userType;
  final String correctOtp;

  const OtpVerificationScreen({
    super.key,
    required this.requestData,
    required this.userType,
    required this.correctOtp,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final Color _darkBlue = const Color(0xff2B368B);
  final Color _orange = const Color(0xffF99B20);
  final Color _lightGrayBg = const Color(0xffF3F5F9);
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _currentOtp = widget.correctOtp;
  }

  void _verifyAndSignup() {
    String enteredCode = _codeController.text.trim();

    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the verification code")),
      );
      return;
    }
    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code must be 6 digits")),
      );
      return;
    }

    if (enteredCode == _currentOtp) {
      Map<String, dynamic> verifiedRequest = Map.from(widget.requestData);
      verifiedRequest['email_verified'] = true;
      
      Provider.of<MyAuthProvider>(context, listen: false).signUp(
        context,
        request: verifiedRequest,
        userType: widget.userType,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid verification code"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendCode() async {
    EasyLoading.show(status: 'Sending new code...');
    
    String newOtp = SendGridService.generateOtp();
    bool emailSent = await SendGridService.sendOtpEmail(
      widget.requestData['email'],
      newOtp,
    );
    
    EasyLoading.dismiss();

    if (emailSent) {
      setState(() {
        _currentOtp = newOtp;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New verification code sent!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send code. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = widget.requestData['email'] ?? "your email";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 60,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),

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
                          "Please check your inbox at\n$userEmail",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 35),

                        Icon(Icons.mark_email_read_outlined, size: 80, color: _orange),

                        const SizedBox(height: 20),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "We have sent a verification code to your email. Please verify to continue.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

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

                        GestureDetector(
                          onTap: _resendCode,
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _verifyAndSignup,
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
                        ),
                      ],
                    ),

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
