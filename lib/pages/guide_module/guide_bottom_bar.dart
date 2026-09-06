import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../provider/bottom_tabbar_provider.dart';
import '../../widget/common_alert_dailog.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_scaffold.dart';

class GuideBottomBarScreen extends StatelessWidget {
  const GuideBottomBarScreen({super.key});

  // --- New Design Colors ---
  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kBackgroundLight = Color(0xFFF2F2F7);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomTabBarProvider>(
        builder: (context, bottomTabBarProvider, _) {
      return WillPopScope(
        onWillPop: () async {
          // --- OLD EXIT LOGIC PRESERVED ---
          if (bottomTabBarProvider.currentIndex == 0) {
            return await showCommonAlertDailog(context,
                headingText: "Are you sure?",
                message: "Do you want to exit the app",
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "No",
                        verticalPadding: 0,
                        isSolid: true,
                        width: 100,
                        height: 40,
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      hSizedBox2,
                      CustomButton(
                        text: "Yes",
                        width: 100,
                        verticalPadding: 0,
                        height: 40,
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      hSizedBox,
                    ],
                  ),
                ],
                imageUrl: MyImagesUrl.logout);
          } else {
            bottomTabBarProvider.changeIndex(index: 0);
            return false;
          }
        },
        child: CustomScaffold(
          body:
              bottomTabBarProvider.guideTabs[bottomTabBarProvider.currentIndex],
          // --- NEW BOTTOM BAR DESIGN ---
          bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
              color: kBackgroundLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildNavItems(bottomTabBarProvider),
            ),
          ),
        ),
      );
    });
  }

  // --- Helper to build tabs dynamically based on app settings ---
  List<Widget> _buildNavItems(BottomTabBarProvider provider) {
    return [
      _buildNavItem(
        provider: provider,
        index: 0,
        iconPath: 'assets/icons/home.png',
      ),
      _buildNavItem(
        provider: provider,
        index: 1,
        iconPath: 'assets/icons/chat.png',
      ),
      _buildNavItem(
        provider: provider,
        index: 2,
        iconPath: 'assets/icons/heart.png',
      ),
      _buildNavItem(
        provider: provider,
        index: 3,
        iconPath: 'assets/icons/calendar.png',
      ),
      _buildNavItem(
        provider: provider,
        index: 4,
        iconPath: 'assets/icons/profile.png',
      ),
    ];
  }

  // --- Individual Tab Item Widget ---
  Widget _buildNavItem({
    required BottomTabBarProvider provider,
    required int index,
    required String iconPath,
  }) {
    bool isSelected = provider.currentIndex == index;

    return GestureDetector(
      onTap: () => provider.changeIndex(index: index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: Image.asset(
          iconPath,
          height: isSelected ? 28 : 24,
          width: isSelected ? 28 : 24,
          color: isSelected ? kPrimaryBlue : kPrimaryBlue.withOpacity(0.6),
        ),
      ),
    );
  }
}
