import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/provider/notification_provider.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_rich_text.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';

import '../../modal/notification_model.dart';
import '../../widget/custom_image.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        NotificationProvider notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);

        notificationProvider.offset = 1;
        notificationProvider.getNotification();
        MyAuthProvider myAuthProvider =
        Provider.of<MyAuthProvider>(context, listen: false);
        myAuthProvider.unreadNotificationsCount.value=0;
        myAuthProvider.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Notification',
      ),
      body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
        if (notificationProvider.notification != null) {
          return Column(
            children: [
              if (notificationProvider.notificationList.isNotEmpty)
                Expanded(
                  child: CustomPaginatedListView(
                    onRefresh: () async {
                      notificationProvider.offset = 1;
                      notificationProvider.isLastNotification = false;
                      notificationProvider.isRefresh = true;
                      await notificationProvider.getNotification();
                      notificationProvider.isRefresh = false;
                    },
                    onLoadMore: () async {
                      notificationProvider.offset =
                          notificationProvider.offset + 1;
                      await notificationProvider.getNotification();
                    },
                    wantLoadMore: true,
                    isLastPage: notificationProvider.isLastNotification,
                    padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: globalHorizontalPadding,
                        right: globalHorizontalPadding),
                    itemCount: notificationProvider.notificationList.length,
                    itemBuilder: (context, index) {
                      final Message message =
                          notificationProvider.notificationList[index];
                      return GestureDetector(
                        onTap: () {
                          NotificationProvider.handleNotification(context: context,data:message.fullData );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomImage(
                                  imageUrl: message.senderImage ?? '',
                                  staticBlurImage: MyImagesUrl.profileImage,
                                  height: 60,
                                  width: 60,
                                  isShowStackImage: false,
                                  fileType: CustomFileType.network,
                                ),
                                hSizedBox,
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    vSizedBox05,
                                    CustomRichText(
                                      firstText: '${message.senderName} ',
                                      firstTextFontSize: 13,
                                      firstTextFontWeight: FontWeight.w600,
                                      firstTextColor: MyColors.primaryColor,
                                      secondText: message.msg,
                                      secondTextFontSize: 12,
                                    ),
                                    CustomText.smallText(
                                      CustomTimeFunctions.timeAgo(
                                          DateTime.parse(message.createdAt)),
                                      increamentFontSize: 1,
                                      color: MyColors.blackColor50,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            if (index !=
                                notificationProvider.notificationList.length - 1)
                              const Divider(
                                height: 32,
                                color: Color(0xFFF8F8F8),
                              )
                            else if(notificationProvider.isLastNotification==false)
                              const SizedBox(
                                height: 60,
                              ),
                            if (notificationProvider.isLastNotification &&
                                index ==
                                    notificationProvider.notificationList.length -
                                        1)
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, bottom: 30),
                                  child: CustomText.heading(
                                    'End',
                                    color: MyColors.primaryColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
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
                            'No Notifications found',
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
