import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/services/firebase_services/firebase_collections.dart';
import 'package:quadsu_app/pages/student_module/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/provider/student_guide_provider.dart';
import 'package:quadsu_app/modal/user_modal.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // ── Design tokens (pixel-perfect from design) ──────────────────────────────
  static const Color _headerBlue   = Color(0xFF273196); // Header background
  static const Color _darkNavy     = Color(0xFF0D1B4B); // Names, active chip
  static const Color _orange       = Color(0xFFFF6600); // Unread badge, time, FAB, avatar ring
  static const Color _pageBg       = Color(0xFFF2F2F7); // Screen background
  static const Color _faintText    = Color(0xFF9EA7B8); // Preview text, gray time
  static const Color _searchBg     = Color(0xFFEEEEF3); // Search bar background
  static const Color _searchIcon   = Color(0xFF9EA7B8); // Search icon color
  static const Color _searchHint   = Color(0xFF9EA7B8); // Hint text color
  static const Color _divider      = Color(0xFFEEEEF3); // Row divider
  static const Color _archiveColor = Color(0xFF5B7CF6); // Archive link color
  // ───────────────────────────────────────────────────────────────────────────

  String _filter = 'all'; // 'all' | 'unread'
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  late Stream<QuerySnapshot> _roomsStream;

  String get _currentUserId => userDataNotifier.value!.userId.toString();

  @override
  void initState() {
    super.initState();
    final myId = userDataNotifier.value!.userId;
    final myIdInt = int.tryParse(myId.toString());
    print('🔵 [INBOX] userId=$myId type=${myId.runtimeType} intParsed=$myIdInt');

    // Query with both integer and string to support mixed type rooms in Firestore
    final List<dynamic> queryIds = [];
    if (myIdInt != null) {
      queryIds.add(myIdInt);
    }
    queryIds.add(myId.toString());

    _roomsStream = FirebaseCollections.chatsCollection
        .where('participants', arrayContainsAny: queryIds)
        .snapshots();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
    // Fetch guides/students list from Laravel API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentGuideProvider>(context, listen: false).getStudentGuide();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      // floatingActionButton: _buildFab(), // TODO: connect to new chat flow
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header (blue bar) ──────────────────────────────────────────
            _buildHeader(),

            // ── Search Bar (on page bg, below header) ─────────────────────
            _buildSearchBar(),

            // ── Filter Chips ──────────────────────────────────────────────
            _buildFilterRow(),

            // ── Chat List ─────────────────────────────────────────────────
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  // Design: deep blue, back arrow left, "Messages" centered, nothing on right
  Widget _buildHeader() {
    return Container(
      color: _headerBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back arrow — left-aligned
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          // Title — centered
          const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  // Design: full-width pill, light gray bg, 🔍 on left, "Search messages..." hint
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _searchBg,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, size: 20, color: _searchIcon),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(
                  color: _darkNavy,
                  fontSize: 14,
                  height: 1.2,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(color: _searchHint, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  // ── Filter Row ─────────────────────────────────────────────────────────────
  // Design: "All Chats" filled navy pill | "Unread (2)" outline pill
  Widget _buildFilterRow() {
    return StreamBuilder<QuerySnapshot>(
      stream: _roomsStream,
      builder: (context, snap) {
        int totalUnread = 0;
        if (snap.hasData) {
          for (var doc in snap.data!.docs) {
            final d = doc.data() as Map<String, dynamic>;
            final unreadVal = d['unread_count_$_currentUserId'] ?? d['unreadCount_$_currentUserId'] ?? 0;
            totalUnread += (unreadVal as num).toInt();
          }
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              _filterChip(label: 'All Chats', value: 'all'),
              const SizedBox(width: 10),
              _filterChip(
                label: totalUnread > 0 ? 'Unread ($totalUnread)' : 'Unread',
                value: 'unread',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip({required String label, required String value}) {
    final bool selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _darkNavy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _darkNavy : const Color(0xFFCDD2DF),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _darkNavy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Chat List ──────────────────────────────────────────────────────────────
  Widget _buildChatList() {
    return Consumer<StudentGuideProvider>(
      builder: (context, studentGuideProvider, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: _roomsStream,
          builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: _headerBlue),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty();
        }

        // Sort by updatedAt descending (most recent first)
        final docs = List.from(snapshot.data!.docs);
        docs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          
          DateTime aDate = DateTime.fromMillisecondsSinceEpoch(0);
          DateTime bDate = DateTime.fromMillisecondsSinceEpoch(0);
          
          try {
            if (aData['last_updated'] is Timestamp) {
              aDate = (aData['last_updated'] as Timestamp).toDate();
            } else if (aData['updatedAt'] is Timestamp) {
              aDate = (aData['updatedAt'] as Timestamp).toDate();
            } else if (aData['updatedAt'] is String && aData['updatedAt'].isNotEmpty) {
              aDate = DateTime.parse(aData['updatedAt']);
            }
          } catch (_) {}
          
          try {
            if (bData['last_updated'] is Timestamp) {
              bDate = (bData['last_updated'] as Timestamp).toDate();
            } else if (bData['updatedAt'] is Timestamp) {
              bDate = (bData['updatedAt'] as Timestamp).toDate();
            } else if (bData['updatedAt'] is String && bData['updatedAt'].isNotEmpty) {
              bDate = DateTime.parse(bData['updatedAt']);
            }
          } catch (_) {}
          
          return bDate.compareTo(aDate);
        });

        // Filter by unread if needed
        var filtered = _filter == 'unread'
            ? docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final unreadVal = d['unread_count_$_currentUserId'] ?? d['unreadCount_$_currentUserId'] ?? 0;
                return (unreadVal as num).toInt() > 0;
              }).toList()
            : docs;

        // Apply search query
        if (_searchQuery.isNotEmpty) {
          filtered = filtered.where((doc) {
            final d = doc.data() as Map<String, dynamic>;
            final List users = d['participants'] ?? d['users'] ?? [];
            final String otherId = users.firstWhere(
              (u) => u.toString() != _currentUserId,
              orElse: () => '',
            ).toString();
            
            UserModal? matchedUser;
            for (final u in studentGuideProvider.studentGuides) {
              if (u.userId.toString() == otherId) {
                matchedUser = u;
                break;
              }
            }

            final String name;
            if (matchedUser != null) {
              name = '${matchedUser.firstName} ${matchedUser.lastName}'.toLowerCase();
            } else {
              final Map otherData = d[otherId] ?? {};
              name = '${otherData['first_name'] ?? ''} ${otherData['last_name'] ?? ''}'
                  .toLowerCase();
            }

            final String msg =
                (d['last_message'] ?? d['lastMessage'] ?? '').toString().toLowerCase();
            return name.contains(_searchQuery) || msg.contains(_searchQuery);
          }).toList();
        }

        if (filtered.isEmpty) {
          return _buildEmpty(
            message: _filter == 'unread' ? 'No unread messages' : 'No results',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final data = filtered[index].data() as Map<String, dynamic>;
            return _buildChatTile(context, data, studentGuideProvider);
          },
        );
      },
    );
      },
    );
  }

  // ── Chat Tile ──────────────────────────────────────────────────────────────
  // Design: full-width row on white bg, thin bottom divider, no card shadow
  Widget _buildChatTile(BuildContext context, Map<String, dynamic> data, StudentGuideProvider studentGuideProvider) {
    final List users = data['participants'] ?? data['users'] ?? [];
    final String otherUserId = users.firstWhere(
      (u) => u.toString() != _currentUserId,
      orElse: () => '',
    ).toString();

    if (otherUserId.isEmpty) return const SizedBox();

    UserModal? matchedUser;
    for (final u in studentGuideProvider.studentGuides) {
      if (u.userId.toString() == otherUserId) {
        matchedUser = u;
        break;
      }
    }

    final String firstName;
    final String lastName;
    final String imageUrl;
    final Map otherData;

    if (matchedUser != null) {
      firstName = matchedUser.firstName;
      lastName = matchedUser.lastName;
      imageUrl = matchedUser.guidePrefrence?.profileImage ??
                 matchedUser.studentPrefrence?.profileImage ??
                 '';
      otherData = matchedUser.fullData;
    } else {
      otherData = data[otherUserId] ?? {};
      firstName = otherData['first_name']?.toString() ?? '';
      lastName  = otherData['last_name']?.toString() ?? '';
      imageUrl  = _getProfileImage(otherData);
    }

    final String name      = '$firstName $lastName'.trim();
    final String lastMsg = (data['last_message'] ?? data['lastMessage'])?.toString() ?? '';
    final unreadVal = data['unread_count_$_currentUserId'] ?? data['unreadCount_$_currentUserId'] ?? 0;
    final int    unread    = (unreadVal as num).toInt();
    final String time      = _formatTime(data['last_updated'] ?? data['updatedAt']);
    final bool   hasUnread = unread > 0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            otherUserId:   otherUserId,
            otherUserName: name.isNotEmpty ? name : 'User',
            otherUserImage: imageUrl,
            otherUserData: Map<String, dynamic>.from(otherData),
          ),
        ),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Avatar with optional orange ring ──
                  _buildAvatar(imageUrl, name, hasUnread),
                  const SizedBox(width: 14),

                  // ── Name + message preview ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isNotEmpty ? name : 'User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _darkNavy,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasUnread ? _darkNavy : _faintText,
                            fontSize: 13,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // ── Time + unread badge (top-right) ──
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: hasUnread ? _orange : _faintText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(height: 5),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: _orange,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ] else
                        // Reserve height so rows stay same size
                        const SizedBox(height: 25),
                    ],
                  ),
                ],
              ),
            ),
            // Thin divider
            const Divider(height: 1, thickness: 1, color: _divider, indent: 0, endIndent: 0),
          ],
        ),
      ),
    );
  }

  // ── Avatar ─────────────────────────────────────────────────────────────────
  // Design: ~52px circle. Orange ring (2px + 2px padding) when unread.
  Widget _buildAvatar(String imageUrl, String name, bool hasUnread) {
    return Container(
      width: 54,
      height: 54,
      padding: hasUnread ? const EdgeInsets.all(2) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasUnread
            ? Border.all(color: _orange, width: 2.0)
            : null,
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _avatarFallback(name),
              )
            : _avatarFallback(name),
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      color: _headerBlue,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  // ── Archive Footer (hidden) ────────────────────────────────────────────────
  // Widget _buildArchiveFooter() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 24),
  //     child: Center(
  //       child: GestureDetector(
  //         onTap: () {}, // TODO: implement archive screen
  //         child: const Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(Icons.archive_outlined, size: 16, color: _archiveColor),
  //             SizedBox(width: 6),
  //             Text(
  //               'VIEW ARCHIVED CHATS',
  //               style: TextStyle(
  //                 color: _archiveColor,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w600,
  //                 letterSpacing: 0.5,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ── FAB (hidden - not connected yet) ────────────────────────────────────────
  // Widget _buildFab() {
  //   return FloatingActionButton(
  //     onPressed: () {}, // TODO: connect to new chat flow
  //     backgroundColor: _orange,
  //     elevation: 4,
  //     child: const Icon(Icons.add, color: Colors.white, size: 28),
  //   );
  // }

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmpty({String message = 'No Messages yet'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _headerBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 38,
              color: _headerBlue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              color: _darkNavy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Start a conversation with your favourite guides',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _faintText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _getProfileImage(Map data) {
    final gp = data['guide_prefrence'] ??
        data['tutor_preferences'] ??
        data['guide_preferences'];
    final sp = data['student_prefrence'] ?? data['student_preferences'];
    if (gp is Map && gp['profile_image'] != null) {
      return gp['profile_image'].toString();
    }
    if (sp is Map && sp['profile_image'] != null) {
      return sp['profile_image'].toString();
    }
    return data['profile_image']?.toString() ?? '';
  }

  /// Format: today → "10:30 AM", yesterday → "Yesterday", this week → "Tuesday", older → "12/6"
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
      
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(dt.year, dt.month, dt.day);
      final diff = today.difference(msgDay).inDays;

      if (diff == 0) {
        // Today: "10:30 AM"
        final h = dt.hour == 0 ? 12 : dt.hour > 12 ? dt.hour - 12 : dt.hour;
        final m = dt.minute.toString().padLeft(2, '0');
        final p = dt.hour < 12 ? 'AM' : 'PM';
        return '$h:$m $p';
      } else if (diff == 1) {
        return 'Yesterday';
      } else if (diff < 7) {
        const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        return days[dt.weekday - 1];
      } else {
        return '${dt.day}/${dt.month}';
      }
    } catch (_) {
      return '';
    }
  }
}
