import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF252F96),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFEFEFF2),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const ExactChatApp());
}

class ExactChatApp extends StatelessWidget {
  const ExactChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messages UI',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      ),
      home: const MessagesScreen(),
    );
  }
}

class ChatContact {
  final String name;
  final String preview;
  final String time;
  final String avatar;
  final int unread;
  final bool activeRing;

  const ChatContact({
    required this.name,
    required this.preview,
    required this.time,
    required this.avatar,
    this.unread = 0,
    this.activeRing = false,
  });
}

const Color topBlue = Color(0xFF273196);
const Color darkNavy = Color(0xFF001F4B);
const Color orange = Color(0xFFFF6600);
const Color pageBg = Color(0xFFF8F7FC);
const Color cardBorder = Color(0xFFF0EFF7);
const Color faintText = Color(0xFF9EA7B8);

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static const contacts = <ChatContact>[
    ChatContact(
      name: 'Alex Rivera',
      preview: 'Looking forward to our session!',
      time: '10:30 AM',
      avatar: 'assets/avatars/alex.png',
      unread: 2,
      activeRing: true,
    ),
    ChatContact(
      name: 'Sarah Chen',
      preview: 'Did you check the new assignme',
      time: '10:30 AM',
      avatar: 'assets/avatars/sarah.png',
    ),
    ChatContact(
      name: 'Dr. Marcus Jordan',
      preview: 'The research paper draft is excel',
      time: '10:30 AM',
      avatar: 'assets/avatars/marcus.png',
      unread: 1,
      activeRing: true,
    ),
    ChatContact(
      name: 'Elena Rodriguez',
      preview: 'Thanks for the help today!',
      time: '10:30 AM',
      avatar: 'assets/avatars/elena.png',
    ),
    ChatContact(
      name: 'Cs 101 Study Group',
      preview: 'jordan: Let’s meet at the library.',
      time: '10:30 AM',
      avatar: 'assets/avatars/group.png',
    ),
    ChatContact(
      name: 'Tyler Vance',
      preview: 'See you at the gym later?',
      time: 'Tuesday',
      avatar: 'assets/avatars/tyler.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final s = w / 305.0;
          double px(double v) => v * s;
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: px(67),
                    color: topBlue,
                    child: Stack(
                      children: [
                        Positioned(
                          left: px(15),
                          top: px(27),
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: px(21)),
                        ),
                        Positioned.fill(
                          top: px(21),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Messages',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: px(16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          left: px(16),
                          top: px(20),
                          right: px(18),
                          child: Container(
                            height: px(34),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EFF4),
                              borderRadius: BorderRadius.circular(px(10)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: px(11)),
                                Icon(Icons.search_rounded,
                                    size: px(17), color: const Color(0xFF8A8F9F)),
                                SizedBox(width: px(10)),
                                Text(
                                  'Search messages...',
                                  style: TextStyle(
                                    color: const Color(0xFF5F677A),
                                    fontSize: px(12),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: px(15),
                          top: px(73),
                          child: Container(
                            height: px(30),
                            padding: EdgeInsets.symmetric(horizontal: px(15)),
                            decoration: BoxDecoration(
                              color: darkNavy,
                              borderRadius: BorderRadius.circular(px(18)),
                            ),
                            child: Center(
                              child: Text(
                                'All Chats',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: px(11),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: px(91),
                          top: px(73),
                          child: Container(
                            height: px(30),
                            padding: EdgeInsets.symmetric(horizontal: px(15)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFCDD2DF), width: px(1)),
                              borderRadius: BorderRadius.circular(px(18)),
                            ),
                            child: Center(
                              child: Text(
                                'Unread (2)',
                                style: TextStyle(
                                  color: const Color(0xFF515A70),
                                  fontSize: px(11),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: px(123),
                          bottom: px(69),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: contacts.length,
                            itemBuilder: (_, index) {
                              return ContactTile(
                                contact: contacts[index],
                                scale: s,
                                onTap: index == 0
                                    ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const ChatScreen()),
                                        )
                                    : null,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: px(97),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.archive_outlined,
                                  size: px(12), color: const Color(0xFF7182BD)),
                              SizedBox(width: px(7)),
                              Text(
                                'VIEW ARCHIVED CHATS',
                                style: TextStyle(
                                  color: const Color(0xFF7182BD),
                                  fontSize: px(9),
                                  letterSpacing: px(1.7),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: px(7),
                          bottom: px(58),
                          child: Container(
                            width: px(46),
                            height: px(46),
                            decoration: const BoxDecoration(
                              color: orange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4)),
                              ],
                            ),
                            child: Icon(Icons.add_rounded, color: Colors.white, size: px(28)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomNav(scale: s),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final ChatContact contact;
  final double scale;
  final VoidCallback? onTap;
  const ContactTile({super.key, required this.contact, required this.scale, this.onTap});

  double px(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: px(15), right: px(20), bottom: px(5)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: px(58),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.80),
            borderRadius: BorderRadius.circular(px(10)),
            border: Border.all(color: cardBorder, width: px(1)),
            boxShadow: const [
              BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 1)),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: px(14)),
              AvatarCircle(contact: contact, size: px(39), scale: scale),
              SizedBox(width: px(10)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: px(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: darkNavy,
                          fontSize: px(14),
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: px(8)),
                      Text(
                        contact.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: faintText,
                          fontSize: px(10),
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: px(7)),
              Padding(
                padding: EdgeInsets.only(top: px(13), right: px(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      contact.time,
                      style: TextStyle(
                        color: contact.unread > 0 ? orange : const Color(0xFF9BA2B2),
                        fontSize: px(8.2),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (contact.unread > 0) ...[
                      SizedBox(height: px(7)),
                      Container(
                        width: px(14),
                        height: px(14),
                        decoration: const BoxDecoration(color: orange, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '${contact.unread}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: px(8),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final ChatContact contact;
  final double size;
  final double scale;
  const AvatarCircle({super.key, required this.contact, required this.size, required this.scale});

  double px(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    if (contact.name.contains('Study Group')) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Color(0xFFE8EDF5), shape: BoxShape.circle),
        child: Icon(Icons.groups_rounded, color: const Color(0xFF8B9AAA), size: px(21)),
      );
    }
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(contact.activeRing ? px(2) : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: contact.activeRing ? Border.all(color: orange, width: px(2)) : null,
      ),
      child: ClipOval(
        child: Image.asset(contact.avatar, fit: BoxFit.cover),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final double scale;
  const BottomNav({super.key, required this.scale});
  double px(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(57),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F3),
        border: Border(top: BorderSide(color: Color(0xFFE3E3EA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(Icons.home_outlined, false),
          Container(
            width: px(38),
            height: px(38),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 7, offset: Offset(0, 2))],
            ),
            child: Icon(Icons.chat_bubble_outline_rounded, size: px(20), color: topBlue),
          ),
          _navIcon(Icons.favorite_border_rounded, false),
          _navIcon(Icons.calendar_month_outlined, false),
          _navIcon(Icons.person_outline_rounded, true),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, bool light) {
    return Icon(icon, size: px(22), color: light ? const Color(0xFF8E94CA) : topBlue);
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final s = w / 297.0;
        double px(double v) => v * s;
        return Column(
          children: [
            Container(
              height: px(60),
              color: topBlue,
              child: Stack(
                children: [
                  Positioned(
                    left: px(9),
                    top: px(21),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: px(19)),
                    ),
                  ),
                  Positioned(
                    left: px(35),
                    top: px(13),
                    child: ClipOval(
                      child: Image.asset('assets/avatars/alex.png', width: px(36), height: px(36), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    left: px(82),
                    top: px(22),
                    child: Text(
                      'Alex Rivera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: px(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: px(3), color: const Color(0xFF1EA4FF)),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: px(9), right: px(10), top: px(17),
                    child: MessageBubble(
                      text: 'Hi there! I’ve reviewed your latest research\nproposal for the Quads U project. Have\nyou considered the impact of AI on the student\nfeedback loop?',
                      dark: false,
                      scale: s,
                    ),
                  ),
                  Positioned(
                    left: px(9), top: px(124),
                    child: Text('10:24 AM', style: TextStyle(color: faintText, fontSize: px(9), fontWeight: FontWeight.w600)),
                  ),
                  Positioned(
                    left: px(9), right: px(10), top: px(138),
                    child: MessageBubble(
                      text: 'That’s a great point, Alex. I was planning to\nintegrate a sentiment analysis module\nto capture that specific data point.',
                      dark: true,
                      scale: s,
                    ),
                  ),
                  Positioned(
                    left: px(127), top: px(209),
                    child: Text('10:26 AM', style: TextStyle(color: faintText, fontSize: px(9), fontWeight: FontWeight.w600)),
                  ),
                  Positioned(
                    left: px(9), right: px(10), top: px(228),
                    child: MessageBubble(
                      text: 'Perfect. If you can have the wireframes ready\nby Thursday, we can present them\nduring our scheduled meeting.',
                      dark: false,
                      scale: s,
                    ),
                  ),
                  Positioned(
                    left: px(127), top: px(301),
                    child: Text('10:28 AM', style: TextStyle(color: faintText, fontSize: px(9), fontWeight: FontWeight.w600)),
                  ),
                  Positioned(
                    left: px(9), right: px(10), top: px(321),
                    child: MessageBubble(
                      text: 'Will do! I’ll also bring the initial dataset for the\npilot run.',
                      dark: true,
                      scale: s,
                    ),
                  ),
                  Positioned(
                    right: px(11), top: px(380),
                    child: Row(
                      children: [
                        Text('10:30 AM', style: TextStyle(color: faintText, fontSize: px(9), fontWeight: FontWeight.w600)),
                        SizedBox(width: px(3)),
                        Text('✓✓', style: TextStyle(color: orange, fontSize: px(9), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0, right: 0, top: px(405),
                    child: Container(height: px(2), color: const Color(0xFF1EA4FF)),
                  ),
                  Positioned(
                    left: 0, right: 0, top: px(415),
                    child: Center(
                      child: Container(
                        height: px(22),
                        padding: EdgeInsets.symmetric(horizontal: px(7)),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E9AEE),
                          borderRadius: BorderRadius.circular(px(3)),
                        ),
                        child: Center(
                          child: Text('375 × 500', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: px(13))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ChatInputBar(scale: s),
          ],
        );
      }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool dark;
  final double scale;
  const MessageBubble({super.key, required this.text, required this.dark, required this.scale});
  double px(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: px(14), right: px(12), top: px(14), bottom: px(13)),
      decoration: BoxDecoration(
        color: dark ? darkNavy : const Color(0xFFE6E5EB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(px(8)),
          topRight: Radius.circular(px(8)),
          bottomLeft: dark ? Radius.circular(px(8)) : Radius.zero,
          bottomRight: dark ? Radius.zero : Radius.circular(px(8)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: dark ? Colors.white : darkNavy,
          fontSize: px(12),
          height: 1.42,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  final double scale;
  const ChatInputBar({super.key, required this.scale});
  double px(double v) => v * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(48),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F3),
        border: Border(top: BorderSide(color: Color(0xFFE0E0E9))),
      ),
      child: Row(
        children: [
          SizedBox(width: px(6)),
          Container(
            width: px(17), height: px(17),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF91A3C0), width: px(1.5))),
            child: Icon(Icons.add, size: px(13), color: const Color(0xFF91A3C0)),
          ),
          SizedBox(width: px(10)),
          Expanded(
            child: Container(
              height: px(32),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E5EA),
                borderRadius: BorderRadius.circular(px(17)),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: px(17)),
              child: Text(
                'Type a message...',
                style: TextStyle(color: const Color(0xFFAEB5C3), fontSize: px(12)),
              ),
            ),
          ),
          SizedBox(width: px(9)),
          Container(
            width: px(34), height: px(34),
            decoration: const BoxDecoration(color: orange, shape: BoxShape.circle),
            child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: px(24)),
          ),
          SizedBox(width: px(6)),
        ],
      ),
    );
  }
}
