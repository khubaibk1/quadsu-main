import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/instant_booking_status.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/provider/instant_booking_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/showCustomBottomSheet.dart';
import '../../modal/instant_booking_model.dart';
import '../../pages/bottom_sheet/pay_instant_booking.dart';
import '../../pages/guide_module/student_profile.dart';
import '../../pages/student_module/guide_profile_screen.dart';
import 'custom_shadow_container.dart';
import '../custom_button.dart';
import '../custom_image.dart';
import '../custom_text.dart';

class InstantBookingCard extends StatelessWidget {
  final int status;
  final InstantBooking instantBooking;

  const InstantBookingCard({
    super.key,
    required this.status,
    required this.instantBooking,
  });

  @override
  Widget build(BuildContext context) {
    print('gyhsghjcsgj::::${instantBooking.status}');
    return CustomShadowContainer(
      child: GestureDetector(
        onTap: () {
          if (usertype == UserType.student) {
            CustomNavigation.push(
                context: context,
                screen: GuideProfileScreen(
                  guideId: instantBooking.guideId,
                ));
          } else {
            CustomNavigation.push(
                context: context,
                screen: StudentProfileScreen(
                  studentId: instantBooking.studentId ?? 0,
                ));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomImage(
                  imageUrl: usertype == UserType.student
                      ? instantBooking.guidePreference?.profileImage ?? ''
                      : instantBooking.studentPrefrence?.profileImage ?? '',
                  staticBlurImage: MyImagesUrl.profileImage,
                  height: 70,
                  width: 70,
                  isShowStackImage: true,
                  fileType: CustomFileType.network,
                ),
                hSizedBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // -------- ADDED EXPANDED HERE TO PREVENT OVERFLOW --------
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.bodyText2(
                                  usertype == UserType.student
                                      ? "${instantBooking.guideData?.firstName} ${instantBooking.guideData?.lastName}"
                                      : "${instantBooking.student?.firstName} ${instantBooking.student?.lastName}",
                                  fontWeight: FontWeight.w600,
                                ),
                                if (usertype == UserType.student)
                                  CustomText.smallText(
                                    instantBooking.guidePreference?.speciality ?? "",
                                    color: MyColors.blackColor40,
                                    maxLines: 2, // Added max lines for safety
                                    overflow: TextOverflow.ellipsis, // Ensure explicit overflow handling
                                  ),
                              ],
                            ),
                          ),
                          // ---------------------------------------------------------
                          const SizedBox(width: 5), // Added small gap so text doesn't touch button
                          CustomButton(
                            text: InstantBookingStatus.getName(
                                instantBooking.status),
                            onTap: () {
                              // CustomNavigation.push(context: context, screen: const GuideProfileScreen());
                            },
                            isFlexible: true,
                            fontWeight: FontWeight.w600,
                            borderRadius: 4,
                            fontSize: 9,
                            verticalMargin: 0,
                            isBorder: true,
                            verticalPadding: 2,
                            borderColor: InstantBookingStatus.getColor(
                                instantBooking.status),
                            textColor: InstantBookingStatus.getColor(
                                instantBooking.status),
                            color: InstantBookingStatus.getColor(
                                instantBooking.status)
                                .withOpacity(0.05),
                            horizontalPadding: 6,
                          ),
                        ],
                      ),
                      vSizedBox02,
                      if (instantBooking.remark.isNotEmpty &&
                          instantBooking.status == InstantBookingStatus.booked)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.smallText(
                              'Booking Id  :',
                            ),
                            hSizedBox,
                            Expanded(
                              child: CustomText.smallText(
                                instantBooking.remark,
                              ),
                            ),
                          ],
                        ),
                      if (instantBooking.remark.isNotEmpty &&
                          instantBooking.status == InstantBookingStatus.booked)
                        vSizedBox02,
                      CustomText.smallText(
                        'Description: ${instantBooking.description}',
                      ),
                      vSizedBox02,
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.smallText(
                  'Requested Date   :',
                ),
                hSizedBox,
                Expanded(
                  child: CustomText.smallText(
                    CustomTimeFunctions.formatDateTimeInEst(
                        instantBooking.updatedAt),
                  ),
                ),
              ],
            ),
            if (instantBooking.sessionDatetime.isNotEmpty) vSizedBox02,
            if (instantBooking.sessionDatetime.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.smallText(
                    'Session date time:',
                  ),
                  hSizedBox,
                  Expanded(
                    child: CustomText.smallText(
                      instantBooking.sessionDatetime,
                    ),
                  ),
                ],
              ),
            if (instantBooking.remark.isNotEmpty &&
                instantBooking.status != InstantBookingStatus.booked)
              vSizedBox02,
            if (instantBooking.remark.isNotEmpty &&
                instantBooking.status != InstantBookingStatus.booked)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.smallText(
                    instantBooking.status == InstantBookingStatus.rejected
                        ? 'Reject Reason      :'
                        : instantBooking.status == InstantBookingStatus.canceled
                        ? 'Cancel Reason      :'
                        : 'Remark                  :',
                  ),
                  hSizedBox,
                  Expanded(
                    child: CustomText.smallText(
                      instantBooking.remark,
                    ),
                  ),
                ],
              ),
            vSizedBox02,
            if (instantBooking.status == InstantBookingStatus.pending &&
                usertype == UserType.guide)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Accept',
                      onTap: () {
                        InstantBookingProvider instantBookingProvider =
                        Provider.of<InstantBookingProvider>(context,
                            listen: false);

                        instantBookingProvider.showAcceptBookingDialog(
                          id: instantBooking.id.toString(),
                        );
                      },
                      isFlexible: true,
                      borderRadius: 6,
                      fontSize: 12,
                      color: MyColors.greenColor,
                      verticalMargin: 0,
                      verticalPadding: 4,
                      horizontalPadding: 10,
                    ),
                    hSizedBox,
                    CustomButton(
                      text: 'Reject',
                      onTap: () {
                        InstantBookingProvider instantBookingProvider =
                        Provider.of<InstantBookingProvider>(context,
                            listen: false);
                        instantBookingProvider.showRejectDialog(
                            id: instantBooking.id.toString());
                      },
                      isFlexible: true,
                      borderRadius: 6,
                      fontSize: 12,
                      color: MyColors.redColor,
                      verticalMargin: 0,
                      verticalPadding: 4,
                      horizontalPadding: 11,
                    ),
                  ],
                ),
              ),
            if (instantBooking.status == InstantBookingStatus.accepted &&
                usertype == UserType.student)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'Pay',
                    onTap: () {
                      showCustomBottomSheet(
                          context: context,
                          paddingHorizontal: 0,
                          child: PayInstanceBooking(
                            instantBooking: instantBooking,
                          ));
                    },
                    isFlexible: true,
                    fontWeight: FontWeight.w600,
                    borderRadius: 6,
                    fontSize: 12,
                    verticalMargin: 0,
                    verticalPadding: 4,
                    horizontalPadding: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}