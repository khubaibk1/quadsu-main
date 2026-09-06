import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/bottom_tabbar_provider.dart';

class HomeNav extends StatelessWidget {
  const HomeNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    const kBackgroundColor = Color(0xFFF5F6FA); // Light grey background
    const kPrimaryBlue = Color(0xFF2D3388);

    return Consumer<BottomTabBarProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 90, // Slightly taller for floating circle
          decoration: BoxDecoration(
            color: kBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon('assets/icons/home.png', 0, provider, kPrimaryBlue),
              _buildNavIcon('assets/icons/chat.png', 1, provider, kPrimaryBlue),
              _buildNavIcon(
                  'assets/icons/heart.png', 2, provider, kPrimaryBlue),
              _buildNavIcon(
                  'assets/icons/calendar.png', 3, provider, kPrimaryBlue),
              _buildNavIcon(
                  'assets/icons/profile.png', 4, provider, kPrimaryBlue),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(
      String assetPath, int index, BottomTabBarProvider provider, Color color) {
    final isActive = provider.currentIndex == index;

    return GestureDetector(
      onTap: () => provider.changeIndex(index: index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Smooth animation
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Active = white circle with shadow, Inactive = transparent
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
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
          assetPath,
          height: isActive ? 28 : 24, // Bigger for bold effect
          width: isActive ? 28 : 24,
          color: isActive ? color : color.withOpacity(0.6),
        ),
      ),
    );
  }
}
