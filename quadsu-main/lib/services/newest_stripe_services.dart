// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:quadsu_app/functions/print_function.dart';
// import 'package:quadsu_app/services/api_urls.dart';
// import 'package:quadsu_app/services/newest_webservices.dart';
// import 'package:quadsu_app/widget/show_snackbar.dart';
//
//
// // https://www.bluediamondresearch.com/WEB01/Teleheath/Api/User_api/getKey
// ///sample keys
// class NewestStripeServices{
//   static Map<String, dynamic> paymentIntentData = {};
//   static late String secretKey = 'sk_test_UAFSXvBmJdYgW473uAyGZNux';
//   // static late String secretKey;
//   static late String publishableKey = 'pk_test_76SB2oH4bzCRFX4Ilxtiwo0l';
//   // static late String publishableKey;
//   static late Map<String, String> headers = {
//     'Authorization': 'Bearer ${secretKey}',
//     'Content-Type': 'application/x-www-form-urlencoded',
//   };
//   // static late Map<String, String> headers;
//   static const String getStripeKeysUrl = 'https://www.bluediamondresearch.com/WEB01/Teleheath/Api/User_api/getKey';
//   // static const String getStripeKeysUrl = ApiUrls.baseUrl + 'getStripeKey';
//   static const String getPaymentIntentsUrl = 'https://api.stripe.com/v1/payment_intents';
//
//   static const String client_secret = 'client_secret';
//   static const String paymentIntentId = 'id';
//   // static const String publishable_key = 'publishable_key';
//   // static const String secret_key = 'secret_key';
//
//   // "publishable_key": "pk_test_76SB2oH4bzCRFX4Ilxtiwo0l",
//   // "secret_key": "sk_test_UAFSXvBmJdYgW473uAyGZNux",
//
//
//
//   //  Future<void> getStripeApiKeys()async{
//   //   // Response response = await Webservices.getData(getStripeKeysUrl);
//   //   var response = await NewestWebServices.getResponse(apiUrl: getStripeKeysUrl, request: {}, );
//   //   if(response.status==1){
//   //     publishableKey = response.data['publishable_key'];
//   //     secretKey = response.data['secret_key'];
//   //     headers = {
//   //       'Authorization': 'Bearer ${response.data['secret_key']}',
//   //       'Content-Type': 'application/x-www-form-urlencoded',
//   //     };
//   //   }
//   //
//   // }
//
//
//
//    Future<Map> getPaymentIntent(String amount, String currency)async{
//
//     // try {
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': ((double.parse(amount)) * 100).toInt().toString(),
//         'currency': currency,
//       };
//
//
//       var response = await NewestWebServices.globalApisGetResponse(apiUrl: getPaymentIntentsUrl, request: body, customHeaders: headers, jsonConversion: false);
//       // print('th')
//
//       print('tsklfls respionse ${response.body}');
//
//       return jsonDecode(response.body);
//     // } catch (e) {
//     //   myCustomLogStatements('Error in catch block 34256 $e');
//     //   showSnackbar('Error in catch block $e');
//     // }
//   }
//
//
//
//   Future<Map?> checkPaymentIntentStatus(String paymentIntentIdString)async
//   {
//
//   try{
//     String url = 'https://api.stripe.com/v1/payment_intents/$paymentIntentIdString';
//
//     myCustomPrintStatement( 'sdfk $paymentIntentIdString....$url');
//     var response = await NewestWebServices.globalApisGetResponse(apiUrl: url, request: {}, apiMethod: ApiMethod.get, customHeaders: headers);
//     myCustomLogStatements('the response for url $url is ${response.statusCode}...${response.body}');
//     if(response.statusCode==200){
//
//       return jsonDecode(response.body);
//     }
//   }catch(e){
//     print('Error in catch block $e');
//   }
//
//   }
//
//   Future<void> stripeMakePayment(
//       {Function? callBackOpenSheet,
//         Function? startCallBack,
//         required String amount,
//         required String currency,
//         Map? paymentIntentResponse,
//
//         Function(bool)? endCallback}) async {
//     try {
//       if(paymentIntentResponse==null){
//         paymentIntentResponse = await getPaymentIntent(amount, currency);
//       }
//       Stripe.publishableKey = publishableKey;
//
//       await Stripe.instance
//           .initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           billingDetails: const BillingDetails(
//             name: 'Manish Talreja',
//             email: 'Farahkhan309@gmail.com',
//             address: Address(
//                 city: 'Glasgow',
//                 country: 'Scotland',
//                 line1: '2 Waid Avenue Newton Mearns ',
//                 line2: 'Glasgow, 2 Waid Avenue, Newton Mearns, G77 6UL, UK,',
//                 postalCode: 'G776UL',
//                 state: 'Glasgow'),
//           ),
//           paymentIntentClientSecret: paymentIntentResponse!['client_secret'],
//           //Gotten from payment intent
//           style: ThemeMode.dark,
//           merchantDisplayName: 'Farah khan',
//           // applePay: const PaymentSheetApplePay(merchantCountryCode: 'gbp'),
//
//           googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'gbp'),
//         ),
//       )
//           .then((value) {});
//       callBackOpenSheet?.call();
//       //STEP 3: Display Payment sheet
//       await displayPaymentSheet(
//           endCallback: endCallback, startCallBack: startCallBack);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//   displayPaymentSheet(
//       {Function? startCallBack, Function(bool)? endCallback}) async {
//     try {
//       // 3. display the payment sheet.
//       await Stripe.instance.presentPaymentSheet().then((value) async {
//         startCallBack?.call();
//         // var jsonResponse = await NewestWebServices.getResponse(
//         //   apiUrl: Api,
//         //   request: {
//         //     AK.KTransaction: paymentIntent!['id'],
//         //     AK.kAmount: "${userDataNotifier.value?.lifeTimeMembershipCost}"
//         //   },
//         // );
//         // if (jsonResponse.status == 1) {
//         //   endCallback?.call(true);
//         // } else {
//         //   endCallback?.call(false);
//         // }
//
//       });
//     } on Exception catch (e) {
//       if (e is StripeException) {
//       } else {}
//     }
//   }
//
//
// }