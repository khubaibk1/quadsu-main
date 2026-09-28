import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quadsu_app/services/api_urls.dart';

/// Signup email verification through the QuadsU backend, which generates,
/// emails and verifies the code. The same routes are used by the website.
class OtpApiService {
  /// Passed at build time so it stays out of the repository:
  /// `--dart-define-from-file=secrets.json` (see secrets.example.json).
  static const String _appSecret = String.fromEnvironment('QUADSU_APP_SECRET');

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Secret': _appSecret,
      };

  /// Returns null when the code was sent, otherwise an error message.
  static Future<String?> sendOtp(String email) {
    return _post(ApiUrls.sendOtpEmail, {'email': email},
        fallbackError: 'Failed to send verification email. Please try again.');
  }

  /// Returns null when the code is correct, otherwise an error message.
  static Future<String?> verifyOtp(String email, String otp) {
    return _post(ApiUrls.verifyOtp, {'email': email, 'otp': otp},
        fallbackError: 'Invalid verification code');
  }

  static Future<String?> _post(String url, Map<String, String> body,
      {required String fallbackError}) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: _headers, body: jsonEncode(body));
      if (response.statusCode == 200) return null;
      print('OTP API error ${response.statusCode}: ${response.body}');
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'];
      }
      return fallbackError;
    } catch (e) {
      print('OTP API request failed: $e');
      return fallbackError;
    }
  }
}
