// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quadsu_app/services/api_urls.dart';
// import 'package:quadsu_app/services/newest_webservices.dart';
// import '../modal/notifications_modal.dart';
//
// class NotificationsProvider extends ChangeNotifier {
//   List<NotificationModal> notifications = [];
//
//   bool notificationsLoad = true;
//
//   getNotifications() async {
//     notificationsLoad = true;
//     notifyListeners();
//     Map<String, dynamic> request = {};
//     var response = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.getNotifications,
//         request: request,
//         apiMethod: ApiMethod.get);
//     if (response.status == 1) {
//       notifications = List.generate(response.data['data'].length,
//           (index) => NotificationModal.fromJson(response.data['data'][index]));
//     }
//     notificationsLoad = false;
//     notifyListeners();
//   }
//
//   updateNotifications(List<QueryDocumentSnapshot<Object?>> docs) async {
//     print('Updating notifications....${docs.length}');
//     notifications.clear();
//     for (int i = 0; i < docs.length; i++) {
//       notifications.add(NotificationModal.fromJson(docs[i].data() as Map));
//     }
//     notifyListeners();
//   }
//
//   static void handleNotification({
//     required Map data,
//     required BuildContext context,
//   }) async {
//     print('tkdsfklsjdf  ${data} $context');
//   }
// }
