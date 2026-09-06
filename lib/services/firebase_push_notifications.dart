// import 'dart:async';
// import 'dart:convert' as convert;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quadsu_app/constants/api_keys.dart';
// import 'package:quadsu_app/constants/global_data.dart';
// import 'package:quadsu_app/provider/notifications_provider.dart';
// import 'package:quadsu_app/services/api_urls.dart';
// import 'package:quadsu_app/services/newest_webservices.dart';
// import '../constants/global_keys.dart';
// import '../constants/types/user_type.dart';
//
//
// enum NotificationType { incoming, missed, textMessage }
//
// // {receiver: 51, sender: 55, screen: chat_page}
// FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// // String firebaseNotificationAppId =
// //     'AAAAW7EQuGc:APA91bGomKj0EGMArabIVHhlvdJaj8QqNc10hXrchj06yzErwa2bl6K24KtN2BPZerU93okcnOAjYSfeoopUun0ihknXtgWAMNIjSMFbfZSRWEC0Q8N9P7dBzYF9D0rtu5Ap86GC8UZp';
// // String firebaseNotificationAppId = 'AAAAlESySms:APA91bGn462r7lwWS3CqBvORG6rSglikHuY_1Mmd2IBvtxFBXu92z_EMd0-8f8oCyp29bT3lztJYyxQgTNF9wUcDQSHclCqf4aU-iicR5yF8QaL-JtVgUzmdBnBzzFrhu51uJbemonvV';
// // String firebaseNotificationAppId = 'AAAAgvv2l-c:APA91bFURNnCYIKsk5miheXXqsWujj_Bzh_1JicDrzr3Wo3kgFlN-l7htSrGTpT5UGgaiudcxu5QA4uZwf1n9o9kChvNET6w7G4VwhQgvvikK3hn5pIJTSlVgTkUpxX2lH90hVBHTQzv';
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', 'High Importance Notifications',
//     importance: Importance.high, playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// InitializationSettings initializationSettings = const InitializationSettings(
//   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//   iOS: DarwinInitializationSettings(),
// );
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
//   print('${message.data}');
//   if (message.data['screen'] == 'booking') {
//     print('firebase notification is called now callled ');
//     try {
//       // MyGlobalKeys.navigatorKey.currentState!.setState(() {
//       //
//       // });
//       // Map bookingInformation = await Webservices.getMap(ApiUrls.getBookingById + '${message.data['other']['booking_id']}');
//       // push(context: MyGlobalKeys.navigatorKey.currentContext!, screen: BookingInformationPage(bookingInformation: bookingInformation));
//     } catch (e) {
//       print('error in updating notifications count');
//     }
//   }
// }
//
// class FirebasePushNotifications {
//   static didRecieveBgResponse(NotificationResponse notificationResponse) {
//     try {
//       print('didRecieveBgResponse');
//       var ss = notificationResponse.payload;
//       print('the payload is ${ss.runtimeType}....$ss');
//       Map data = jsonDecode(ss!);
//       NotificationsProvider.handleNotification(
//           data: data, context: MyGlobalKeys.navigatorKey.currentContext!);
//     } catch (e) {
//       print('Error in catch block 34534 $e');
//     }
//   }
//
//   static onDidReceiveBackgroundNotificationResponse(
//       NotificationResponse notificationResponse) {
//     // try{
//     //   print('onDidReceiveBackgroundNotificationResponse');
//     //   var ss = notificationResponse.payload;
//     //   print('the payload is $ss');
//     //   Map data = jsonDecode(ss!);
//     //   UserModal userProfileData = UserModal.fromJson(data['user_data']);
//     //   push(context: MyGlobalKeys.navigatorKey.currentContext!, screen: UserProfilePage(userProfileData: userProfileData, ownProfile: userDataNotifier.value?.userId==userProfileData.userId));
//     // }catch(e){
//     //   print('Error in catch block 34534 $e');
//     // }
//   }
//
//   // static const String webPushCertificateKey =
//   //     'BNHWlUKDMN_8MnwTyVOreDc4RFV44TajvR6FOWxKPf5_eTUM89KfmpMDuEgdKEGJ1st20kWYHtVkcN5ZaamJpVk';
//
//   // static const String webPushCertificateKey = 'BPE6NfMirgOcbGrnJJ-NvlXwMpRnWm_Df0UNwLSxFXshKgAUNF-HjNmbgye_knKsbZxmTEOQz6w10Mm9TVcibO4';
//   /// this token is used to send notification // use the returned token to send messages to users from your custom server
//   // static String? token;
//
//   static Future<NotificationSettings> getPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     print('User granted permission: ${settings.authorizationStatus}');
//     return settings;
//   }
//
//   // static Future<String?> getToken() async {
//   //   token = await messaging.getToken(vapidKey: webPushCertificateKey);
//   //   return token;
//   // }
//
//   static initializeFirebaseNotifications() async {
//     await Firebase.initializeApp(
//       // options: DefaultFirebaseOptions.currentPlatform,
//     );
//     await Permission.notification.request();
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             FirebasePushNotifications.didRecieveBgResponse,
//         onDidReceiveBackgroundNotificationResponse: FirebasePushNotifications
//             .onDidReceiveBackgroundNotificationResponse);
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await FirebasePushNotifications.firebaseSetup();
//
//     // String? token = await FirebaseMessaging.instance.getToken();
//     log('The device token is commented here');
//     // log('The device token is $token');
//   }
//
//   static Future<void> firebaseSetup() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print('firebase messaging is being listened');
//       try {
//         RemoteNotification? notification = message.notification;
//         var data = message.data;
//
//         // log('notidata+--'+data.toString());
//         AndroidNotification? android = message.notification?.android;
//         log('this is notification bb bb ---  ');
//         print('___________${notification.toString()}');
//         print('________________');
//         print(message.data);
//         print('________________');
//         if (notification != null && android != null) {
//           if (message.data['screen'] == 'post_action') {
//             //
//             // try{
//             //   push(context: MyGlobalKeys.navigatorKey.currentContext!, screen: IndexPage(selectedIndex: 2,));
//             // }catch(e){
//             //   print('error in updating notifications count');
//             // }
//           }
//           await flutterLocalNotificationsPlugin.show(
//               notification.hashCode,
//               // null,
//               notification.title,
//               notification.body,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   color: Colors.blue,
//                   playSound: true,
//                   icon: '@mipmap/ic_launcher',
//                 ),
//               ),
//               payload: convert.jsonEncode(data));
//           print('the payLoad is $data');
//         }
//       } catch (e) {
//         print('error in listening notifications $e');
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       print('A new onMessageOpenedApp event was published!');
//       print(message.data);
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       String title = "";
//       log('this is notification aa aa ---  ');
//
//       if (notification != null) {
//         title = notification.title.toString();
//       }
//       if (notification != null && android != null) {
//         log('this is notification ---  ${message.data}');
//
//         try {
//           NotificationsProvider.handleNotification(
//               data: message.data,
//               context: MyGlobalKeys.navigatorKey.currentContext!);
//         } catch (e) {
//           print('Error in Inside catch block $e');
//         }
//       }
//     });
//
//   }
//
//
//   static handleNotificationsIfAppIsKilled()async{
//     print('Handling notification when app is killed');
//     var message = await FirebaseMessaging.instance.getInitialMessage();
//     if(message!=null){
//       print('Handling notification when app is killed...notification is presentss');
//       print('the message is ${message.data}');
//       NotificationsProvider.handleNotification(
//           data: message.data,
//           context: MyGlobalKeys.navigatorKey.currentContext!);
//     }
//   }
//
//   static Future updateDeviceToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) async {
//       if (value != null) {
//         print('the device token is $value');
//         if (userDataNotifier.value != null) {
//           // await FirebaseCollections.users.doc(userDataNotifier.value!.id).update({
//           //   "deviceToken": FieldValue.arrayUnion([value]),
//           // });
//           // sendPushNotifications(tokens: [token], data: {}, body: 'Sample notifications', title: 'Title');
//           var request = {
//             ApiKeys.deviceId:value,
//             /// commented to check 21/5/24
//             // ApiKeys.userType: userDataNotifier.value!.userType,
//             ApiKeys.userType: UserType.driver,
//           };
//           await NewestWebServices.getResponse(
//               apiUrl: ApiUrls.editProfile, request: request);
//           // await NewestWebServices.updateDeviceToken(
//           //     userId: userDataNotifier.value!.userId.toString(), token: value);
//         } else {
//           print('device token not updated');
//         }
//       }
//       // log("token-------"+value.toString());
//     });
//   }
//
//   // static Future sendPushNotificationsToTopic(
//   //     { Map? data, required String body,required String title,String? user_id, NotificationType notificationType = NotificationType.incoming, String topic = 'all'})async{
//   //   var request = {
//   //     "notification":{
//   //       "body":body,
//   //       "title":title,
//   //     },
//   //     "to":"/topics/$topic",
//   //   };
//   //   if(data!=null){
//   //     request['data'] = data;
//   //   }
//   //
//   //   Map<String, String> headers = {
//   //     "Content-Type": "application/json",
//   //     "authorization":"key=$firebaseNotificationAppId",
//   //   };
//   //
//   //   var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: headers,body: convert.jsonEncode(request));
//   //   print('the response is ${response.statusCode}.... ${response.body}');
//   //   if(response.statusCode==200){
//   //     print('notification sent to ${topic} devices');
//   //   }
//   //   if(user_id!=null){
//   //     /// store notifications code
//   //     // await FirebaseServices.usersCollection.doc(user_id).collection('notifications').doc().set({
//   //     //   "to":user_id,
//   //     //   "by":userDataNotifier.value!.id,
//   //     //   "type":"$notificationType",
//   //     //   "title":title??'',
//   //     //   "body":body,
//   //     //   "read":false,
//   //     //   "time":DateTime.now()
//   //     // });
//   //
//   //
//   //   }
//   // }
//
//   // static Future sendPushNotifications(
//   //     {required List tokens,
//   //     required Map data,
//   //     required String body,
//   //     required String title,
//   //     String? user_id,
//   //     NotificationType notificationType = NotificationType.incoming}) async {
//   //   var request = {
//   //     "notification": {
//   //       "body": body,
//   //       "title": title,
//   //     },
//   //     "registration_ids": tokens,
//   //     "data": data,
//   //   };
//   //
//   //   Map<String, String> headers = {
//   //     "Content-Type": "application/json",
//   //     "authorization": "key=$firebaseNotificationAppId",
//   //   };
//   //
//   //   var response = await http.post(
//   //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//   //       headers: headers,
//   //       body: convert.jsonEncode(request));
//   //   print('the response is ${response.statusCode}.... ${response.body}');
//   //   if (response.statusCode == 200) {
//   //     print('notification sent to ${tokens.length} devices');
//   //   }
//   //   if (user_id != null) {
//   //     /// store notifications code
//   //     // await FirebaseServices.usersCollection.doc(user_id).collection('notifications').doc().set({
//   //     //   "to":user_id,
//   //     //   "by":userDataNotifier.value!.id,
//   //     //   "type":"$notificationType",
//   //     //   "title":title??'',
//   //     //   "body":body,
//   //     //   "read":false,
//   //     //   "time":DateTime.now()
//   //     // });
//   //   }
//   // }
// }
