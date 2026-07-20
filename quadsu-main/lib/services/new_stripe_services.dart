// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart';
//
//
// enum IntentType{
//   setupIntent, createIntent,
// }
// class NewStripeServices {
//   static Map<String, dynamic> paymentIntentData = {};
//   static late String secretKey;
//   static late String publishableKey;
//   static late Map<String, String> headers;
//
//
//
//   static Future<void> getStripeApiKeys(BuildContext context)async{
//     Response response = await Webservices.getData(ApiUrls.getStripeKey);
//     if(response.statusCode==200){
//       var jsonResponse = jsonDecode(response.body);
//       if(jsonResponse['status']==1){
//         publishableKey = jsonResponse['publishable_key'];
//         secretKey = jsonResponse['secret_key'];
//         headers = {
//           'Authorization': 'Bearer ${jsonResponse['secret_key']}',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         };
//       }else{
//         showSnackbar(context, 'Invalid stripe keys');
//       }
//     }
//
//   }
//
//   static Future<StripeResponseModal?> makePayment(
//       {
//         required BuildContext context,
//         // required StripeRequestModal requestModal,
//         required String emailId,
//         required String amount,
//         IntentType intentType = IntentType.createIntent,
//
//         // required String customerId
//       }) async {
//     //currency should be 3 characters code in small letters
//
//     await getStripeApiKeys(context);
//     Stripe.publishableKey = publishable_key;
//     print('creating payment intent');
//     print('payment Intent created');
//     print({
//       "email":emailId,
//       "amount": amount,
//     });
//     var response = await Webservices.postData(apiUrl:intentType==IntentType.createIntent? ApiUrls.getStripeIntent:ApiUrls.setupStripeIntent, body: {
//       "email":emailId,
//       "amount": amount,
//     }, );
//     paymentIntentData = response;
//     if (kDebugMode) {
//       print('the data is $paymentIntentData');
//     }
//
//     await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret:
//           intentType==IntentType.createIntent?
//           paymentIntentData['clientSecret']
//               :
//           null
//           ,
//           setupIntentClientSecret:intentType==IntentType.setupIntent? paymentIntentData['clientSecret']:null,
//           applePay: true,
//           googlePay: true,
//           merchantCountryCode: "US",
//           merchantDisplayName: "Telehealth",
//           testEnv: true,
//           customerId: paymentIntentData['customerID'],
//         ));
//     if (kDebugMode) {
//       print('here..................');
//     }
//     return await NewStripeServices.displayPaymentSheet(
//         context: context, email: emailId,intentType: intentType,
//       // cardIndex: cardIndex
//     );
//   }
//
//   static Future<StripeResponseModal?> displayPaymentSheet(
//       {required BuildContext context,
//         required IntentType intentType,
//         // required StripeRequestModal requestModal,
//         required String email,
//       }) async {
//     try {
//       if (kDebugMode) {
//         print('here displayPaymentSheet');
//       }
//       if (kDebugMode) {
//         print(paymentIntentData['clientSecret']);
//       }
//       var s = await Stripe.instance.presentPaymentSheet(
//           parameters: PresentPaymentSheetParameters(
//             clientSecret: paymentIntentData['clientSecret'],
//             confirmPayment: true,
//           ));
//       PresentPaymentSheetParameters presentPaymentSheetParameters =
//       new PresentPaymentSheetParameters(
//           clientSecret: paymentIntentData['clientSecret']);
//       if (kDebugMode) {
//         print(presentPaymentSheetParameters.clientSecret);
//       }
//
//
//       if (kDebugMode) {
//         print('here');
//       }
//
//
//       if(intentType ==IntentType.setupIntent){
//         var response = await get(
//             Uri.parse(ApiUrls.getpaymentMethodFromSecretKey +
//                 paymentIntentData['clientSecretID']),
//             headers: {
//               "Content-Type": "application/x-www-form-urlencoded",
//               "Authorization": "Bearer $secretKey"
//             });
//         print('the secret key is $secretKey');
//         print('the response is ${response.body}');
//         if (response.statusCode == 200) {
//           var jsonResponse = jsonDecode(response.body);
//           print('the payment method is ${jsonResponse['payment_method']}');
//           return StripeResponseModal(
//             clientSecret: jsonResponse['payment_method'],
//             customerId: paymentIntentData['customerID'],
//           );
//         }
//       }else{
//         return StripeResponseModal(clientSecret: paymentIntentData['clientSecret'], customerId: paymentIntentData['customerID']);
//       }
//
//       //--------------here success code
//       paymentIntentData.clear();
//
//
//     } catch (e) {
//       showSnackbar(context, 'Some error please try again');
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//     // return false;
//   }
// }
//
//
//
// /// this is how a request should be
// // var requestSample = {
// //   "amount": 400,
// //   "currency": "usd",
// //   "description": "Sample Description",
// //   "shipping[name]": "customer name",
// //   "shipping[address][line1]":"510 Townsend St",
// //   "shipping[address][postal_code]":"98140",
// //   "shipping[address][city]":"San Francisco",
// //   "shipping[address][state]":"CA",
// //   "shipping[address][country]":"US",
// // };
//
// // Map<String, dynamic> request = {
// //   "amount": amount,
// //   "currency": currency,
// //   "description": description??"Subscription to work as a freelancer in VMO.",
// //   "shipping[name]":customerName,
// //   "shipping[address][line1]":"510 Townsend St",
// //   "shipping[address][postal_code]":"98140",
// //   "shipping[address][city]":"San Francisco",
// //   "shipping[address][state]":"CA",
// //   "shipping[address][country]":"US",
// //
// // };
