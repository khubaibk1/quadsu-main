// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:recitepro/app/api/api_key/api_key.dart';
// import 'package:recitepro/app/app_controller/ac.dart';
// import 'package:recitepro/app/global/global.dart';
// import 'package:recitepro/common/common_packages/http/http_services.dart';
//
// class StripePaymentHandle {
//   Map<String, dynamic>? paymentIntent;
//
//   Future<void> stripeMakePayment(
//       {Function? callBackOpenSheet,
//         Function? startCallBack,
//         Function(bool)? endCallback}) async {
//     try {
//       paymentIntent = await createPaymentIntent(
//           '${userDataNotifier.value?.lifeTimeMembershipCost}', 'gbp');
//       print("datadtadtadtadtdta::::::::::::::${paymentIntent}");
//       print("datadtadtadtadtdta::::::::::::::${paymentIntent!['client_secret']}");
//       print("datadtadtadtadtdta::::::::::::::${dotenv.env['STRIPE_SECRET']}");
//       print("datadtadtadtadtdta::::::::::::::${Stripe.publishableKey}");
//       await Stripe.instance
//           .initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           billingDetails: const BillingDetails(
//             name: 'Farah khan',
//             email: 'Farahkhan309@gmail.com',
//             address: Address(
//                 city: 'Glasgow',
//                 country: 'Scotland',
//                 line1: '2 Waid Avenue Newton Mearns ',
//                 line2: 'Glasgow, 2 Waid Avenue, Newton Mearns, G77 6UL, UK,',
//                 postalCode: 'G776UL',
//                 state: 'Glasgow'),
//           ),
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//           //Gotten from payment intent
//           style: ThemeMode.dark,
//           merchantDisplayName: 'Farah khan',
//           applePay: const PaymentSheetApplePay(merchantCountryCode: 'gbp'),
//           googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'gbp'),
//         ),
//       )
//           .then((value) {});
//       callBackOpenSheet?.call();
//       //STEP 3: Display Payment sheet
//       displayPaymentSheet(
//           endCallback: endCallback, startCallBack: startCallBack);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   displayPaymentSheet(
//       {Function? startCallBack, Function(bool)? endCallback}) async {
//     try {
//       // 3. display the payment sheet.
//       await Stripe.instance.presentPaymentSheet().then((value) async {
//         startCallBack?.call();
//         var jsonResponse = await NewWebServices.postData(
//           apiUrl: AU.apiTransaction,
//           request: {
//             AK.KTransaction: paymentIntent!['id'],
//             AK.kAmount: "${userDataNotifier.value?.lifeTimeMembershipCost}"
//           },
//         );
//         if (jsonResponse.status == 1) {
//           endCallback?.call(true);
//         } else {
//           endCallback?.call(false);
//         }
//       });
//     } on Exception catch (e) {
//       if (e is StripeException) {
//       } else {}
//     }
//   }
//
// //create Payment
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//       };
//
//       //Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
//
// //calculate Amount
//   calculateAmount(String amount) {
//     final calculatedAmount = (int.parse(amount)) * 100;
//     return calculatedAmount.toString();
//   }
// }
