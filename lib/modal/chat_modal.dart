import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String from;
  String to;
  String message;
  String messageType;
  dynamic createdAt;
  List visibleTo;

  ChatModal({
    required this.from,
    required this.to,
    required this.message,
    required this.messageType,
    required this.createdAt,
    this.visibleTo = const [],
  });

  factory ChatModal.fromJson(Map data) {
    return ChatModal(
      from: (data['senderId'] ?? data['from'])?.toString() ?? '',
      to: data['to']?.toString() ?? '',
      message: data['text'] ?? data['message'] ?? '',
      messageType: data['messageType'] ?? 'text',
      createdAt: data['timestamp'] ?? data['createdAt'],
      visibleTo: List.from(data['visibleTo'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": from.toString(),
      "to": to.toString(),
      "text": message,
      "messageType": messageType,
      "timestamp": FieldValue.serverTimestamp(),
    };
  }
}

