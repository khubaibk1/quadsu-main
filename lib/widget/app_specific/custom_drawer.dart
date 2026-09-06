import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/pages/guide_module/edit_guide_profile_screen.dart';
import 'package:quadsu_app/pages/student_module/transactions_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../pages/auth_module/change_password_screen.dart';
import '../../pages/student_module/edit_profile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(builder: (context, value, child) {
      return Drawer(
          clipBehavior: Clip.hardEdge,
          backgroundColor: MyColors.whiteColor,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Colors.transparent)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: ValueListenableBuilder(
                valueListenable: userDataNotifier,
                builder: (context, userData, child) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 25),
                        child: Row(
                          children: [
                            CustomImage(
                              height: 60,
                              width: 60,
                              imageUrl: usertype == UserType.guide
                                  ? userData?.guidePrefrence?.profileImage ?? ""
                                  : userData?.studentPrefrence?.profileImage ??
                                      "",

                              borderRadius: 100,
                              fileType: CustomFileType.network,
                              staticBlurImage: MyImagesUrl.defaultProfileImage,
                              // fileType: userData?.profileImage != null
                              //     ? CustomFileType.network
                              //     : CustomFileType.asset,
                            ),
                            hSizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.bodyText2(
                                  '${userData?.firstName ?? ""} ${userData?.lastName ?? ''}',
                                  increamentFontSize: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                                vSizedBox02,
                                CustomText.smallText(
                                  usertype == UserType.guide
                                      ? "${userData?.guidePrefrence?.city ?? ""}${userData?.guidePrefrence?.country!= null && userData?.guidePrefrence?.country.isNotEmpty==true?",":""} ${userData?.guidePrefrence?.country ?? ""}"
                                      : "${userData?.studentPrefrence?.city ?? ""}${userData?.studentPrefrence?.country!= null && userData?.studentPrefrence?.country.isNotEmpty==true?",":""} ${userData?.studentPrefrence?.country ?? ""}",
                                  increamentFontSize: 1,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      if(userDataNotifier.value!=null)
                      CustomTabs(
                        onTap: () {
                          if (usertype == UserType.student) {
                            CustomNavigation.push(
                                context: context, screen: const EditProfile());
                          } else {
                            CustomNavigation.push(
                                context: context,
                                screen: const EditGuideProfileScreen());
                          }
                        },
                        icons: MyImagesUrl.profile_icon_outline,
                        name: 'Edit Profile',
                      ),
                      if(usertype ==UserType.student&&userDataNotifier.value!=null&&myAppSettings?.isHide==false)
                      CustomTabs(
                        onTap: () {
                          CustomNavigation.push(
                              context: context,
                              screen: const TransactionsScreen());
                        },
                        icons: MyImagesUrl.transaction01,
                        name: 'Transactions',
                      ),

                      if(userDataNotifier.value!=null)
                        CustomTabs(
                        onTap: () {
                          CustomNavigation.push(
                              context: context,
                              screen: const ChangePasswordScreen());
                        },
                        icons: MyImagesUrl.lock_icon,
                        name: 'Change password',
                      ),
                      CustomTabs(
                        onTap: ()  {
                          launchUrl(Uri.parse("https://quadsu.com/privacypolicy"));
                        },
                        icon:const Icon(Icons.privacy_tip_outlined,color: MyColors.blackColor,size: 25,),
                        icons: '',
                        name: 'Privacy Policy',
                      ), CustomTabs(
                        onTap: () async {
                          launchUrl(Uri.parse("https://quadsu.com/termscondition"));

                        },
                        icon:const Icon(Icons.privacy_tip_outlined,color: MyColors.blackColor,size: 25,),
                        icons: '',
                        name: 'Terms & Conditions',
                      ),

                      CustomTabs(
                        onTap: () async {
                          var provider = Provider.of<MyAuthProvider>(context,
                              listen: false);
                          provider.logoutPopup(context);
                        },
                        icons: MyImagesUrl.logout,
                        name: 'Logout',
                      ),



                      CustomTabs(
                        onTap: () async {
                          var provider = Provider.of<MyAuthProvider>(context,
                              listen: false);
                          provider.shareApp(context);
                        },
                        icons: MyImagesUrl.share,
                        name: 'Share App',
                      ),

                      if(userDataNotifier.value!=null)
                        CustomTabs(
                        onTap: () async {
                          var provider = Provider.of<MyAuthProvider>(context,
                              listen: false);
                          provider.deletePopup(context);
                        },
                        icons: MyImagesUrl.delete,
                        name: 'Delete',
                        imageColor: MyColors.redColor,
                      ),
                      vSizedBox2
                    ],
                  );
                }),
          ));
    });
  }
}

class CustomTabs extends StatelessWidget {
  final String name;
  final String icons;
  final Function()? onTap;
  final Color? imageColor;
  final Icon? icon;
  const CustomTabs(
      {super.key, Key? k, required this.name, required this.icons, required this.onTap, this.imageColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 11),
        child: Row(
          children: [
            if(icon!= null)
              icon!
            else
            Image.asset(icons, width: 27, color:imageColor?? MyColors.blackColor),
            hSizedBox,
            hSizedBox05,
            CustomText.headingSmall(
              name,
              color: imageColor??MyColors.appBarTextColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
