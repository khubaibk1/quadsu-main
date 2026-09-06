import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import '../constants/global_data.dart';
import '../constants/my_image_url.dart';
import '../constants/sized_box.dart';
import '../pages/commons/notification_screen.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color? bgColor;
  Color? titleColor;
  String? titleText;
  String? leadImageUrl;
  Widget? title;
  Widget? leading;
  double? toolbarHeight;
  Widget? subTitleWidget;
  double? titleFontSize;
  bool centerTitle;
  bool isBackIcon;
  bool isNotificationIcon;
  bool bottomCurve;
  bool showBottomBorder;
  String? leadingIcon;
  FontWeight? titleFontWeight;
  double? leadingWidth;
  PreferredSizeWidget? bottom;
  Function()? onPressed;
  List<Widget>? actions;

  // --- New Design Colors ---
  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kAccentOrange = Color(0xFFF79E1B);
  static const Color kWhite = Colors.white;

  CustomAppBar({
    super.key,
    this.bgColor,
    this.titleColor,
    this.titleText,
    this.actions,
    this.bottom,
    this.title,
    this.titleFontWeight,
    this.onPressed,
    this.leadingWidth = globalHorizontalPadding,
    this.leadImageUrl,
    this.titleFontSize,
    this.subTitleWidget,
    this.showBottomBorder = true,
    this.centerTitle = false,
    this.bottomCurve = false,
    this.isBackIcon = true,
    this.isNotificationIcon = false,
    this.toolbarHeight = 65.0,
    this.leadingIcon,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0, // Prevents color change on scroll (Material 3)
      toolbarHeight: toolbarHeight,

      // --- Title Section ---
      title: title ??
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.appbarText(
                titleText ?? '',
                fontSize: titleFontSize ?? 18, // Slightly larger for modern look
                color: titleColor ?? kPrimaryBlue, // Updated to New Theme Blue
                fontWeight: titleFontWeight ?? FontWeight.w600,
              ),
              if (subTitleWidget != null) vSizedBox02,
              if (subTitleWidget != null) subTitleWidget!
            ],
          ),

      // --- Background ---
      backgroundColor: bgColor ?? kWhite, // Default to White for clean look
      centerTitle: centerTitle,
      automaticallyImplyLeading: isBackIcon,
      titleSpacing: 0,

      // --- Leading (Back Button or Profile) ---
      leadingWidth: (isBackIcon && Navigator.canPop(context)) ? 50 : leadingWidth,
      leading: (isBackIcon && Navigator.canPop(context))
          ? IconButton(
          onPressed: onPressed ??
                  () {
                unFocusKeyBoard();
                Navigator.pop(context);
              },
          // New Design Back Arrow
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: titleColor ?? kPrimaryBlue,
          ))
          : leadImageUrl != null
          ? GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Consumer<MyAuthProvider>(
            builder: (context, value, child) {
              return ValueListenableBuilder(
                  valueListenable: userDataNotifier,
                  builder: (context, userData, child) {
                    return Container(
                      margin: const EdgeInsets.only(left: 10),
                      // Added subtle decoration to profile image to match "New" design
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: ClipOval(
                        child: CustomImage(
                          imageUrl: usertype == UserType.guide
                              ? userData?.guidePrefrence?.profileImage ?? ""
                              : userData?.studentPrefrence?.profileImage ??
                              "",
                          fileType: CustomFileType.network,
                          height: 45,
                          staticBlurImage: MyImagesUrl.defaultProfileImage,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  });
            }),
      )
          : Container(),

      // --- Actions (Notifications) ---
      actions: actions ??
          [
            if (isNotificationIcon)
              Consumer<MyAuthProvider>(
                  builder: (context, myAuthProvider, child) {
                    return GestureDetector(
                      onTap: () async {
                        CustomNavigation.push(
                            context: context, screen: const NotificationScreen());
                      },
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: ImageIcon(
                                AssetImage(MyImagesUrl.notification),
                                size: 26,
                                color: kPrimaryBlue, // Updated Icon Color
                              ),
                            ),
                            if (myAuthProvider.unreadNotificationsCount.value != 0)
                              Positioned(
                                top: -2,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kAccentOrange // Updated to Theme Orange
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Center(
                                    child: Text(
                                      myAuthProvider.unreadNotificationsCount.value <= 9
                                          ? '${myAuthProvider.unreadNotificationsCount.value}'
                                          : '9+',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  }),
            hSizedBox,
          ],
      bottom: bottom,
      shape: bottomCurve
          ? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight!);
}