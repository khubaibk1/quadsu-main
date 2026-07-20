import 'dart:convert' as convert;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/services/firebase_services/firebase_collections.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../functions/print_function.dart';

class FirebaseCloudMessagingV1 {
  final String _endPointUrlForFireBaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  /////////////////////////---------------------
  // Repace with your sender id
  // sender Id
  final String _senderId = "767738169487";
  // Project Id
  final String _projectId = "holeb-transport-app";
  /////////////////////////---------------------
  Future<String> getFirebaseAccessToken() async {
    final response = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "holeb-transport-app",
          "private_key_id": "cec5885451073e4cb6e925de59aa8d350da926c0",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbLnkpG5Zt0vEA\nfTZnKpz/JRPX2KfLZ+h8L/R3aLE1fN7t17K+1Pa8+xGa7laIw9Bhv3Dy8ymsZ5p+\n1bI75ZGlgrpthCW4oY5G9uuOxY27ToNpi4DYihiw+JcoINfBNKefRsDXG/t5qMM6\nSwYjPH7z4uxKZ4cWpB0pEYpJ/YiS58BGPoXIql1DDQf/pYiAn00U7A8MF3EEghci\ncZcDQEezK6ruWDoG/XkV074P268WZCtPhrspePXI5MicYIKVTUtyq1dvwIJjyxuO\nI5xTq5pQpEWqR2u0UrVe3ZdbUmXDqIuMehmmV0suiJWGpKnpkIFKC51KAObB38+P\nPRapev4fAgMBAAECggEAGt7NNAUG4zVnbcJArVR/ot50tSdaxqnTY82Z8yM5rB1X\nLK/wz4JoxwhiYAVtDnl5l7Nih277hFLcOaIfHqf9tD8SsOv07CdtT3RqDWq/w/Mw\nZhI12UjwRZSF9/jX4yiO7dF+isDZppNGWs2q3mcXRHvClo+eoJkCQ545593yzBz3\nuxTFkFFBI0N4AmjJz9Bb7pGZPRLH+j3I51eigsjI5YPZjCDNYY/7L+ypvrP6K1Di\nrN/kz9AShizyXqKPd4Sg7g0SZAH/Nn9TIVCijELm9IquJuaPi+0X4dUVVjwWxrB6\nh8udlH5YtF81rInLLLSIrTblY6hTSYo38WnoezzjIQKBgQDX6wIMpWMqKDO+I9rP\n9ikfc7Krn0soHxz00VGipvz93/TWHcr4JbmPphgfazKGuoQ0Wu0pAKsOeolGCGqT\nxObWE3W8zr0yBRWhYbv5/xBt66hdOgpp/xfCEynYyLWA5XPGDh1trua+s7AQeTIo\nUZw6WUBO/0N24y1sf4GeQAOqYwKBgQC3/RvLDDROtJj3bjooVHORLziru+9FzhMJ\n1mQ4tHCA/2m+40SVS4hiWuRHTxP6Q59moM2CSNF11Blx5MqSdKC9rk0lTC6lFy9C\nZKCTgvRvRaKah2m1ZvsoYPngbTkR7GPY42DKpPcncbveZFtSbxVz7dN1ZZd4q8UI\nSsuUcxcsFQKBgAYk+Oz1M+o6NKa/jHWIkskDWN1Lbi8ZG5DX+BPB3sc2vVfuhx0i\nrbIpztvuCAUPf72hrMgS7cs+r3Nfv/CulMcYzKvv0jB/NoteJaRKnuQR5bupcCxu\nBvYN5430wD2HyhCjzDCX3pcks+j0GfpNwD1k1tCosPnMIznIMx8WwUPzAoGBAKiU\n6S9t+kuXXIVyYSVs5AtGWkW4yG+Md5NO9ruiUWdRIAJA2Sl2cPu1zm6sPWDVLyvo\n8QSMVigBdGMQQLBa3qGOIK+pEyA/kxThgORIXFHMW0X+B1SojD6eRLZnPaB3mbEz\n/g8PgkqJApuuFqL8l4qGgneR42007i8/4TMfFT9VAoGAV9KgA1SXxT5k+mtXo8MC\n1B3zl0+KH8XPUUDzN8RL+YqCoT0scA0Mn21U06MRx8gSpb4xkNucfkYnr7mbqQeU\nEGxHhIlEaEFB4vK2foJEf2N26vCxZkxzik2wOHh9kvmo0YuiVzialdbz1SKukSdl\nkTyFbiQfRpXSW+y3j5Oin54=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-15w8b@holeb-transport-app.iam.gserviceaccount.com",
          "client_id": "116664739268244237321",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-15w8b%40holeb-transport-app.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [_endPointUrlForFireBaseMessagingScope]);

    return response.credentials.accessToken.data;
  }

  Future<String> getMultipleDeviceToken(
      {required List deviceIds, required String apiAuthToken}) async {
    var request = {
      "operation": "create",
      "notification_key_name": await generateNotificationId(),
      "registration_ids": deviceIds
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
      "access_token_auth": "true",
      "project_id": _senderId
    };

    myCustomPrintStatement("notification sending---------");

    var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/notification'),
        headers: headers,
        body: convert.jsonEncode(request));

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['notification_key'] != null) {
        return jsonResponse['notification_key'];
      }
      return '';
    } else {
      return '';
    }
  }

  Future sendPushNotifications({
    required List deviceIds,
    required Map data,
    required String body,
    required String title,
  }) async {
    String apiAuthToken = "";
    String singleDeviceToken = "";
    apiAuthToken = await FirebaseCloudMessagingV1().getFirebaseAccessToken();
    myCustomLogStatements("all device ids are $deviceIds");
    if (deviceIds.length > 1) {
      singleDeviceToken = await getMultipleDeviceToken(
        deviceIds: deviceIds,
        apiAuthToken: apiAuthToken,
      );
    } else {
      singleDeviceToken = deviceIds.first;
    }

    var request = {
      "message": {
        "token": singleDeviceToken,
        "notification": {
          "body": body,
          "title": title,
        },
        "data": data,
      }
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
    };

    myCustomLogStatements("notification sending---------");

    var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
        headers: headers,
        body: convert.jsonEncode(request));
    myCustomLogStatements(
        'the response is ${response.statusCode}.... ${response.body}');
    if (response.statusCode == 200) {
      myCustomLogStatements('notification sent to ${deviceIds.length} devices');
    }
  }

  Future sendPushNotificationsWithFirebaseCollectInsertion({
    required List deviceIds,
    required Map data,
    required Map otherDetails,
    required String body,
    required String title,
    required String reciverUserId,
  }) async {
    String apiAuthToken = "";
    String singleDeviceToken = "";
    apiAuthToken = await FirebaseCloudMessagingV1().getFirebaseAccessToken();
    myCustomLogStatements("all device ids are $deviceIds");
    if (deviceIds.length > 1) {
      singleDeviceToken = await getMultipleDeviceToken(
        deviceIds: deviceIds,
        apiAuthToken: apiAuthToken,
      );
    } else {
      singleDeviceToken = deviceIds.first;
    }

    var request = {
      "message": {
        "token": singleDeviceToken,
        "notification": {
          "body": body,
          "title": title,
        },
        "data": data,
      }
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
    };

    myCustomLogStatements("notification sending---------");

    var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
        headers: headers,
        body: convert.jsonEncode(request));
    myCustomLogStatements(
        'the response is ${response.statusCode}.... ${response.body}');
    if (response.statusCode == 200) {
      myCustomLogStatements('notification sent to ${deviceIds.length} devices');

      var docId = FirebaseCollections.users
          .doc(reciverUserId)
          .collection('notifications')
          .doc()
          .id;
      await FirebaseCollections.users
          .doc(reciverUserId)
          .collection('notifications')
          .doc(docId)
          .set({
        "to": reciverUserId,
        "by": userDataNotifier.value!.userId,
        "title": title,
        "message": body,
        "otherDetails": otherDetails,
        "data": data,
        "read": false,
        "createdAt": Timestamp.now(),
        "id": DateTime.now().second
      });
        }
  }

  Future<String> generateNotificationId() async {
    const allowedChars =
        'abcdefghijklmnopqrstuvwxyz0123456789'; // Define allowed characters
    final rand = Random();
    const idLength = 35; // Maximum length of the ID

    // Generate random characters from the allowed characters
    String id = List.generate(
            idLength, (_) => allowedChars[rand.nextInt(allowedChars.length)])
        .join();

    return '$id${DateTime.now().millisecondsSinceEpoch}';
  }
}
