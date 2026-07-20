import 'package:quadsu_app/constants/global_error_constants.dart';
import 'dart:convert';
import 'dart:math' as math;

import '../../widget/show_snackbar.dart';
import '../newest_webservices.dart';

class TwilioApiServices {
  // static const String apiKey = 'QUM3NzgzNTA4NmVkYjk4YjNjNGFkNjNiOTA4Zjk0NDQxMTpjYzA2OWNlMDk3NTFjMjY3NzlkNzgwNjUyMTcwYzI2NQ==';// ride hailing
  // static const String fromNumber = '22230487878';// ride hailing

  static const String account_sid =
      'ACc5fe0852c3034a42b618465cac7e4bea'; // holeb
  static const String twilioApiUrl =
      'https://api.twilio.com/2010-04-01/Accounts/$account_sid/Messages.json';

  static const String auth_token = '6fec359901445fbb6cc0453834760a32'; // holeb
  static const String fromNumber = '14027966898'; // holeb
  // accid:sud
  static Future<String?> sendOtp(
      {required String phoneWithCode, int length = 6}) async {
    int? randomOtp;
    randomOtp = generateOtp(length);
    String mobileNumber = '+$phoneWithCode';
    // var headers = {
    //   'Content-Type': 'application/x-www-form-urlencoded',
    //   'Authorization': 'Basic QUM3NzgzNTA4NmVkYjk4YjNjNGFkNjNiOTA4Zjk0NDQxMTpjYzA2OWNlMDk3NTFjMjY3NzlkNzgwNjUyMTcwYzI2NQ=='
    // };
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${base64Conversion()}'
    };
    var request = {
      'To': mobileNumber,
      'From': '+$fromNumber',
      // ApiKeys.From: '+18563693674',
      'Body':
          'Your one-time OTP for Holeb is $randomOtp. Do not share it with anyone.'
    };
    var response = await NewestWebServices.globalApisGetResponse(
        customHeaders: headers,
        apiUrl: twilioApiUrl,
        request: request,
        jsonConversion: false);
    print('lkoljoljj-----${response.body}');
    print('request--$request');
    print('requresponse.statusCodeest--${response.statusCode}');
    var jsonDecoder = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return randomOtp.toString();
    } else {
      if (jsonDecoder['code'] == 21211 || jsonDecoder['code'] == 21614) {
        showSnackbar(GlobalErrorConstants.incorrectOtp);
      } else {
        showSnackbar(jsonDecoder['message']);
      }
    }
    return null;
    // if(randomOtp!=null){
    //   return randomOtp.toString();
    // }else{
    //
    // }
  }

  static int generateOtp(int length) {
    var random = math.Random();
    int min = math.pow(10, length - 1).toInt();
    int max = (math.pow(10, length).toInt()) - 1;
    print('the min and max is $min.... $max');
    return min + random.nextInt(max - min + 1);
  }

  static String base64Conversion() {
    var string = '$account_sid:$auth_token';
    return base64Encode(utf8.encode(string));
  }
}
