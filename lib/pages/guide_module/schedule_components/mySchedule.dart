import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/provider/guide_schedule_provider.dart';
import 'package:quadsu_app/modal/guide_schedule_model.dart';
import 'package:intl/intl.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class MyScheduleContent extends StatefulWidget {
  const MyScheduleContent({Key? key}) : super(key: key);

  @override
  State<MyScheduleContent> createState() => _MyScheduleContentState();
}

class _MyScheduleContentState extends State<MyScheduleContent> {
  // Exact Colors from the UI Mockup
  final Color primaryBlue = const Color(0xFF22328C);
  final Color backgroundGrey = const Color(0xFFF8F9FB);
  final Color textDark = const Color(0xFF1E293B);
  final Color textLightGrey = const Color(0xFF8A94A6);
  final Color textInactive = const Color(0xFF94A3B8); // For Off days
  final Color orangeAccent = const Color(0xFFFF8A00);
  final Color cardBorderColor = const Color(0xFFF1F5F9);
  final Color timeFieldBg = const Color(0xFFF8FAFC);
  final Color avatarBgColor = const Color(0xFFF1F5F9);
  final Color textSlate = const Color(0xFF334155);

  // No longer needed: static switches

  List<ScheduleDay> localSchedule = [];

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GuideScheduleProvider>(context, listen: false)
          .fetchSchedule()
          .then((_) {
        _syncLocalSchedule();
      });
    });
  }

  void _syncLocalSchedule() {
    final provider = Provider.of<GuideScheduleProvider>(context, listen: false);
    if (provider.scheduleModel != null) {
      final Map<String, int> dayOrder = {
        'monday': 1,
        'tuesday': 2,
        'wednesday': 3,
        'thursday': 4,
        'friday': 5,
        'saturday': 6,
        'sunday': 7,
      };

      setState(() {
        var mappedSchedule = provider.scheduleModel!.schedule
            .map((e) => ScheduleDay(
                  id: e.id,
                  userId: e.userId,
                  day: e.day,
                  startTime: e.startTime ?? "09:00:00",
                  endTime: e.endTime ?? "21:00:00",
                  isOffDay: e.isOffDay,
                ))
            .toList();

        mappedSchedule.sort((a, b) {
          int orderA = dayOrder[a.day.toLowerCase()] ?? 8;
          int orderB = dayOrder[b.day.toLowerCase()] ?? 8;
          return orderA.compareTo(orderB);
        });

        localSchedule = mappedSchedule;
      });
    }
  }

  void initDeepLinks() {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'guideapp' && uri.host == 'google-success') {
        _handleGoogleSuccess();
      }
    });
  }

  void _handleGoogleSuccess() {
    Provider.of<GuideScheduleProvider>(context, listen: false)
        .fetchSchedule()
        .then((_) {
      _syncLocalSchedule();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Calendar Connected Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _selectTime(
      BuildContext context, int index, bool isStartTime) async {
    final day = localSchedule[index];
    final initialTimeStr = isStartTime ? day.startTime : day.endTime;

    TimeOfDay? initialTime;
    if (initialTimeStr != null) {
      final parts = initialTimeStr.split(':');
      if (parts.length >= 2) {
        initialTime =
            TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
    initialTime ??= const TimeOfDay(hour: 9, minute: 0);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        final timeStr =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
        if (isStartTime) {
          day.startTime = timeStr;
        } else {
          day.endTime = timeStr;
        }
      });
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "09:00 AM";
    try {
      final parts = timeStr.split(':');
      final dateTime =
          DateTime(2022, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuideScheduleProvider>(
      builder: (context, provider, child) {
        if (provider.isScheduleLoading && localSchedule.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isConnected = provider.scheduleModel?.isGoogleConnected == true;

        if (!isConnected) {
          return _buildSyncAvailabilityView(provider);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchSchedule(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGoogleCalendarButton(provider),
                      const SizedBox(height: 24),
                      _buildHeader(),
                      const SizedBox(height: 16),
                      if (localSchedule.isEmpty && !provider.isScheduleLoading)
                        const Center(
                            child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                              "No schedule found. Start by setting your availability."),
                        )),
                      // Cards
                      ...List.generate(localSchedule.length, (index) {
                        final dayData = localSchedule[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildDayCard(
                            day: dayData.day.toUpperCase(),
                            avatarLetter: dayData.day[0].toUpperCase(),
                            startTime: _formatTime(dayData.startTime),
                            endTime: _formatTime(dayData.endTime),
                            switchValue: !dayData.isOffDay,
                            onChanged: (val) =>
                                setState(() => dayData.isOffDay = !val),
                            onStartTimeTap: () =>
                                _selectTime(context, index, true),
                            onEndTimeTap: () =>
                                _selectTime(context, index, false),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              _buildBottomSaveArea(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSyncAvailabilityView(GuideScheduleProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Illustration Stack
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_month,
                                color: Colors.white, size: 28),
                          ),
                          Container(
                            width: 30,
                            height: 2,
                            color: Colors.grey[200],
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[100]!),
                            ),
                            child: const Icon(Icons.refresh,
                                color: Colors.blue, size: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sync, color: orangeAccent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Auto-Sync",
                            style: TextStyle(
                              color: orangeAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            "Sync your availability",
            style: TextStyle(
              color: textDark,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Connect your Google Calendar to sync your availability and manage your sessions effortlessly.",
            style: TextStyle(
              color: textLightGrey,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Google Connect Button
          GestureDetector(
            onTap: () => provider.getGoogleConnectUrl(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Connect Google Calendar',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, color: orangeAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "You need to connect your calendar before setting up your weekly schedule.",
                    style: TextStyle(
                      color: textSlate,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM WIDGETS ---

  Widget _buildGoogleCalendarButton(GuideScheduleProvider provider) {
    bool isConnected = provider.scheduleModel?.isGoogleConnected == true;
    return GestureDetector(
      onTap: isConnected ? null : () => provider.getGoogleConnectUrl(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: provider.scheduleModel?.isGoogleConnected == true
                  ? Colors.green.withOpacity(0.5)
                  : const Color(0xFFE2E8F0),
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.scheduleModel?.isGoogleConnected == true)
              const Icon(Icons.check_circle, color: Colors.green, size: 22)
            else
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                height: 22,
                width: 22,
              ),
            const SizedBox(width: 12),
            Text(
              provider.scheduleModel?.isGoogleConnected == true
                  ? 'Google Calendar Connected'
                  : 'Connect Google Calendar',
              style: TextStyle(
                color: textDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Weekly Availability',
          style: TextStyle(
            color: textLightGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Apply all',
          style: TextStyle(
            color: orangeAccent,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard({
    required String day,
    required String avatarLetter,
    required String startTime,
    required String endTime,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
    required VoidCallback onStartTimeTap,
    required VoidCallback onEndTimeTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarBgColor,
                radius: 20,
                child: Text(
                  avatarLetter,
                  style: TextStyle(
                    color: switchValue ? primaryBlue : textInactive,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                day,
                style: TextStyle(
                  color: switchValue ? textDark : textInactive,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch(
                  value: switchValue,
                  activeColor: orangeAccent,
                  trackColor: const Color(0xFFE2E8F0),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          if (switchValue) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child:
                        _buildTimeBox("Start Time", startTime, onStartTimeTap)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildTimeBox("End Time", endTime, onEndTimeTap)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              "Off Day",
              style: TextStyle(
                color: textInactive,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textLightGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: timeFieldBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSaveArea(GuideScheduleProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
      ),
      child: GestureDetector(
        onTap: () => provider.saveSchedule(localSchedule),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Save Availability',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
