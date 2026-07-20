import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/provider/guide_schedule_provider.dart';
import 'package:quadsu_app/modal/upcoming_booking_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sessionSlots.dart';

class BookingContent extends StatefulWidget {
  const BookingContent({Key? key}) : super(key: key);

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent> {
  // Exact Colors from the UI Mockup
  final Color primaryBlue = const Color(0xFF22328C);
  final Color backgroundGrey = const Color(0xFFF8F9FB);
  final Color textDark = const Color(0xFF1E293B);
  final Color textSlate = const Color(0xFF475569);
  final Color textLightGrey = const Color(0xFF94A3B8);
  final Color avatarBgColor = const Color(0xFFF1F5F9);

  // Status Colors
  final Color confirmedBg = const Color(0xFFDDFBEE);
  final Color confirmedText = const Color(0xFF0F8C43);
  final Color pendingBg = const Color(0xFFFFF3E0);
  final Color pendingText = const Color(0xFFFF9800);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GuideScheduleProvider>(context, listen: false)
          .fetchUpcomingBookings();
    });
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "S";
    List<String> names = name.split(" ");
    if (names.length > 1) {
      return (names[0][0] + names[1][0]).toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final time =
          DateTime(2022, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('hh:mm a').format(time);
    } catch (e) {
      return timeStr;
    }
  }

  bool _isPastDate(String dateStr) {
    try {
      final bookingDate = DateTime.parse(dateStr);
      final now = DateTime.now();
      final todayAtMidnight = DateTime(now.year, now.month, now.day);
      return bookingDate.isBefore(todayAtMidnight);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuideScheduleProvider>(
      builder: (context, provider, child) {
        if (provider.isUpcomingLoading &&
            (provider.upcomingBookingModel?.bookings ?? []).isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = provider.upcomingBookingModel?.bookings ?? [];

        if (bookings.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No upcoming sessions found."),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchUpcomingBookings(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: bookings.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingCard(
                context: context,
                status: booking.status.isEmpty
                    ? "Confirmed"
                    : booking.status[0].toUpperCase() +
                        booking.status.substring(1),
                bookingId: "#QX-${booking.bookId}",
                initials: _getInitials(booking.student?.fullName ?? ""),
                name: booking.student?.fullName ?? "Unknown Student",
                subject: booking.subject ?? "General Session",
                date: _formatDate(booking.date),
                time: _formatTime(booking.startTime),
                hasJoinButton: booking.meetingLink != null &&
                    booking.meetingLink!.isNotEmpty,
                isPast: _isPastDate(booking.date),
                meetingLink: booking.meetingLink,
              );
            },
          ),
        );
      },
    );
  }

  // --- CUSTOM WIDGETS ---

  Widget _buildBookingCard({
    required BuildContext context,
    required String status,
    required String bookingId,
    required String initials,
    required String name,
    required String subject,
    required String date,
    required String time,
    required bool hasJoinButton,
    required bool isPast,
    String? meetingLink,
  }) {
    bool isConfirmed = status == "Confirmed";
    bool canJoin = hasJoinButton && !isPast;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Booking ID and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking ID',
                    style: TextStyle(
                      color: textLightGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookingId,
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isConfirmed ? confirmedBg : pendingBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isConfirmed ? confirmedText : pendingText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // User Info Row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarBgColor,
                radius: 22,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Date and Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      color: textLightGrey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      color: textSlate,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: textLightGrey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: textSlate,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Conditional Join Meeting Button
          if (hasJoinButton) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: canJoin ? () async {
                if (meetingLink != null && meetingLink.isNotEmpty) {
                  final uri = Uri.parse(meetingLink);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              } : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: canJoin ? primaryBlue : Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Join Meeting',
                      style: TextStyle(
                        color: canJoin ? Colors.white : Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.videocam,
                      color: canJoin ? Colors.white : Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
