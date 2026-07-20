import 'package:flutter/cupertino.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/functions/print_function.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import '../constants/global_data.dart';
import '../functions/common_function.dart';
import '../pages/commons/bottom_bar_screen.dart';
import '../provider/bottom_tabbar_provider.dart';
import '../widget/common_alert_dailog.dart';
import '../widget/custom_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// var clientId="AfnVPpRngBSBmx0pYzFWmjXh6h9EdfoRZE9Dd02ZrcVoXg1kGLdfmOuRyvd-n2YWJy4WY4EGzzvlX0FV";
// var clientSecret="ED1W8X0itSdc7_ul0OSPhkSFuCoNmfkbXFr7Jc5-mlbr_ksOoGh9hC4lLn7yTaVK07BYp3zaN5lIWMOI";

var loginId="sb-tftxs30567458@personal.example.com";
var password="k9V7tw>F";
bool isSuccessfully=true;


usePayPal({required String message,required double payAmount,required Function(Map) onSuccess, Function(Map)? onError, Function(Map)? onCancel})
async {

  print("Dtdtadtadtadtadtadtadtadtadt::::::::::::::${myAppSettings?.paypalClientId}");
  print("Dtdtadtadtadtadtadtadtadtadt::::::::::::::${myAppSettings?.paypalClientSecret}");
  print("Dtdtadtadtadtadtadtadtadtadt::::::::::::::${ myAppSettings?.isPaymentLive}");
  print("Dtdtadtadtadtadtadtadtadtadt::::::::::::::${ myAppSettings?.isPaymentLive==true}");

   CustomNavigation.push(context:  MyGlobalKeys.navigatorKey.currentContext!, screen: UsePaypal(
      sandboxMode: myAppSettings?.isPaymentLive==false,
      clientId: myAppSettings?.paypalClientId??"",
      secretKey:   myAppSettings?.paypalClientSecret??"",
      returnURL: "https://samplesite.com/return",
      cancelURL: "https://samplesite.com/cancel",
      transactions:  [
        {
          "amount": {
            "total":formatToTwoDecimalPlaces(payAmount) .toString(),
            "currency": "USD",
            "details": {
              "subtotal": formatToTwoDecimalPlaces(payAmount) .toString(),
              "shipping": '0',
              "shipping_discount": 0
            }
          },
          "description": "The payment transaction description.",
          "item_list":  {
            "items": [
              {
                "name": message,
                "quantity": 1,
                "price": formatToTwoDecimalPlaces(payAmount).toString(),
                "currency": "USD"
              }
            ],
            "shipping_address": const {
              "recipient_name": "Jane Foster",
              "line1": "Travis County",
              "line2": "",
              "city": "Austin",
              "country_code": "US",
              "postal_code": "73301",
              "phone": "+00000000",
              "state": "Texas"
            },
          }
        }
      ],
      note: "Contact us for any questions on your order.",
      onSuccess: (Map params) async {
        print("onSuccess: $params");
        onSuccess.call(params);
      },

      onError: (error) {
        print("onError: $error");
        onError?.call(error);

      },

      onCancel: (params) {
        print('cancelled: $params');
        onCancel?.call(params);
      }));
}


showPaymentConfirmPopup(
    {required String message}) {
  print("jaxxkjnckjdnskvcndsv");
   showCommonAlertDailog(
    MyGlobalKeys.navigatorKey.currentContext!,
    imageUrl: MyImagesUrl.success,
    headingText: 'Appointment Confirmation',
    message: message,
    actions: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: "Ok",
            width: 100,
            onTap: () {
              BottomTabBarProvider bottomTabBarProvider=Provider.of<BottomTabBarProvider>(MyGlobalKeys.navigatorKey.currentContext!,listen: false);
              DashBoardProvider dashBoardProvider=Provider.of<DashBoardProvider>(MyGlobalKeys.navigatorKey.currentContext!,listen: false);
              usertype = UserType.student;
              dashBoardProvider.getStudentDashBoard();
              CustomNavigation.pushReplacement(context: MyGlobalKeys.navigatorKey.currentContext!, screen: const BottomBarScreen());
              bottomTabBarProvider.changeIndex(index: 0);
            },
          )
        ],
      )
    ],
  );
}

showPaymentCancelPopup() {
  return showCommonAlertDailog(
    MyGlobalKeys.navigatorKey.currentContext!,
    error: true,
    headingText: 'Appointment Confirmation',
    message: 'An error occurred in payment. try again ',
    actions: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: "Ok",
            width: 100,
            onTap: () {
              Navigator.pop( MyGlobalKeys.navigatorKey.currentContext!,true);
            },
          )
        ],
      )
    ],
  );
}




Future<String?> generatePaypalAccessToken() async {
  print("datadtadtdta::::::${myAppSettings?.payPalBaseUrl}");

  final credentials = base64Encode(utf8.encode('${myAppSettings?.paypalClientId}:${myAppSettings?.paypalClientSecret}'));

  final response = await http.post(
    Uri.parse('${myAppSettings?.payPalBaseUrl}v1/oauth2/token'),
    headers: {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'grant_type=client_credentials',
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['access_token'];
  } else {
    print('Error fetching PayPal access token: ${response.body}');
    return null;
  }
}

Future<String?> getCaptureIdFromPayment(String accessToken, String paymentId) async {
  print('Access Token: $accessToken');
  print('Payment ID: $paymentId');

  final baseUrl = (myAppSettings?.payPalBaseUrl?.isNotEmpty == true) 
      ? myAppSettings!.payPalBaseUrl 
      : (myAppSettings?.isPaymentLive == true ? "https://api.paypal.com/" : "https://api.sandbox.paypal.com/");
  final url = '${baseUrl}v1/payments/payment/$paymentId';
  print("uuurruruuru::::::$url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final paymentDetails = jsonDecode(response.body);
     myCustomLogStatements("dadtadtadtadtadt:::${response.body}");
    // Look for the capture ID in the related_resources field
    if (paymentDetails['transactions'] != null && paymentDetails['transactions'].isNotEmpty) {
      final relatedResources = paymentDetails['transactions'][0]['related_resources'];

      if (relatedResources != null && relatedResources.isNotEmpty) {
        final capture = relatedResources[0]['sale']; // Assuming it is a sale capture

        if (capture != null) {
          final captureId = capture['id']; // This is the Capture ID
          print('Capture ID: $captureId');
          return captureId;
        }
      }
    }

    print('Capture ID not found in payment details.');
    return null;
  } else {
    print('Error fetching payment details: ${response.statusCode} ${response.body}');
    return null;
  }
}


Future<Map<String, dynamic>?> refundPayment(String accessToken, String captureId, double amount, String bookingId, String cancelReason) async {
  final url = '${myAppSettings?.payPalBaseUrl}v2/payments/captures/$captureId/refund';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'amount': {
        'currency_code': 'USD',
        'value': amount.toStringAsFixed(2),
      },
      'invoice_id': 'Booking#$bookingId',
      'note_to_payer': cancelReason,
    }),
  );

  if (response.statusCode == 201) { // 201 indicates refund success
    myCustomLogStatements("refund proceed ::::::::${response.body}");
    return jsonDecode(response.body);
  } else {
    print('Error refunding payment: ${response.body}');
    return null;
  }
}

