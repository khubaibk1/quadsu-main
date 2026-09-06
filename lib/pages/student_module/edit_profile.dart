import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/functions/showCustomBottomSheet.dart';
import 'package:quadsu_app/pages/bottom_sheet/edit_basic_details_student.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import '../../services/image_picker.dart';
import '../../constants/my_image_url.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kTextBlack = Color(0xFF1C1C1E);
  static const Color kTextGrey = Color(0xFF6E6E73);
  static const Color kBackgroundWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: SafeArea(
        bottom: false,
        child: Consumer<MyAuthProvider>(
          builder: (context, myAuthProvider, child) {
            return ValueListenableBuilder(
              valueListenable: userDataNotifier,
              builder: (context, userData, child) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ================= HEADER =================
                    SliverAppBar(
                      expandedHeight: screenHeight * 0.4,
                      pinned: true,
                      stretch: true,
                      backgroundColor: kPrimaryBlue,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const [
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                        ],
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                image = await cameraImagePicker(context);
                                if (image != null) {
                                  EasyLoading.show();
                                  String? url = await NewestWebServices
                                      .uploadImageAndGetUrl(image!.path);

                                  if (context.mounted) {
                                    myAuthProvider.editProfileImage(
                                      context,
                                      request: {ApiKeys.profileImage: url},
                                      userType: usertype,
                                    );
                                  }
                                }
                              },
                              child: CustomImage(
                                imageUrl:
                                    userData?.studentPrefrence?.profileImage ??
                                        "",
                                fit: BoxFit.cover,
                                showLoader: false,
                                isBackgroundImage: false,
                                isShowStackImage: false,
                                fileType: CustomFileType.network,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    '${userData?.firstName ?? ""} ${userData?.lastName ?? ""}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userData?.email ?? "",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ================= BODY =================
                    SliverToBoxAdapter(
                      child: Container(
                        color: const Color.fromARGB(255, 18, 18, 33),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Profile Information',
                                    style: TextStyle(
                                      fontSize: 22, // slightly bigger
                                      fontWeight:
                                          FontWeight.w900, // maximum bold
                                      letterSpacing:
                                          0.2, // optional, makes it look tighter
                                      height:
                                          1.2, // slightly tighter line height
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showCustomBottomSheet(
                                        context: context,
                                        child: EditBasicDetailsStudent(),
                                      );
                                    },
                                    icon: Image.asset(
                                      'assets/icons/edit.png',
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildProfileItem(
                                'assets/icons/profile.png',
                                'Name',
                                '${userData?.firstName ?? ""} ${userData?.lastName ?? ""}',
                              ),
                              _buildProfileItem(
                                'assets/icons/email.png',
                                'Email',
                                userData?.email ?? "",
                              ),
                              _buildProfileItem(
                                'assets/icons/student_head.png',
                                'School',
                                userData?.studentPrefrence?.city ?? 'Not set',
                              ),
                              _buildProfileItem(
                                'assets/icons/student_head.png',
                                'Location',
                                userData?.studentPrefrence?.location ?? 'Not set',
                              ),
                              _buildProfileItem(
                                'assets/icons/calendar.png',
                                'Phone',
                                userData?.studentPrefrence?.phone ?? 'Not set',
                              ),
                              _buildProfileItem(
                                'assets/icons/profile.png',
                                'Country',
                                userData?.studentPrefrence?.country ?? 'Not set',
                              ),
                              const SizedBox(height: 32),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  myAuthProvider.logoutPopup(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 11),
                                  child: Row(
                                    children: [
                                      Image.asset(MyImagesUrl.logout, width: 27, color: MyColors.blackColor),
                                      hSizedBox,
                                      hSizedBox05,
                                      CustomText.headingSmall(
                                        'Logout',
                                        color: MyColors.appBarTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem(String iconPath, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: kTextGrey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kTextBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: kTextBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
