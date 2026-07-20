import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:quadsu_app/constants/types/message_type.dart';
import 'package:quadsu_app/services/api_urls.dart';
import '../../constants/global_data.dart';
import '../../modal/chat_modal.dart';
import 'firebase_collections.dart';


class FirebaseChatServices {

  // ── Room ID ─────────────────────────────────────────────────────────────────
  // Always sort IDs numerically → smaller_larger, e.g. '1174_1177'
  // This MUST match Laravel's room ID generation exactly.
  static String getSessionId(String userId) {
    final myRaw = userDataNotifier.value!.userId.toString().replaceAll('user_', '');
    final otherRaw = userId.replaceAll('user_', '');
    final myIdInt = int.tryParse(myRaw) ?? myRaw.hashCode;
    final otherIdInt = int.tryParse(otherRaw) ?? otherRaw.hashCode;
    if (myIdInt < otherIdInt) {
      return '${myIdInt}_$otherIdInt';
    } else {
      return '${otherIdInt}_$myIdInt';
    }
  }

  // ── Verify & Init Chat ──────────────────────────────────────────────────────
  // Explicit guide_id and student_id to prevent role-swap bugs.
  Future<bool> verifyAndInitializeChat({
    required int guideId,
    required int studentId,
  }) async {
    print('🔵 [CHAT] verifyAndInitializeChat — guideId=$guideId studentId=$studentId');
    try {
      final rawResponse = await http.post(
        Uri.parse(ApiUrls.verifyAndInitChat),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (userToken != null) 'Authorization': 'Bearer $userToken',
        },
        body: jsonEncode({
          'guide_id': guideId,
          'student_id': studentId,
        }),
      );
      print('🔵 [CHAT] status=${rawResponse.statusCode} body=${rawResponse.body}');

      final Map<String, dynamic> json = jsonDecode(rawResponse.body);
      final dynamic rawStatus = json['status'];
      final bool eligible =
          rawStatus == true || rawStatus == 1 || rawStatus?.toString() == '1';
      print('🔵 [CHAT] eligible=$eligible');
      return eligible;
    } catch (e, st) {
      print('🔴 [CHAT] verifyAndInitializeChat ERROR: $e\n$st');
      return false;
    }
  }

  // ── Active User Status ──────────────────────────────────────────────────────
  // Called when user opens (isActive=true) or leaves (isActive=false) chat.
  // When opening: also clears unread count for that user.
  Future<void> setUserActiveStatus(String otherUserId, bool isActive) async {
    final myId = userDataNotifier.value!.userId.toString();
    final roomId = getSessionId(otherUserId);
    try {
      final Map<String, dynamic> update = {
        'active_user_$myId': isActive,
      };
      if (isActive) {
        update['unread_count_$myId'] = 0;
      }
      await FirebaseCollections.chatsCollection
          .doc(roomId)
          .set(update, SetOptions(merge: true));
      print('🟢 [CHAT] active_user_$myId set to $isActive in room $roomId');
    } catch (e) {
      print('🟡 [CHAT] setUserActiveStatus failed: $e');
    }
  }

  // ── Unread Count (for badge) ─────────────────────────────────────────────
  Stream<QuerySnapshot> getUnreadChatCount() {
    final myIdInt = int.tryParse(
            userDataNotifier.value!.userId.toString()) ??
        userDataNotifier.value!.userId;
    return FirebaseCollections.chatsCollection
        .where('participants', arrayContains: myIdInt)
        .where('unread_count_${userDataNotifier.value!.userId}', isGreaterThan: 0)
        .snapshots();
  }

  // ── Chat Stream ─────────────────────────────────────────────────────────────
  Stream<QuerySnapshot> getIndividualChatStream(String userId) {
    return FirebaseCollections.chatsCollection
        .doc(getSessionId(userId))
        .collection('messages')
        .snapshots();
  }

  // ── Send Message ────────────────────────────────────────────────────────────
  Future<void> sendMessage(
    ChatModal message, {
    required Map otherUserObject,
    required bool isBlocked,
    String messageType = MessageType.text,
    List deviceIdList = const [],
  }) async {
    final myIdInt  = int.tryParse(message.from) ?? message.from;
    final toIdInt  = int.tryParse(message.to)   ?? message.to;
    final roomId   = getSessionId(message.to);

    // ── 1. Check if receiver is currently active in the chat ──────────────────
    bool receiverIsActive = false;
    try {
      final roomSnap = await FirebaseCollections.chatsCollection.doc(roomId).get();
      if (roomSnap.exists) {
        final roomData = roomSnap.data() as Map<String, dynamic>;
        receiverIsActive = roomData['active_user_${message.to}'] == true;
      }
    } catch (e) {
      print('🟡 [MSG] Could not read receiver active status: $e');
    }

    // ── 2. Build room-level update ─────────────────────────────────────────────
    // Use the field names that match Laravel: last_message, last_updated
    final Map<String, dynamic> roomUpdate = {
      'participants': [myIdInt, toIdInt],  // integers — matches Laravel
      'last_message': message.message,
      'last_updated': FieldValue.serverTimestamp(),
    };

    // Only increment unread if receiver is NOT currently viewing the chat
    if (!receiverIsActive) {
      roomUpdate['unread_count_${message.to}'] = FieldValue.increment(1);
    }

    print('🟢 [MSG] roomId=$roomId receiverActive=$receiverIsActive');

    try {
      await FirebaseCollections.chatsCollection
          .doc(roomId)
          .set(roomUpdate, SetOptions(merge: true))
          .timeout(const Duration(seconds: 15));
      print('🟢 [MSG] Room document updated');
    } catch (e) {
      print('🔴 [MSG] Room update failed: $e');
      rethrow;
    }

    // ── 3. Add message document ────────────────────────────────────────────────
    // Field names match Laravel: senderId (string), text, timestamp
    try {
      await FirebaseCollections.chatsCollection
          .doc(roomId)
          .collection('messages')
          .add(message.toJson())
          .timeout(const Duration(seconds: 15));
      print('🟢 [MSG] Message document added');
    } catch (e) {
      print('🔴 [MSG] Failed to add message document: $e');
      rethrow;
    }

    // ── 4. Send notification via Laravel (not direct FCM) ─────────────────────
    if (deviceIdList.isNotEmpty && !isBlocked) {
      try {
        await http.post(
          Uri.parse(ApiUrls.sendChatNotification),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (userToken != null) 'Authorization': 'Bearer $userToken',
          },
          body: jsonEncode({
            'receiver_id': message.to,
            'sender_name': userDataNotifier.value?.firstName ?? '',
            'message': _getNotificationText(message),
            'type': 'chat',
          }),
        ).timeout(const Duration(seconds: 10));
        print('🟢 [NOTIFY] Laravel notification sent');
      } catch (e) {
        print('🟡 [NOTIFY] Laravel notification failed (non-critical): $e');
      }
    }
  }

  static String _getNotificationText(ChatModal message) {
    switch (message.messageType) {
      case MessageType.image:   return 'Sent you an image';
      case MessageType.video:   return 'Sent you a video';
      case MessageType.location:return 'Sent you a location';
      default:                  return message.message;
    }
  }

  // ── Delete Message (soft-delete via visibleTo) ──────────────────────────────
  deleteMessage({
    required ChatModal message,
    required String messageId,
  }) async {
    final userId = message.from == userDataNotifier.value!.userId.toString()
        ? message.to
        : message.from;
    final documentSnapshot = await FirebaseCollections.chatsCollection
        .doc(getSessionId(userId))
        .collection('messages')
        .doc(messageId)
        .get();
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
    final List visibleTo = data['visibleTo'] ?? [];
    if (visibleTo.contains(userDataNotifier.value!.userId)) {
      visibleTo.remove(userDataNotifier.value!.userId);
      if (visibleTo.isEmpty) {
        documentSnapshot.reference.delete();
      } else {
        data['visibleTo'] = visibleTo;
        documentSnapshot.reference.update(data);
      }
    }
  }
}
