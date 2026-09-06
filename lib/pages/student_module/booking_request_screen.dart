import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/provider/instant_booking_provider.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/app_specific/instant_booking_card.dart';
import '../../constants/global_data.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../modal/instant_booking_model.dart';
import '../../widget/app_specific/custom_drawer.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_paginated_list_view.dart';

class InstantRequestScreen extends StatefulWidget {
  final String? bookingId;
  const InstantRequestScreen({super.key, this.bookingId});

  @override
  State<InstantRequestScreen> createState() => _InstantRequestScreenState();
}

class _InstantRequestScreenState extends State<InstantRequestScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        InstantBookingProvider instantBookingProvider =
        Provider.of<InstantBookingProvider>(context, listen: false);
        instantBookingProvider.instantSessionsOffset = 1;
        instantBookingProvider.getInstantBooking();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          isBackIcon: false,
          leadingWidth: 55,
          leadImageUrl: MyImagesUrl.image04,
          titleText: usertype == UserType.guide
              ? 'Instant Booking Request List'
              : 'Booking Request List',
          centerTitle: true,
          isNotificationIcon: true,
        ),
        drawer: const CustomDrawer(),
        body: Consumer<InstantBookingProvider>(
            builder: (context, instantBookingProvider, child) {
              if (instantBookingProvider.instantSessionsModel != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: globalHorizontalPadding, vertical: 10),
                      // -------- CHANGED ROW TO WRAP TO PREVENT OVERFLOW --------
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CustomText.headingSmall(
                            'Instant Booking Request List',
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText.smallText(
                            ' (All Times in EST)',
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      // ---------------------------------------------------------
                    ),
                    vSizedBox05,
                    if (instantBookingProvider.instantSessions.isNotEmpty)
                      Expanded(
                        child: CustomPaginatedListView(
                          onRefresh: () async {
                            instantBookingProvider.instantSessionsOffset = 1;
                            instantBookingProvider.isLastSessions = false;
                            instantBookingProvider.instantSessionsRefresh = true;
                            await instantBookingProvider.getInstantBooking();
                            instantBookingProvider.instantSessionsRefresh = false;
                          },
                          onLoadMore: () async {
                            instantBookingProvider.instantSessionsOffset =
                                instantBookingProvider.instantSessionsOffset + 1;
                            await instantBookingProvider.getInstantBooking();
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: globalHorizontalPadding, vertical: 10),
                          itemCount: instantBookingProvider.instantSessions.length,
                          itemBuilder: (context, index) {
                            final InstantBooking instantBooking =
                            instantBookingProvider.instantSessions[index];

                            return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    InstantBookingCard(
                                      instantBooking: instantBooking,
                                      status: index.isEven ? 0 : 3,
                                    ),
                                  ],
                                ));
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: CustomText.bodyText1(
                                  'No Instant Booking Found',
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                );
              } else {
                return const SizedBox();
              }
            }));
  }
}