import 'package:quadsu_app/services/api_urls.dart';

class NotificationModel {
  List<Message> messages = [];

  NotificationModel({required this.messages});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    List<Message> data = [];
    if (json['messages'] != null) {
      data = <Message>[];
      json['messages'].forEach((v) {
        data.add(Message.fromJson(v));
      });
    }
    return NotificationModel(messages: data);
  }
}

class Message {
  int notificationId;
  int bookingId;
  String senderName;
  String senderImage;
  String msg;
  String createdAt;
  String linkingPage;
  String screen;
  Map fullData;

  Message(
      {required this.notificationId,
      required this.bookingId,
      required this.senderName,
      required this.senderImage,
      required this.msg,
      required this.createdAt,
      required this.linkingPage,
      required this.screen,
      required this.fullData});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      notificationId: json['notification_id'] ?? 0,
      bookingId: json['booking_id'] ?? 0,
      senderName: json['sender_name'] ?? '',
      senderImage: json['sender_image'] != null
          ? ApiUrls.baseImageUrl + json['sender_image']
          : "",
      msg: json['msg'] ?? "",
      createdAt: json['created_at'] ?? "",
      linkingPage: json['linking_page'] ?? "",
      screen: json['screen'] ?? "",
      fullData: json,
    );
  }
}
