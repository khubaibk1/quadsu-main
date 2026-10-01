import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/session_model.dart';
import 'package:quadsu_app/pages/bottom_sheet/rating_sheet.dart';
import 'package:quadsu_app/pages/bottom_sheet/scheduled_details.dart';
import 'package:quadsu_app/pages/bottom_sheet/session_recordings.dart';
import 'package:quadsu_app/pages/student_module/guide_profile_screen.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/metting_services/meeting_video_call_screen.dart';
import 'package:quadsu_app/widget/app_specific/custom_drawer.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_rating.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';

import '../../functions/showCustomBottomSheet.dart';

/// Student sessions tab, in the same design as the guide's
/// "Availability & Schedule" screen. Uses the same data and actions as the
/// previous SessionScreen (join call, rating, recordings, details).
class StudentSessionsScreen extends StatefulWidget {
  /// Opens this booking's details once loaded (from a notification).
  final String? bookingId;

  const StudentSessionsScreen({super.key, this.bookingId});

  @override
  State<StudentSessionsScreen> createState() => _StudentSessionsScreenState();
}

class _StudentSessionsScreenState extends State<StudentSessionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  static const Color primaryBlue = Color(0xFF22328C);
  static const Color backgroundGrey = Color(0xFFF8F9FB);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textSlate = Color(0xFF475569);
  static const Color textLightGrey = Color(0xFF94A3B8);
  static const Color avatarBgColor = Color(0xFFF1F5F9);

  static const _tabs = [
    (label: 'All', status: SessionStatus.all),
    (label: 'Upcoming', status: SessionStatus.running),
    (label: 'Completed', status: SessionStatus.completed),
    (label: 'Cancelled', status: SessionStatus.cancelled),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<SessionsProvider>(context, listen: false);
      provider.allSessionsOffset = 1;
      await provider.getSession(sessionStatus: SessionStatus.all);
      if (!mounted) return;
      if (widget.bookingId != null) {
        final match = provider.allSessions
            .where((s) => s.bookingId.toString() == widget.bookingId);
        if (match.isNotEmpty) _showDetails(match.first);
      }
      provider.runningSessionsOffset = 1;
      provider.getSession(sessionStatus: SessionStatus.running);
      provider.completedSessionsOffset = 1;
      provider.getSession(sessionStatus: SessionStatus.completed);
      provider.cancelledSessionsOffset = 1;
      provider.getSession(sessionStatus: SessionStatus.cancelled);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'My Sessions',
        centerTitle: true,
        isNotificationIcon: true,
        isBackIcon: widget.bookingId != null,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: textLightGrey,
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              labelPadding: EdgeInsets.zero,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: [for (final t in _tabs) Tab(text: t.label)],
            ),
          ),
          Container(
            width: double.infinity,
            color: backgroundGrey,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: const Text(
              'All times in EST',
              style: TextStyle(
                  color: textLightGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Container(
              color: backgroundGrey,
              child: Consumer<SessionsProvider>(
                builder: (context, provider, child) => TabBarView(
                  controller: _tabController,
                  children: [
                    for (final t in _tabs) _buildList(provider, t.status),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(SessionsProvider provider, int status) {
    final (SessionModel? model, List<Session> list) = switch (status) {
      SessionStatus.running => (
          provider.runningSessionsModel,
          provider.runningSessions
        ),
      SessionStatus.completed => (
          provider.completedSessionsModel,
          provider.completedSessions
        ),
      SessionStatus.cancelled => (
          provider.cancelledSessionsModel,
          provider.canceledSessions
        ),
      _ => (provider.allSessionsModel, provider.allSessions),
    };

    Future<void> refresh() async {
      provider.resetOffset(sessionType: status);
      provider.changeSessionIsLast(sessionStatus: status);
      provider.changeSessionIsRefresh(sessionStatus: status);
      await provider.getSession(sessionStatus: status);
      provider.changeSessionIsRefresh(sessionStatus: status, value: false);
    }

    if (model == null) {
      // Still loading; the provider shows the loading overlay.
      return const SizedBox();
    }
    if (list.isEmpty) {
      final failed = provider.failedSessionStatuses.contains(status);
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            const SizedBox(height: 160),
            Center(
              child: Text(
                failed
                    ? "Couldn't load sessions. Pull down to try again."
                    : 'No sessions found.',
                style: TextStyle(
                    color: textSlate,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }
    return CustomPaginatedListView(
      onRefresh: refresh,
      onLoadMore: () async {
        provider.setOffset(sessionType: status);
        await provider.getSession(sessionStatus: status);
      },
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: list.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildSessionCard(provider, list[index]),
      ),
    );
  }

  Widget _buildSessionCard(SessionsProvider provider, Session session) {
    final guideName =
        '${session.guide?.firstName ?? ''} ${session.guide?.lastName ?? ''}'
            .trim();
    final speciality = session.guideData?.speciality ?? '';
    final imageUrl = session.guideData?.profileImage ?? '';
    final scheduled = session.scheduledSessions;
    final statusColor = SessionStatus.getColor(session.sessionStatus);
    final isCompleted = session.sessionStatus == SessionStatus.completed;
    final rating = scheduled?.rating ?? 0.0;
    final isCancelled = session.sessionStatus == SessionStatus.cancelled;
    // Google Meet link created for the booking (same as the guide's card).
    final meetLink = scheduled?.meetingLink ?? '';
    final hasMeetLink = meetLink.isNotEmpty && !isCancelled;
    final canOpenMeet = hasMeetLink && !_isPastDate(scheduled?.date ?? '');
    // Older bookings use the in-app video call instead.
    final canJoinInApp = meetLink.isEmpty &&
        session.meetingUrl.isNotEmpty &&
        session.sessionStatus == SessionStatus.pending;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking ID and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking ID',
                    style: TextStyle(
                        color: textLightGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#QX-${session.bookingId}',
                    style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  SessionStatus.getName(session.sessionStatus),
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Guide
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: session.guide?.id == null
                ? null
                : () => CustomNavigation.push(
                      context: context,
                      screen: GuideProfileScreen(guideId: session.guide!.id!),
                    ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: avatarBgColor,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? Text(
                          _initials(guideName),
                          style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guideName.isEmpty ? 'Guide' : guideName,
                        style: const TextStyle(
                            color: textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      if (speciality.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          speciality,
                          style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Date and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText(
                Icons.calendar_today_outlined,
                CustomTimeFunctions.convertDateFormat(scheduled?.date ?? ''),
              ),
              _iconText(
                Icons.access_time,
                '${CustomTimeFunctions.convertTo12HourFormat(scheduled?.startTime ?? '')}'
                ' - ${CustomTimeFunctions.convertTo12HourFormat(scheduled?.endTime ?? '')}',
              ),
            ],
          ),

          if (hasMeetLink) ...[
            const SizedBox(height: 20),
            _primaryButton(
              label: 'Join Meeting',
              icon: Icons.videocam,
              enabled: canOpenMeet,
              onTap: () async {
                final uri = Uri.tryParse(meetLink);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ] else if (canJoinInApp) ...[
            const SizedBox(height: 20),
            _primaryButton(
              label: 'Join Meeting',
              icon: Icons.videocam,
              onTap: () async {
                await CustomNavigation.push(
                  context: context,
                  screen: MeetingVideoCallScreen(
                    channelId: session.bookingId.toString(),
                    meetingTitle: 'Meeting',
                    isCreate: false,
                    meetingUrl: session.meetingUrl,
                  ),
                );
                _reloadAll(provider);
              },
            ),
          ],

          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (isCompleted && rating == 0.0)
                _outlineButton('Give Rating', () {
                  showCustomBottomSheet(
                      context: context, child: RatingSheet(session: session));
                }),
              if (isCompleted)
                _outlineButton('Recordings', () {
                  CustomNavigation.push(
                    context: context,
                    screen: SessionRecordings(bookingId: session.bookingId),
                  );
                }),
              if (scheduled != null)
                _outlineButton('Details', () => _showDetails(session)),
            ],
          ),

          if (isCompleted && rating != 0.0) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your rating',
                        style: TextStyle(
                            color: textSlate,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      CustomRating(rating: rating, itemSize: 12),
                    ],
                  ),
                  if (scheduled?.ratingComment?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      scheduled!.ratingComment!,
                      style: const TextStyle(color: textSlate, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetails(Session session) {
    final scheduled = session.scheduledSessions;
    if (scheduled == null) return;
    scheduled.guidePrefrence = session.guideData;
    scheduled.guideData = session.guide;
    scheduled.studentPrefrence = session.student;
    showCustomBottomSheet(
      context: context,
      child: ScheduledDetailsSheet(
        scheduledSessions: scheduled,
        taxPercentage: session.taxPercentage > 0 ? session.taxPercentage : 6,
      ),
    );
  }

  void _reloadAll(SessionsProvider provider) {
    for (final t in _tabs) {
      provider.resetOffset(sessionType: t.status);
      provider.getSession(sessionStatus: t.status);
    }
  }

  String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'G';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: textLightGrey, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
              color: textSlate, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  bool _isPastDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return false;
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  Widget _primaryButton(
      {required String label,
      required IconData icon,
      required VoidCallback onTap,
      bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled ? primaryBlue : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _outlineButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: primaryBlue, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
