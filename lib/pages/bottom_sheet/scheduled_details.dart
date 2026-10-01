import 'package:flutter/cupertino.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/extensions/capitalise_first_letter.dart';
import 'package:quadsu_app/functions/common_function.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../widget/app_specific/expanded_row_widget.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_rating.dart';
import '../../widget/custom_text.dart';

class ScheduledDetailsSheet extends StatelessWidget {
  final ScheduledSessions scheduledSessions;

  /// Tax rate included in what the student paid.
  final int taxPercentage;

  const ScheduledDetailsSheet({
    super.key,
    required this.scheduledSessions,
    this.taxPercentage = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomImage(
              imageUrl: usertype == UserType.student
                  ? (scheduledSessions.guidePrefrence?.profileImage ?? "")
                  : (scheduledSessions.studentPrefrence?.profileImage ?? ""),
              staticBlurImage: MyImagesUrl.profileImage,
              height: 65,
              width: 65,
              isShowStackImage: true,
              fileType: CustomFileType.network,
            ),
            hSizedBox2,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.headingSmall(
                        usertype == UserType.student
                            ? '${scheduledSessions.guideData?.firstName ?? ""} ${scheduledSessions.guideData?.lastName ?? ""}'
                            : '${scheduledSessions.studentPrefrence?.firstName ?? scheduledSessions.studentData?.firstName ?? ''} ${scheduledSessions.studentPrefrence?.lastName ?? scheduledSessions.studentData?.lastName ?? ''}',
                        fontWeight: FontWeight.w600,
                      ),
                      vSizedBox02,
                    ],
                  ),
                  // CustomButton(
                  //   text: SessionStatus.getName(SessionStatus.completed),
                  //   onTap: () {
                  //     // CustomNavigation.push(context: context, screen: const GuideProfileScreen());
                  //   },
                  //   isFlexible: true,
                  //   fontWeight: FontWeight.w600,
                  //   borderRadius: 4,
                  //   fontSize: 7,
                  //   verticalMargin: 0,
                  //   isBorder: true,
                  //   verticalPadding: 3,
                  //   borderColor:
                  //       SessionStatus.getColor(SessionStatus.completed),
                  //   textColor:
                  //       SessionStatus.getColor(SessionStatus.completed),
                  //   color: SessionStatus.getColor(SessionStatus.accepted)
                  //       .withOpacity(0.05),
                  //   horizontalPadding: 6,
                  // ),
                ],
              ),
            ),
          ],
        ),
        vSizedBox2,
        ExpandedRowWidget(
            title: 'Booking ID:', subTitle: '#${scheduledSessions.bookingId}'),
        // ExpandedRowWidget(
        //     title: 'Booking date',
        //     subTitle: CustomTimeFunctions.formatDateTime(
        //         scheduledSessions.createdAt ?? "")),
        ExpandedRowWidget(
            title: 'speciality',
            subTitle: scheduledSessions.guidePrefrence?.speciality ?? ""),
        ExpandedRowWidget(
          title: 'Booked Date',
          subTitle: CustomTimeFunctions.convertDateFormat(
              scheduledSessions.date ?? ""),
        ),
        ExpandedRowWidget(
            title: 'Start and end time',
            subTitle:
                '${CustomTimeFunctions.convertTo12HourFormat(scheduledSessions.startTime ?? "")} to ${CustomTimeFunctions.convertTo12HourFormat(scheduledSessions.endTime ?? "")}'),
        if (scheduledSessions.comment != null &&
            scheduledSessions.comment!.isNotEmpty)
          ExpandedRowWidget(
              title: 'Comments', subTitle: scheduledSessions.comment ?? ""),
        if (scheduledSessions.cancelReason != null &&
            scheduledSessions.cancelReason!.isNotEmpty)
          ExpandedRowWidget(
              title: 'Cancel Reason',
              subTitle: scheduledSessions.cancelReason ?? ""),

        if (scheduledSessions.cancelDt != null &&
            scheduledSessions.cancelDt!.isNotEmpty)
          ExpandedRowWidget(
              title: 'Cancel Date',
              subTitle: CustomTimeFunctions.formatDateTime(
                      scheduledSessions.cancelDt!) ??
                  ""),
        ExpandedRowWidget(
            title: 'Total no of hours',
            subTitle: scheduledSessions.totalHours.toString() ?? ""),
        if (usertype == UserType.student)
          ..._studentAmounts()
        else
          ..._guideAmounts(),
        // if (isComplete == SessionStatus.completed) vSizedBox2,
        // if (isComplete == SessionStatus.completed)
        //   CustomButton(
        //     height: 45,
        //     onTap: () {
        //      // showCustomBottomSheet(context: context, child: RatingSheet(session: sc,));
        //     },
        //     text: 'Rate',
        //     verticalMargin: 0,
        //     borderRadius: 4,
        //     fontWeight: FontWeight.w600,
        //   ),
        // if (false)
        if (scheduledSessions.rating != null &&
            scheduledSessions.rating != 0.0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: MyColors.containerBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomImage(
                      imageUrl: usertype == UserType.guide
                          ? scheduledSessions.studentPrefrence?.profileImage ??
                              ''
                          : userDataNotifier
                                  .value?.studentPrefrence?.profileImage ??
                              "",
                      staticBlurImage: MyImagesUrl.profileImage,
                      height: 30,
                      width: 30,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText.smallText(
                                    usertype == UserType.guide
                                        ? '${scheduledSessions.studentPrefrence?.firstName} ${scheduledSessions.studentPrefrence?.lastName}'
                                        : '${userDataNotifier.value?.firstName} ${userDataNotifier.value?.lastName != null && userDataNotifier.value?.lastName.isNotEmpty == true ? userDataNotifier.value?.lastName[0].capitalize() : ""}',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  vSizedBox02,
                                  CustomRating(
                                    rating: scheduledSessions.rating ?? 1.0,
                                    itemSize: 8,
                                  )
                                ],
                              ),
                              CustomText.smallText(
                                CustomTimeFunctions.formatDateTime(
                                    scheduledSessions.ratingDt ?? ""),
                                color: MyColors.blackColor50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (scheduledSessions.ratingComment != null &&
                    scheduledSessions.ratingComment?.isNotEmpty == true)
                  vSizedBox05,
                if (scheduledSessions.ratingComment != null &&
                    scheduledSessions.ratingComment?.isNotEmpty == true)
                  CustomText.smallText(
                    scheduledSessions.ratingComment ?? "",
                    color: MyColors.blackColor50,
                  ),
              ],
            ),
          )
      ],
    );
  }

  String _money(double value) => '$cur${formatToTwoDecimalPlaces(value)}';

  /// What the student paid, as on the website's booking summary:
  /// session cost + tax = total paid (the total already includes tax).
  List<Widget> _studentAmounts() {
    final totalPaid = scheduledSessions.totalHoursCost ??
        (scheduledSessions.perHoursCost ?? 0) *
            (scheduledSessions.totalHours ?? 1);
    final sessionCost = totalPaid / (1 + taxPercentage / 100);
    return [
      ExpandedRowWidget(title: 'Session cost', subTitle: _money(sessionCost)),
      ExpandedRowWidget(
          title: 'Tax ($taxPercentage%)',
          subTitle: _money(totalPaid - sessionCost)),
      ExpandedRowWidget(
          title: 'Grand Total',
          subTitle: _money(totalPaid),
          fontWeight: FontWeight.w600),
    ];
  }

  /// The guide's view: what the student paid, the QuadsU fee and the
  /// guide's payout.
  List<Widget> _guideAmounts() {
    final hoursTotal = scheduledSessions.totalHoursCost ?? 0.0;
    final fee = scheduledSessions.serviceFee ?? 0.0;
    final feePercent = hoursTotal > 0 ? (fee / hoursTotal * 100).round() : 0;
    return [
      ExpandedRowWidget(
          title: 'Per hour amount',
          subTitle: _money(scheduledSessions.perHoursCost ?? 0.0)),
      ExpandedRowWidget(title: 'Hours total', subTitle: _money(hoursTotal)),
      ExpandedRowWidget(
          title: 'Service fee($feePercent%)', subTitle: _money(fee)),
      ExpandedRowWidget(
          title: 'Tax($taxPercentage%)',
          subTitle: _money(scheduledSessions.tax ?? 0.0)),
      ExpandedRowWidget(
          title: 'Grand Total',
          subTitle: _money(scheduledSessions.totalPaidAmount ?? 0.0),
          fontWeight: FontWeight.w600),
    ];
  }
}
