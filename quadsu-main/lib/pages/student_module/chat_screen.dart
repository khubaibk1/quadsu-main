import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/message_type.dart';
import 'package:quadsu_app/modal/chat_modal.dart';
import 'package:quadsu_app/services/firebase_services/firebase_chat_services.dart';
import 'package:quadsu_app/services/firebase_services/firebase_collections.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherUserImage;
  final Map<String, dynamic> otherUserData;
  final List deviceTokens;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserData,
    this.deviceTokens = const [],
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver {
  // ── Design tokens (exact from design) ──────────────────────────────────────
  static const Color _headerBlue   = Color(0xFF273196); // AppBar background
  static const Color _darkNavy     = Color(0xFF0D1B4B); // Sent bubble bg
  static const Color _receivedBg   = Color(0xFFEBEBEF); // Received bubble bg
  static const Color _receivedText = Color(0xFF0D1B4B); // Received bubble text
  static const Color _sentText     = Colors.white;       // Sent bubble text
  static const Color _orange       = Color(0xFFFF6600); // Send btn + double-tick
  static const Color _pageBg       = Color(0xFFF2F2F7); // Screen background
  static const Color _timestampClr = Color(0xFFA0A7B8); // Timestamp text
  static const Color _plusIconClr  = Color(0xFF8E9BB8); // + button border/icon
  static const Color _inputBg      = Color(0xFFE8E8EE); // Text field background
  static const Color _barBg        = Color(0xFFFFFFFF); // Bottom bar background
  static const Color _hintClr      = Color(0xFFA9B2C3); // Placeholder text

  // ───────────────────────────────────────────────────────────────────────────

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseChatServices _chatServices = FirebaseChatServices();
  bool _isSending = false;
  late Stream<QuerySnapshot> _chatStream;

  String get _currentUserId => userDataNotifier.value!.userId.toString();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final roomId = FirebaseChatServices.getSessionId(widget.otherUserId);
    print('🔵 [CHAT] myId=${userDataNotifier.value!.userId} otherUserId=${widget.otherUserId} → roomId=$roomId');
    
    // Direct debug fetch to see what exists in Firestore
    FirebaseCollections.chatsCollection
        .doc(roomId)
        .collection('messages')
        .get()
        .then((snap) {
      print('🔵 [CHAT DEBUG] Found ${snap.docs.length} messages in Firestore for room $roomId');
      for (var doc in snap.docs) {
        print('   - Doc ID: ${doc.id} => Data: ${doc.data()}');
      }
    }).catchError((err) {
      print('🔴 [CHAT DEBUG] Failed direct fetch: $err');
    });

    _chatStream = _chatServices.getIndividualChatStream(widget.otherUserId);
    // Mark user as active — clears unread count and sets active flag
    _chatServices.setUserActiveStatus(widget.otherUserId, true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Mark user as inactive when they leave the chat
    _chatServices.setUserActiveStatus(widget.otherUserId, false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _chatServices.setUserActiveStatus(widget.otherUserId, true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _chatServices.setUserActiveStatus(widget.otherUserId, false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();

    try {
      final message = ChatModal(
        from: _currentUserId,
        to: widget.otherUserId,
        message: text,
        messageType: MessageType.text,
        createdAt: DateTime.now().toIso8601String(),
        visibleTo: [
          userDataNotifier.value!.userId,
          int.tryParse(widget.otherUserId) ?? widget.otherUserId,
        ],
      );

      print('🟢 [MSG] Sending from=${message.from} to=${message.to} visibleTo=${message.visibleTo}');
      print('🟢 [MSG] otherUserData=${widget.otherUserData}');
      print('🟢 [MSG] currentUserFullData=${userDataNotifier.value!.fullData?.keys.toList()}');

      await _chatServices.sendMessage(
        message,
        otherUserObject: widget.otherUserData,
        isBlocked: false,
        deviceIdList: widget.deviceTokens,
      );

      print('🟢 [MSG] sendMessage completed successfully');
    } catch (e, st) {
      print('🔴 [MSG] sendMessage ERROR: $e');
      print('🔴 [MSG] STACK: $st');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  //  • Deep blue background
  //  • Back arrow  |  circular avatar  |  bold name
  //  • NO subtitle, NO more_vert icon, NO colored underline
  Widget _buildHeader() {
    return Container(
      color: _headerBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Circular avatar
          _buildHeaderAvatar(),
          const SizedBox(width: 10),

          // Name only — NO subtitle
          Text(
            widget.otherUserName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAvatar() {
    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: widget.otherUserImage.isNotEmpty
            ? Image.network(
                widget.otherUserImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _avatarFallback(size: 40),
              )
            : _avatarFallback(size: 40),
      ),
    );
  }

  Widget _avatarFallback({double size = 40}) {
    return Container(
      width: size,
      height: size,
      color: Colors.white24,
      alignment: Alignment.center,
      child: Text(
        widget.otherUserName.isNotEmpty
            ? widget.otherUserName[0].toUpperCase()
            : 'U',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  // ── Message list ────────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('🔴 [CHAT] Stream error: ${snapshot.error}');
          return Center(
            child: Text(
              'Error loading messages: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: _headerBlue),
          );
        }

        final rawDocs = List<QueryDocumentSnapshot>.from(snapshot.data?.docs ?? []);
        
        // Sort rawDocs oldest to newest
        rawDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          
          DateTime aDate = DateTime.fromMillisecondsSinceEpoch(0);
          DateTime bDate = DateTime.fromMillisecondsSinceEpoch(0);
          
          try {
            if (aData['timestamp'] is Timestamp) {
              aDate = (aData['timestamp'] as Timestamp).toDate();
            } else if (aData['timestamp'] is String && aData['timestamp'].isNotEmpty) {
              aDate = DateTime.parse(aData['timestamp']);
            } else if (aData['createdAt'] is String && aData['createdAt'].isNotEmpty) {
              aDate = DateTime.parse(aData['createdAt']);
            }
          } catch (_) {}
          
          try {
            if (bData['timestamp'] is Timestamp) {
              bDate = (bData['timestamp'] as Timestamp).toDate();
            } else if (bData['timestamp'] is String && bData['timestamp'].isNotEmpty) {
              bDate = DateTime.parse(bData['timestamp']);
            } else if (bData['createdAt'] is String && bData['createdAt'].isNotEmpty) {
              bDate = DateTime.parse(bData['createdAt']);
            }
          } catch (_) {}
          
          return aDate.compareTo(bDate);
        });
        
        // Invert for reverse: true list view (newest first at index 0)
        final docs = rawDocs.reversed.toList();

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.waving_hand_rounded,
                    size: 48, color: Colors.amber[400]),
                const SizedBox(height: 12),
                Text(
                  'Say hi to ${widget.otherUserName}!',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          reverse: true,
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final isMe = (data['senderId'] ?? data['from']).toString() == _currentUserId;
            final text = data['text'] ?? data['message'] ?? '';
            final time = _formatTime(data['timestamp'] ?? data['createdAt']);
            final isLastMsg = index == 0;

            return _buildMessageItem(
              text: text,
              isMe: isMe,
              time: time,
              isLastMsg: isLastMsg,
            );
          },
        );
      },
    );
  }

  // ── Single message row ──────────────────────────────────────────────────────
  //  Design:  bubble (no tail) + timestamp centered below
  Widget _buildMessageItem({
    required String text,
    required bool isMe,
    required String time,
    required bool isLastMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bubble — aligned to left or right
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: _buildBubble(text, isMe),
          ),

          const SizedBox(height: 4),

          // Timestamp row — always centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: _timestampClr,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bubble ──────────────────────────────────────────────────────────────────
  //  Both received and sent: fully-rounded corners (radius 16)
  //  Max width 75% of screen
  Widget _buildBubble(String text, bool isMe) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? _darkNavy : _receivedBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isMe ? _sentText : _receivedText,
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ── Input bar ───────────────────────────────────────────────────────────────
  //  Design:
  //    [+]  [     Type a message...     ]  [● send.svg]
  //  • + icon: thin gray circle, ~34px diameter
  //  • Text field: rounded, light gray bg
  //  • Send button: orange filled circle, ~44px, send.svg icon centered
  Widget _buildInputBar() {
    return Container(
      color: _barBg,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── + button ──
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _plusIconClr, width: 1.5),
              ),
              child: const Icon(Icons.add, size: 18, color: _plusIconClr),
            ),

            const SizedBox(width: 10),

            // ── Text field ──
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 110),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    color: _darkNavy,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: _hintClr, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ── Send button — orange circle with send.svg ──
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(11),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(11),
                        child: SvgPicture.asset(
                          'assets/icons/send.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Format datetime to "10:24 AM" (12-hour with AM/PM)
  String _formatTime(dynamic dateVal) {
    if (dateVal == null || dateVal.toString().isEmpty) return '';
    try {
      DateTime dt;
      if (dateVal is Timestamp) {
        dt = dateVal.toDate().toLocal();
      } else if (dateVal is int) {
        dt = DateTime.fromMillisecondsSinceEpoch(dateVal).toLocal();
      } else {
        dt = DateTime.parse(dateVal.toString()).toLocal();
      }
      
      final hour = dt.hour == 0
          ? 12
          : dt.hour > 12
              ? dt.hour - 12
              : dt.hour;
      final min = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:$min $period';
    } catch (_) {
      return '';
    }
  }
}
