import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/session_model.dart';
import 'package:quadsu_app/pages/bottom_sheet/scheduled_details.dart';
import 'package:quadsu_app/themes/custom_text_styles.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/showCustomBottomSheet.dart';
import '../../provider/sessions_provider.dart';
import '../../widget/app_specific/booking_card.dart';
import '../../widget/app_specific/custom_drawer.dart';
import '../../widget/custom_appbar.dart';

class SessionScreen extends StatefulWidget {
  final String? bokingId;
  const SessionScreen({super.key, this.bokingId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController =
      TabController(length: 4, vsync: this, initialIndex: 0);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        SessionsProvider sessionsProvider =
            Provider.of<SessionsProvider>(context, listen: false);

        sessionsProvider.allSessionsOffset = 1;
        await sessionsProvider.getSession(sessionStatus: SessionStatus.all);
        if (widget.bokingId != null) {
          List<Session> sessionList = sessionsProvider.allSessions
              .where(
                (element) => widget.bokingId == element.bookingId.toString(),
              )
              .toList();
          if (sessionList.isNotEmpty) {
            Session session = sessionList.first;
            session.scheduledSessions?.guidePrefrence = session.guideData;
            session.scheduledSessions?.guideData = session.guide;
            session.scheduledSessions?.guideData = session.guide;
            session.scheduledSessions?.studentPrefrence = session.student;
            showCustomBottomSheet(
                // ignore: use_build_context_synchronously
                context: context,
                child: ScheduledDetailsSheet(
                  scheduledSessions: session.scheduledSessions!,
                ));
          }
        }
        sessionsProvider.runningSessionsOffset = 1;
        sessionsProvider.getSession(sessionStatus: SessionStatus.running);
        sessionsProvider.completedSessionsOffset = 1;
        sessionsProvider.getSession(sessionStatus: SessionStatus.completed);
        sessionsProvider.cancelledSessionsOffset = 1;
        sessionsProvider.getSession(sessionStatus: SessionStatus.cancelled);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          isBackIcon: widget.bokingId != null,
          leadingWidth: 55,
          leadImageUrl: MyImagesUrl.image04,
          titleText: usertype == UserType.guide
              ? 'Scheduled sessions'
              : 'Session List',
          centerTitle: true,
          isNotificationIcon: true,
        ),
        drawer: const CustomDrawer(),
        body: Consumer<SessionsProvider>(
            builder: (context, sessionsProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: globalHorizontalPadding, vertical: 10),
                child: Row(
                  children: [
                    CustomText.headingSmall(
                      usertype == UserType.guide
                          ? 'Scheduled sessions'
                          : 'Session List',
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText.smallText(
                      ' (All Times in EST)',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              vSizedBox05,
              Container(
                color: MyColors.containerBgColor,
                child: TabBar(
                    controller: tabController,
                    dividerHeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: false,
                    labelStyle: CustomTextStyle.labelStyle,
                    indicatorWeight: 3,
                    indicatorColor: MyColors.primaryColor,
                    // tabAlignment: TabAlignment.center,
                    unselectedLabelStyle: CustomTextStyle.unSelectedLabelStyle,
                    labelPadding: EdgeInsets.zero,
                    tabs: const [
                      Tab(
                        child: Text('All'),
                      ),
                      Tab(
                        child: Text('Running'),
                      ),
                      Tab(
                        child: Text('Completed'),
                      ),
                      Tab(
                        child: Text('Cancelled'),
                      ),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    if (sessionsProvider.allSessionsModel != null)
                      BookingCard(
                        // bookingStatus: 0,
                        sessionType: SessionStatus.all,
                        list: sessionsProvider.allSessions,
                      )
                    else
                      const SizedBox(),
                    if (sessionsProvider.runningSessionsModel != null)
                      BookingCard(
                        // bookingStatus: BookingStatus.pending,
                        sessionType: SessionStatus.running,
                        list: sessionsProvider.runningSessions,
                      )
                    else
                      const SizedBox(),
                    if (sessionsProvider.completedSessionsModel != null)
                      BookingCard(
                        // bookingStatus: BookingStatus.completed,
                        sessionType: SessionStatus.completed,
                        list: sessionsProvider.completedSessions,
                      )
                    else
                      const SizedBox(),
                    if (sessionsProvider.cancelledSessionsModel != null)
                      BookingCard(
                        // bookingStatus: BookingStatus.cancelled,
                        sessionType: SessionStatus.cancelled,
                        list: sessionsProvider.canceledSessions,
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ],
          );
        }));
  }

// list({isComplete = false}) {
//   return ListView.builder(
//     padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
//     itemCount: 4,
//     itemBuilder: (context, index) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 15),
//         child: CustomShadowContainer(
//           horizontalPadding: 0,
//           verticalPadding: 0,
//           child: Column(
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: Row(
//                   children: [
//                     const CustomImage(
//                       imageUrl: MyImagesUrl.image01,
//                       height: 70,
//                       width: 70,
//                       isShowStackImage: true,
//                       fileType: CustomFileType.asset,
//                     ),
//                     hSizedBox,
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText.bodyText2(
//                                     'Kasey B',
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   vSizedBox02,
//                                   CustomText.smallText(
//                                     '01-07-2024, 01:30pm',
//                                     color: MyColors.blackColor40,
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   CustomText.smallText(
//                                     'Chemistry',
//                                     color: MyColors.blackColor40,
//                                   ),
//                                   CustomButton(
//                                     text: SessionStatus.getName(
//                                         SessionStatus.accepted),
//                                     onTap: () {
//                                       // CustomNavigation.push(context: context, screen: const GuideProfileScreen());
//                                     },
//                                     isFlexible: true,
//                                     fontWeight: FontWeight.w600,
//                                     borderRadius: 4,
//                                     fontSize: 7,
//                                     verticalMargin: 0,
//                                     isBorder: true,
//                                     verticalPadding: 3,
//                                     borderColor: SessionStatus.getColor(
//                                         SessionStatus.accepted),
//                                     textColor: SessionStatus.getColor(
//                                         SessionStatus.accepted),
//                                     color: SessionStatus.getColor(
//                                             SessionStatus.accepted)
//                                         .withOpacity(0.05),
//                                     horizontalPadding: 6,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           vSizedBox05,
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CustomText.smallText(
//                                         'Booking ID:',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         'Booking date',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         'Start time',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         'End time',
//                                       ),
//                                     ],
//                                   ),
//                                   hSizedBox15,
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CustomText.smallText(
//                                         '#15410',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         '09-07-2024',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         '05:30pm',
//                                       ),
//                                       vSizedBox02,
//                                       CustomText.smallText(
//                                         '06:30pm',
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   CustomButton(
//                                     text: 'Rate',
//                                     onTap: () {
//                                       showCustomBottomSheet(
//                                           context: context,
//                                           child: RatingSheet());
//                                       // CustomNavigation.push(context: context, screen: const GuideProfileScreen());
//                                     },
//                                     isFlexible: true,
//                                     fontWeight: FontWeight.w600,
//                                     borderRadius: 5,
//                                     fontSize: 10,
//                                     verticalMargin: 8,
//                                     verticalPadding: 3,
//                                     color: MyColors.greyColor,
//                                     horizontalPadding: 13,
//                                   ),
//                                   CustomButton(
//                                     text: 'Detail',
//                                     onTap: () {
//                                       // showCustomBottomSheet(
//                                       //     context: context,
//                                       //     child:  ScheduledDetailsSheet(
//                                       //       isComplete: isComplete, scheduledSessions: s,
//                                       //     ));
//                                       // CustomNavigation.push(context: context, screen: const GuideProfileScreen());
//                                     },
//                                     isFlexible: true,
//                                     fontWeight: FontWeight.w600,
//                                     borderRadius: 5,
//                                     fontSize: 10,
//                                     verticalMargin: 0,
//                                     verticalPadding: 3,
//                                     horizontalPadding: 10,
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                           vSizedBox05,
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (isComplete)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 10),
//                   color: MyColors.containerBgColor,
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           const CustomImage(
//                             imageUrl: MyImagesUrl.image01,
//                             height: 30,
//                             width: 30,
//                             isShowStackImage: true,
//                             fileType: CustomFileType.asset,
//                           ),
//                           hSizedBox,
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         CustomText.smallText(
//                                           'Kasey B',
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         vSizedBox02,
//                                         const CustomRating(
//                                           rating: 4,
//                                           itemSize: 8,
//                                         )
//                                       ],
//                                     ),
//                                     CustomText.smallText(
//                                       '01-07-2024, 01:30pm',
//                                       color: MyColors.blackColor50,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       vSizedBox05,
//                       CustomText.smallText(
//                         'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
//                         color: MyColors.blackColor50,
//                       ),
//                     ],
//                   ),
//                 )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
}
