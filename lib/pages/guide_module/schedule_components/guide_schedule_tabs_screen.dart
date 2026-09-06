import 'package:flutter/material.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/app_specific/custom_drawer.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';

import 'mySchedule.dart';
import 'booking.dart';

class GuideScheduleTabsScreen extends StatefulWidget {
  const GuideScheduleTabsScreen({Key? key}) : super(key: key);

  @override
  State<GuideScheduleTabsScreen> createState() =>
      _GuideScheduleTabsScreenState();
}

class _GuideScheduleTabsScreenState extends State<GuideScheduleTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Exact Colors from the UI Mockup
  final Color primaryBlue = const Color(0xFF22328C);
  final Color backgroundGrey = const Color(0xFFF8F9FB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        titleText: 'Availability & Schedule',
        centerTitle: true,
        isNotificationIcon: true,
        isBackIcon: false, // Hidden since it's a bottom bar tab
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: const Color(0xFF94A3B8),
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [
                Tab(text: 'My Schedule'),
                Tab(text: 'Upcoming Bookings'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MyScheduleContent(),
                BookingContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
