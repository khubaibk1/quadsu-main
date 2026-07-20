import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/widget/app_specific/custom_shadow_container.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_confirmation_dialog.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';

import '../../constants/my_image_url.dart';
import '../../services/custom_navigation_services.dart';
import '../../services/firebase_services/firebase_chat_services.dart';
import '../../provider/my_auth_provider.dart';
import '../student_module/chat_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  final int studentId;

  const StudentProfileScreen({super.key, required this.studentId});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  ValueNotifier<Guide?> student = ValueNotifier(null);
  bool _isChatLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        DashBoardProvider dashBoardProvider =
            Provider.of<DashBoardProvider>(context, listen: false);
        student.value = await dashBoardProvider.getStudentProfile(
            studentId: widget.studentId);
        if( student.value?.isDelete == 1)
        {
          showCustomConfirmationDialog(
            isCancelButton: false,
            headingMessage: "Sorry",
            headingMessageColor: MyColors.primaryColor,
            description:"This student is no longer available. We're sorry for the inconvenience. Please try contacting another student or try again later."
            ,descriptionMessageFontSize: 14,
            okButtonText: "Ok",
            okButtonClick: () {
              CustomNavigation.pop(context);
              CustomNavigation.pop(context);
            },
            horizontalPadding: 16,
          );

        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Profile',
      ),
      body: ValueListenableBuilder(
          valueListenable: student,
          builder: (context, studentValue, child) {

            if (studentValue == null) {
              return const SizedBox();
            }

            if( studentValue.isDelete == 1)
            {
              return const SizedBox();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: globalHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CustomImage(
                      imageUrl: studentValue.studentPrefrence?.profileImage ?? "",
                      height: 90,
                      width: 90,
                      staticBlurImage: MyImagesUrl.defaultProfileImage,
                      isShowStackImage: true,
                      fileType: CustomFileType.network,
                    ),
                  ),
                  vSizedBox05,
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      child: OutlinedButton.icon(
                        onPressed: _isChatLoading
                            ? null
                            : () => _handleChatLogic(context, studentValue),
                        icon: _isChatLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor)),
                              )
                            : const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                        label: const Text('Chat',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MyColors.primaryColor,
                          side: BorderSide(color: MyColors.primaryColor, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.bodyText2(
                        'Basic Details',
                        increamentFontSize: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  vSizedBox,
                  CustomShadowContainer(
                    horizontalPadding: 15,
                    verticalPadding: 15,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'First name',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.firstName ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'Last name',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.lastName ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'Email',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.email ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        if (studentValue.studentPrefrence?.countryCode != null)
                          vSizedBox05,
                        if (studentValue.studentPrefrence?.countryCode != null)
                          Row(
                            children: [
                              Expanded(
                                child: CustomText.smallText(
                                  'Phone number',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: CustomText.smallText(
                                  "${studentValue.studentPrefrence?.countryCode.isNotEmpty ==true ?"+":""}${studentValue.studentPrefrence?.countryCode ?? ""} ${studentValue.studentPrefrence?.phone ?? ""}",
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  vSizedBox2,
                  Row(
                    children: [
                      CustomText.bodyText2(
                        'Address',
                        increamentFontSize: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  vSizedBox,
                  CustomShadowContainer(
                    horizontalPadding: 15,
                    verticalPadding: 15,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'Location',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.studentPrefrence?.location ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'Country',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.studentPrefrence?.country ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'State',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.studentPrefrence?.state ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'City',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.studentPrefrence?.city ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        vSizedBox05,
                        Row(
                          children: [
                            Expanded(
                              child: CustomText.smallText(
                                'Zip Code',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: CustomText.smallText(
                                studentValue.studentPrefrence?.zipCode ?? "",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  vSizedBox2,
                  vSizedBox2,
                ],
              ),
            );
          }),
    );
  }

  Future<void> _handleChatLogic(BuildContext context, Guide studentValue) async {
    if (userDataNotifier.value == null) {
      Provider.of<MyAuthProvider>(context, listen: false).logout(context);
      return;
    }

    setState(() => _isChatLoading = true);

    try {
      final chatServices = FirebaseChatServices();
      final isEligible = await chatServices.verifyAndInitializeChat(
          guideId: int.parse(userDataNotifier.value!.userId.toString()),
          studentId: widget.studentId,
      );

      if (!mounted) return;

      if (isEligible) {
        final Map<String, dynamic> otherUserData = {
          'id': studentValue.id,
          'first_name': studentValue.firstName ?? '',
          'last_name': studentValue.lastName ?? '',
          'image': studentValue.studentPrefrence?.profileImage ?? '',
          'type': 'student',
        };

        CustomNavigation.push(
          context: context,
          screen: ChatScreen(
            otherUserId: widget.studentId.toString(),
            otherUserName:
                '${studentValue.firstName ?? ''} ${studentValue.lastName ?? ''}'.trim(),
            otherUserImage: studentValue.studentPrefrence?.profileImage ?? '',
            otherUserData: otherUserData,
            deviceTokens: const [],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can only chat with students with whom you have active or past sessions.',
            ),
            backgroundColor: Color(0xFF2D3388),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isChatLoading = false);
    }
  }
}
