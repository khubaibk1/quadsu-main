import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:intl/intl.dart';
import 'package:quadsu_app/constants/global_data.dart';

import 'confirmBooking.dart';

class SessionSlotsScreen extends StatefulWidget {
  const SessionSlotsScreen({Key? key}) : super(key: key);

  @override
  State<SessionSlotsScreen> createState() => _SessionSlotsScreenState();
}

class _SessionSlotsScreenState extends State<SessionSlotsScreen> {
  // Exact Colors from the UI Mockup
  final Color primaryBlue = const Color(0xFF22328C);
  final Color darkNavyText = const Color(0xFF0F172A);
  final Color darkNavyBg = const Color(0xFF06132D);
  final Color textSlate = const Color(0xFF64748B);
  final Color textMuted = const Color(0xFF94A3B8);
  final Color cardBorderColor = const Color(0xFFE2E8F0);
  final Color fadedBgColor = const Color(0xFFF8FAFC);
  final Color onlineGreen = const Color(0xFF10B981);
  final Color dividerColor = const Color(0xFFF1F5F9);
  final Color orangeAccent = const Color(0xFFFF7A00); // For selected slots

  DateTime _currentSelectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookGuideProvider>(context, listen: false);
      provider.selectedDate = _currentSelectedDate;
      if (provider.selectedGuide != null &&
          provider.selectedGuide!.id != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(_currentSelectedDate);
        print(
            "DEBUG: UI Init - Fetching availability for Guide ${provider.selectedGuide!.id} on $dateStr");
        provider.fetchGuideAvailability(provider.selectedGuide!.id!, dateStr);
      }
    });
  }

  // Helper to format date for the UI
  String _getFormattedDate() {
    final months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];
    final fullDayNames = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    return "${fullDayNames[_currentSelectedDate.weekday - 1]}, ${months[_currentSelectedDate.month - 1]} ${_currentSelectedDate.day}";
  }

  Future<void> _selectDate(
      BuildContext context, BookGuideProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentSelectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              onSurface: darkNavyText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentSelectedDate) {
      setState(() {
        _currentSelectedDate = picked;
        provider.selectedDate = picked;
        provider.selectedSlot = null; // Reset slot on date change
      });
      if (provider.selectedGuide != null &&
          provider.selectedGuide!.id != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(picked);
        print("DEBUG: DatePicker change - Fetching availability for $dateStr");
        provider.fetchGuideAvailability(provider.selectedGuide!.id!, dateStr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookGuideProvider>(
      builder: (context, bookProvider, child) {
        final guide = bookProvider.selectedGuide;
        if (guide == null) {
          return const Scaffold(body: Center(child: Text("No Guide Selected")));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: primaryBlue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Select Date & Time Slot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(guide),
                      Divider(color: dividerColor, thickness: 1.5, height: 1),
                      const SizedBox(height: 24),
                      _buildCalendarHeader(bookProvider),
                      const SizedBox(height: 20),
                      _buildDateSlider(bookProvider),
                      const SizedBox(height: 40),

                      // Dynamic Slots Sections
                      _buildSlotsGrid(bookProvider),

                      // Info Banner
                      _buildInfoBanner(bookProvider),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildBottomPaymentBar(guide, bookProvider),
            ],
          ),
        );
      },
    );
  }

  // --- CUSTOM WIDGETS ---

  Widget _buildProfileSection(Guide guide) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF082736),
                backgroundImage: (guide.guidePrefrence?.profileImage != null &&
                            guide.guidePrefrence!.profileImage.isNotEmpty)
                        ? NetworkImage(guide.guidePrefrence!.profileImage)
                        : (guide.studentPrefrence?.profileImage != null &&
                                guide.studentPrefrence!.profileImage.isNotEmpty)
                            ? NetworkImage(guide.studentPrefrence!.profileImage)
                            : null,
                child: (guide.guidePrefrence?.profileImage == null ||
                            guide.guidePrefrence!.profileImage.isEmpty) &&
                        (guide.studentPrefrence?.profileImage == null ||
                            guide.studentPrefrence!.profileImage.isEmpty)
? Text(
                        (guide.firstName.isNotEmpty ? guide.firstName[0] : "") +
                            (guide.lastName.isNotEmpty
                                ? guide.lastName[0]
                                : ""),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: onlineGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${guide.firstName} ${guide.lastName}",
                  style: TextStyle(
                    color: darkNavyText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.school, size: 16, color: textSlate),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${guide.guidePrefrence?.university ?? "Peer Guide"}",
                        style: TextStyle(
                          color: textSlate,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(BookGuideProvider provider) {
    final months = [
      "JANUARY",
      "FEBRUARY",
      "MARCH",
      "APRIL",
      "MAY",
      "JUNE",
      "JULY",
      "AUGUST",
      "SEPTEMBER",
      "OCTOBER",
      "NOVEMBER",
      "DECEMBER"
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${months[_currentSelectedDate.month - 1]} ${_currentSelectedDate.year}",
            style: TextStyle(
              color: textSlate,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(context, provider),
            child: Row(
              children: [
                Text(
                  "View Calendar",
                  style: TextStyle(
                    color: darkNavyText,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.calendar_month, size: 14, color: darkNavyText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSlider(BookGuideProvider provider) {
    List<DateTime> days = [];
    DateTime now = DateTime.now();
    int year = _currentSelectedDate.year;
    int month = _currentSelectedDate.month;
    
    // Calculate total days in the selected month
    int daysInMonth = DateTime(year, month + 1, 0).day;
    
    // If we're looking at the current calendar month, start from today
    int startDay = 1;
    if (year == now.year && month == now.month) {
      startDay = now.day;
    }

    for (int i = startDay; i <= daysInMonth; i++) {
      days.add(DateTime(year, month, i));
    }

    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.day == _currentSelectedDate.day &&
              day.month == _currentSelectedDate.month &&
              day.year == _currentSelectedDate.year;
          final dayName = [
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat",
            "Sun"
          ][day.weekday - 1];

          return _buildDateCard(
              dayName: dayName,
              dateNum: day.day,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _currentSelectedDate = day;
                  provider.selectedDate = day;
                  provider.selectedSlot = null;
                });
                if (provider.selectedGuide != null &&
                    provider.selectedGuide!.id != null) {
                  final dateStr = DateFormat('yyyy-MM-dd').format(day);
                  print(
                      "DEBUG: Slider change - Fetching availability for $dateStr");
                  provider.fetchGuideAvailability(
                      provider.selectedGuide!.id!, dateStr);
                }
              });
        },
      ),
    );
  }

  Widget _buildDateCard({
    required String dayName,
    required int dateNum,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? darkNavyBg : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: cardBorderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected ? Colors.white : textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dateNum.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : darkNavyText,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEndTime(String startTime) {
    try {
      // startTime example: "09:00 AM"
      final parts = startTime.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      String period = parts[1];

      hour += 1;

      if (hour == 12) {
        // Handled: 11 AM -> 12 PM
        period = (period == "AM") ? "PM" : "AM";
      } else if (hour > 12) {
        hour = 1;
      }

      return "${hour.toString().padLeft(2, '0')}:$minute $period";
    } catch (e) {
      return startTime;
    }
  }

  Widget _buildSlotsGrid(BookGuideProvider provider) {
    if (provider.isLoadingSlots) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.availableSlots.isEmpty) {
      final dayNames = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            "No slots available for ${dayNames[_currentSelectedDate.weekday - 1]}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textSlate, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    int timeToMinutes(String timeStr) {
      final t = timeStr.trim().toUpperCase();
      bool isPM = t.contains("PM");
      String timePart = t.replaceAll("AM", "").replaceAll("PM", "").trim();
      final parts = timePart.split(':');
      if (parts.length != 2) return 0;
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
      return hour * 60 + minute;
    }

    // Sort first
    final sortedSlots = List<dynamic>.from(provider.availableSlots);
    sortedSlots.sort((a, b) {
      int minsA = timeToMinutes(a['display_time'] ?? "");
      int minsB = timeToMinutes(b['display_time'] ?? "");
      return minsA.compareTo(minsB);
    });

    // Grouping Logic
    List<dynamic> morningSlots = [];
    List<dynamic> afternoonSlots = [];
    List<dynamic> eveningSlots = [];

    for (var slot in sortedSlots) {
      String time = slot['display_time'] ?? "";
      final timeUpper = time.trim().toUpperCase();

      // Always determine AM/PM from display_time string (most reliable)
      bool isAM = timeUpper.contains("AM");
      bool isPM = timeUpper.contains("PM");

      // Fallback to period field only if display_time has no AM/PM marker
      if (!isAM && !isPM) {
        String period = slot['period']?.toString().toUpperCase() ?? "";
        isAM = (period == "AM");
        isPM = !isAM;
      }

      if (isAM) {
        morningSlots.add(slot);
      } else {
        // PM — split into afternoon (12 PM – 4:59 PM) and evening (5 PM+)
        final rawHour = int.tryParse(time.split(':')[0].trim()) ?? 0;
        if (rawHour == 12 || rawHour < 5) {
          afternoonSlots.add(slot);
        } else {
          eveningSlots.add(slot);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AVAILABLE SLOTS",
            style: TextStyle(
              color: textSlate,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          if (morningSlots.isNotEmpty)
            _buildSlotSection("MORNING", Icons.wb_sunny_outlined, morningSlots,
                provider, textMuted),
          if (afternoonSlots.isNotEmpty)
            _buildSlotSection("AFTERNOON", Icons.wb_sunny_outlined,
                afternoonSlots, provider, textMuted),
          if (eveningSlots.isNotEmpty)
            _buildSlotSection("EVENING", Icons.nightlight_round, eveningSlots,
                provider, textMuted),
        ],
      ),
    );
  }

  Widget _buildSlotSection(String title, IconData icon, List<dynamic> slots,
      BookGuideProvider provider, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: titleColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children:
              slots.map((slot) => _buildTimeSlotCard(slot, provider)).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTimeSlotCard(dynamic slot, BookGuideProvider provider) {
    String startTime = slot['display_time'] ?? "";
    String endTime = _getEndTime(startTime);
    bool isSelected = provider.selectedSlot == startTime;

    return GestureDetector(
      onTap: () {
        print("DEBUG: Slot Selected: $startTime");
        setState(() => provider.selectedSlot = startTime);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? orangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(color: cardBorderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              startTime,
              style: TextStyle(
                color: isSelected ? Colors.white.withOpacity(0.7) : textSlate,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              endTime,
              style: TextStyle(
                color: isSelected ? Colors.white : darkNavyText,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BookGuideProvider provider) {
    if (provider.selectedSlot == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fadedBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dividerColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info, color: darkNavyText, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: textSlate,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "You've selected a "),
                    TextSpan(
                      text: "1-hour mentoring session",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: darkNavyText),
                    ),
                    TextSpan(
                        text:
                            " on\n${_getFormattedDate()} at ${provider.selectedSlot}."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPaymentBar(Guide guide, BookGuideProvider provider) {
    double hourlyRate =
        double.tryParse(myAppSettings?.sessionPrice ?? "0") ?? 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: dividerColor, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Session Rate",
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${hourlyRate.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: darkNavyText,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    provider.selectedSlot != null
                        ? "Ready to book"
                        : "Select a slot",
                    style: TextStyle(
                      color: provider.selectedSlot != null
                          ? onlineGreen
                          : orangeAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "60 minutes",
                    style: TextStyle(
                      color: textSlate,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: provider.selectedSlot == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfirmBookingScreen()),
                    );
                  },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: provider.selectedSlot != null
                    ? primaryBlue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.payments,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enum for managing the 3 different visual states of the date cards
enum DateCardState { faded, normal, selected }

// Enum for managing the 3 different visual states of the time slot cards
enum SlotState { normal, selected, disabled }
