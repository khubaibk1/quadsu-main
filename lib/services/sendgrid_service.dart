import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class SendGridService {
  // ⚠️ REPLACE THIS WITH YOUR KEY. DO NOT COMMIT TO GITHUB.
  static const String _apiKey = "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"; 
  static const String _fromEmail = "admin@quadsu.com"; // Must be verified in SendGrid
  static const String _fromName = "QuadsU";

  // Generate a random 6 digit code
  static String generateOtp() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  static Future<bool> sendOtpEmail(String toEmail, String otpCode) async {
    const String url = "https://api.sendgrid.com/v3/mail/send";

    Map<String, dynamic> body = {
      "personalizations": [
        {
          "to": [{"email": toEmail}]
        }
      ],
      "from": {
        "email": _fromEmail,
        "name": _fromName
      },
      "subject": "Verify your QuadsU Account",
      "content": [
        {
          "type": "text/html",
          "value": """
            <h3>Thank you for registering! here is your six digit verification code</h3>
            <h1 style="color: #2D3388;">$otpCode</h1>
            <p>Kind regards,<br>The QuadsU Team</p>
          """
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 202) {
        return true;
      } else {
        print("SendGrid Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending email: $e");
      return false;
    }
  }
}
