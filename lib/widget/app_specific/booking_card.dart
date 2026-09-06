import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/extensions/capitalise_first_letter.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/functions/validation_functions.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/pages/bottom_sheet/scheduled_details.dart';
import 'package:quadsu_app/services/metting_services/meeting_video_call_screen.dart';
import 'package:quadsu_app/widget/custom_confirmation_dialog.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_rating.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../constants/types/user_type.dart';
import '../../functions/showCustomBottomSheet.dart';
import '../../modal/session_model.dart';
import '../../pages/bottom_sheet/rating_sheet.dart';
import '../../pages/bottom_sheet/session_recordings.dart';
import '../../pages/guide_module/student_profile.dart';
import '../../pages/student_module/guide_profile_screen.dart';
import '../../provider/sessions_provider.dart';
import '../../services/custom_navigation_services.dart';
import '../custom_button.dart';
import '../custom_image.dart';
import '../custom_text.dart';
import '../custom_text_field.dart';
import 'custom_shadow_container.dart';

class BookingCard extends StatelessWidget {
  final int sessionType;
  final List<Session> list;

  const BookingCard({super.key, required this.sessionType, required this.list});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionsProvider>(
        builder: (context, sessionProvider, child) {
      if (list.isNotEmpty) {
        return CustomPaginatedListView(
          onRefresh: () async {
            sessionProvider.resetOffset(sessionType: sessionType);
            sessionProvider.changeSessionIsLast(sessionStatus: sessionType);
            sessionProvider.changeSessionIsRefresh(sessionStatus: sessionType);
            await sessionProvider.getSession(sessionStatus: sessionType);
            sessionProvider.changeSessionIsRefresh(
                sessionStatus: sessionType, value: false);
          },
          onLoadMore: () async {
            sessionProvider.setOffset(sessionType: sessionType);
            await sessionProvider.getSession(sessionStatus: sessionType);
          },
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          itemCount: list.length,
          itemBuilder: (context, index) {
            Session session = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomShadowContainer(
                horizontalPadding: 0,
                verticalPadding: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:  () {
                        if(usertype ==UserType.student)
                        {
                          CustomNavigation.push(
                              context: context,
                              screen:  GuideProfileScreen(guideId: session.guide!.id!,));
                        }
                        else
                        {
                          CustomNavigation.push(context: context, screen:  StudentProfileScreen(studentId: session.student?.id??0,));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        child: Row(
                          children: [
                            CustomImage(
                              imageUrl: usertype == UserType.student
                                  ? session.guideData?.profileImage ?? ''
                                  : session.student?.profileImage ?? '',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText.bodyText2(
                                        usertype == UserType.student
                                            ? '${session.guide?.firstName} ${session.guide?.lastName}'
                                            : '${session.student?.firstName} ${session.student?.lastName}',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      hSizedBox,
                                      CustomButton(
                                        text: SessionStatus.getName(
                                            session.sessionStatus),
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
                                        borderColor: SessionStatus.getColor(
                                            session.sessionStatus),
                                        textColor: SessionStatus.getColor(
                                            session.sessionStatus),
                                        color: SessionStatus.getColor(
                                                session.sessionStatus)
                                            .withOpacity(0.05),
                                        horizontalPadding: 6,
                                      ),
                                    ],
                                  ),
                                  if (session.guideData?.speciality.isNotEmpty ==
                                      true)
                                    vSizedBox02,
                                  if (session.guideData?.speciality.isNotEmpty ==
                                      true)
                                    CustomText.smallText(
                                      session.guideData?.speciality ?? '',
                                      height: 1,
                                      textAlign: TextAlign.start,
                                      color: MyColors.blackColor40,
                                    ),
                                  vSizedBox05,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomText.smallText(
                                          'Booking ID:',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: CustomText.smallText(
                                          '#${session.bookingId}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Expanded(
                                  //       flex: 2,
                                  //       child: CustomText.smallText(
                                  //         'Booking Date:',
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       flex: 3,
                                  //       child: CustomText.smallText(
                                  //         CustomTimeFunctions.formatDateTime(
                                  //             session.scheduledSessions
                                  //                     ?.createdAt ??
                                  //                 ""),
                                  //         color: MyColors.blackColor40,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: CustomText.smallText(
                                          'Booked Session Date:',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: CustomText.smallText(
                                          CustomTimeFunctions.convertDateFormat(
                                              session.scheduledSessions?.date ??
                                                  ""),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomText.smallText(
                                          'Booking time:',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: CustomText.smallText(
                                          '${CustomTimeFunctions.convertTo12HourFormat(session.scheduledSessions?.startTime ?? "")} to ${CustomTimeFunctions.convertTo12HourFormat(session.scheduledSessions?.endTime ?? "")}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  vSizedBox05,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (usertype == UserType.guide &&  session.meetingStatus.isNotEmpty)
                                        CustomButton(
                                          text: session.meetingStatus,
                                          onTap: () async {
                                           await  CustomNavigation.push(
                                                context: context,
                                                screen:  MeetingVideoCallScreen(channelId: session.bookingId.toString(), meetingTitle: 'Meeting', isCreate: session.meetingStatus==MeetingStatus.startCall, meetingUrl: session.meetingUrl,));
                                              sessionProvider.resetOffset(sessionType: SessionStatus.all);
                                              sessionProvider.getSession(sessionStatus: SessionStatus.all);
                                              sessionProvider.resetOffset(sessionType: SessionStatus.running);
                                              sessionProvider.getSession(sessionStatus: SessionStatus.running);
                                              sessionProvider.resetOffset(sessionType: SessionStatus.cancelled);
                                              sessionProvider.getSession(sessionStatus: SessionStatus.cancelled);
                                              sessionProvider.resetOffset(sessionType: SessionStatus.completed);
                                              sessionProvider.getSession(sessionStatus: SessionStatus.completed);
                                          },
                                          isFlexible: true,
                                          borderRadius: 5,
                                          fontSize: 11,
                                          verticalMargin: 0,
                                          verticalPadding: 4,
                                          color: MyColors.greenColor,
                                          horizontalPadding: 7,
                                        ),

                                      if (usertype == UserType.student &&  session.meetingUrl.isNotEmpty && session.sessionStatus==SessionStatus.pending)
                                          CustomButton(
                                            text: 'Join call',
                                            onTap: () async {
                                             await  CustomNavigation.push(
                                                  context: context,
                                                  screen:  MeetingVideoCallScreen(channelId: session.bookingId.toString(), meetingTitle: 'Meeting', isCreate: false, meetingUrl: session.meetingUrl,));

                                             sessionProvider.resetOffset(sessionType: SessionStatus.all);
                                             sessionProvider.getSession(sessionStatus: SessionStatus.all);
                                             sessionProvider.resetOffset(sessionType: SessionStatus.running);
                                             sessionProvider.getSession(sessionStatus: SessionStatus.running);
                                             sessionProvider.resetOffset(sessionType: SessionStatus.cancelled);
                                             sessionProvider.getSession(sessionStatus: SessionStatus.cancelled);
                                             sessionProvider.resetOffset(sessionType: SessionStatus.completed);
                                             sessionProvider.getSession(sessionStatus: SessionStatus.completed);
                                            },
                                            isFlexible: true,
                                            borderRadius: 5,
                                            fontSize: 11,
                                            verticalMargin: 0,
                                            verticalPadding: 4,
                                            color: MyColors.greenColor,
                                            horizontalPadding: 7,
                                          ),



                                      if (usertype == UserType.student &&
                                          session.sessionStatus == SessionStatus.completed
                                            &&(session.scheduledSessions?.rating == null||session.scheduledSessions?.rating ==0.0))
                                        CustomButton(
                                          text: 'Give Rating',
                                          onTap: () {
                                            showCustomBottomSheet(
                                                context: context,
                                                child: RatingSheet(session: session,));
                                          },
                                          isFlexible: true,
                                          borderRadius: 5,
                                          fontSize: 11,
                                          verticalMargin: 8,
                                          verticalPadding: 3,
                                          color: MyColors.greyColor,
                                          horizontalPadding: 10,
                                        ),

                                      if (usertype == UserType.student &&
                                          session.sessionStatus == SessionStatus.completed)
                                        CustomButton(
                                          text: 'Recordings',
                                          onTap: () {
                                            CustomNavigation.push(context: context, screen:  SessionRecordings(bookingId:session.bookingId ,));
                                          },
                                          isFlexible: true,
                                          borderRadius: 5,
                                          fontSize: 12,
                                          verticalMargin: 0,
                                          verticalPadding: 3,
                                          horizontalPadding: 8,
                                        ),

                                      if (usertype == UserType.guide &&
                                          session.cancelButtonStatus == "1")
                                        CustomButton(
                                          text: 'Cancel',
                                          onTap: () {
                                            var formKey = GlobalKey<FormState>();
                                            var reasonController =
                                                TextEditingController();
                                            // showSnackbar("Coming Soon");
                                            showCustomConfirmationDialog(
                                              headingIcon: Icons.cancel_outlined,
                                              headingMessage:
                                                  "Are you sure you want to cancel this booking?",
                                              widget: Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          reasonController,
                                                      headingText:
                                                          'Reason for cancellation :',
                                                      hintText:
                                                          "Please write a reason",
                                                      hintTextFontSize: 14,
                                                      fontSize: 14,
                                                      contentPaddingVertical: 11,
                                                      validator: (val) {
                                                        return ValidationFunction
                                                            .requiredValidation(
                                                                val);
                                                      },
                                                      keyboardType: TextInputType
                                                          .emailAddress,
                                                    ),
                                                    vSizedBox2,
                                                  ],
                                                ),
                                              ),
                                              okButtonClick: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  Navigator.pop(context, true);
                                                  SessionsProvider sessionsProvider = Provider
                                                          .of<SessionsProvider>(
                                                              context,
                                                              listen: false);
                                                  await sessionsProvider
                                                      .cancelSession(request: {
                                                    //"refund_id": "Testygvbhxcsjch789",
                                                    "booking_id": session.bookingId.toString(),
                                                    "cancel_reason": reasonController.text.trim(),
                                                  },
                                                  trxId: session.transaction?.trxId??"", amount: session.scheduledSessions?.totalPaidAmount??0.0);

                                                  sessionsProvider.resetOffset(
                                                      sessionType:
                                                          SessionStatus.all);
                                                  sessionsProvider.getSession(
                                                      sessionStatus:
                                                          SessionStatus.all);
                                                  sessionsProvider.resetOffset(
                                                      sessionType:
                                                          SessionStatus.running);
                                                  sessionsProvider.getSession(
                                                      sessionStatus:
                                                          SessionStatus.running);
                                                  sessionsProvider.resetOffset(
                                                      sessionType: SessionStatus
                                                          .completed);
                                                  sessionsProvider.getSession(
                                                      sessionStatus: SessionStatus
                                                          .completed);
                                                  sessionsProvider.resetOffset(
                                                      sessionType: SessionStatus
                                                          .cancelled);

                                                  sessionsProvider.getSession(
                                                      sessionStatus: SessionStatus.cancelled);
                                                }
                                              },
                                            );
                                          },
                                          isFlexible: true,
                                          borderRadius: 5,
                                          fontSize: 11,
                                          verticalMargin: 0,
                                          verticalPadding: 4,
                                          color: MyColors.redColor,
                                          horizontalPadding: 7,
                                        ),
                                        CustomButton(
                                        text: 'Detail',
                                        onTap: () {
                                          print("datdatdatdadt${usertype == UserType.student}");
                                          print("datdatdatdadt${session.sessionStatus}");
                                          print("datdatdatdadt${session.meetingUrl}");
                                          session.scheduledSessions
                                                  ?.guidePrefrence =
                                              session.guideData;
                                          session.scheduledSessions?.guideData =
                                              session.guide;
                                          session.scheduledSessions?.guideData =
                                              session.guide;
                                          session.scheduledSessions
                                                  ?.studentPrefrence =
                                              session.student;
                                          showCustomBottomSheet(
                                              context: context,
                                              child: ScheduledDetailsSheet(
                                                scheduledSessions:
                                                    session.scheduledSessions!,
                                              ));
                                        },
                                        isFlexible: true,
                                        borderRadius: 5,
                                        fontSize: 12,
                                        verticalMargin: 0,
                                        verticalPadding: 3,
                                        horizontalPadding: 8,
                                      ),

                                    ],
                                  ),
                                  vSizedBox05,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (session.sessionStatus == SessionStatus.completed && session.scheduledSessions?.rating != null && session.scheduledSessions?.rating!= 0.0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        color: MyColors.containerBgColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomImage(
                                  imageUrl: usertype == UserType.guide
                                      ? session.student?.profileImage ?? ''
                                      : userDataNotifier.value?.studentPrefrence?.profileImage??"",
                                  staticBlurImage: MyImagesUrl.profileImage,
                                  height: 30,
                                  width: 30,
                                  isShowStackImage: true,
                                  fileType: CustomFileType.network,
                                ),
                                hSizedBox,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText.smallText(
                                                usertype == UserType.guide
                                                    ? '${session.student?.firstName} ${session.student?.lastName}'
                                                    : '${userDataNotifier.value?.firstName} ${userDataNotifier.value?.lastName!= null&& userDataNotifier.value?.lastName.isNotEmpty==true?userDataNotifier.value?.lastName[0].capitalize():""}',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              vSizedBox02,
                                               CustomRating(
                                                rating: session.scheduledSessions?.rating ??1.0,
                                                itemSize: 8,
                                              )
                                            ],
                                          ),
                                          CustomText.smallText(
                                            CustomTimeFunctions.formatDateTime(session.scheduledSessions?.ratingDt??""),
                                            color: MyColors.blackColor50,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if(session.scheduledSessions?.ratingComment != null && session.scheduledSessions?.ratingComment?.isNotEmpty==true)
                              vSizedBox05,
                            if(session.scheduledSessions?.ratingComment != null && session.scheduledSessions?.ratingComment?.isNotEmpty==true)

                              CustomText.smallText(
                                session.scheduledSessions?.ratingComment??"",
                              color: MyColors.blackColor50,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CustomText.bodyText1(
                  'No ${SessionStatus.getName(sessionType)} found',
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
