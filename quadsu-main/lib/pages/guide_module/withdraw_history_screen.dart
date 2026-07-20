import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/transaction_model.dart';
import 'package:quadsu_app/provider/withdraw_provider.dart';
import 'package:quadsu_app/widget/app_specific/custom_drawer.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';

class WithdrawScreenScreen extends StatefulWidget {
  const WithdrawScreenScreen({super.key});

  @override
  State<WithdrawScreenScreen> createState() => _WithdrawScreenScreenState();
}

class _WithdrawScreenScreenState extends State<WithdrawScreenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        WithdrawProvider withdrawProvider =
            Provider.of<WithdrawProvider>(context, listen: false);
        withdrawProvider.withdrawsOffset = 1;
        withdrawProvider.getWithdrawHistory();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Withdrawal history',
      ),
      drawer: const CustomDrawer(),
      body: Consumer<WithdrawProvider>(
          builder: (context, withdrawProvider, child) {
        if (withdrawProvider.withdrawModel != null) {
          if (withdrawProvider.withdraws.isNotEmpty) {
            return CustomPaginatedListView(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: globalHorizontalPadding),
              onRefresh: () async {
                withdrawProvider.withdrawsOffset = 1;
                withdrawProvider.isLastData = false;
                withdrawProvider.withdrawsRefresh = true;
                await withdrawProvider.getWithdrawHistory();
                withdrawProvider.withdrawsRefresh = false;
              },
              onLoadMore: () async {
                withdrawProvider.withdrawsOffset =
                    withdrawProvider.withdrawsOffset + 1;
                await withdrawProvider.getWithdrawHistory();
              },
              itemCount: withdrawProvider.withdraws.length,
              itemBuilder: (context, index) {
                final withdraw = withdrawProvider.withdraws[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Transform.rotate(
                          angle: pi,
                          child: const CustomImage(
                            imageUrl: MyImagesUrl.transaction,
                            fileType: CustomFileType.asset,
                            height: 50,
                            width: 50,
                          ),
                        ),
                        hSizedBox15,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText.bodyText2(
                                    '$cur ${withdraw.amount} ${withdraw.withdrawMethod}',
                                    increamentFontSize: 1,
                                    color: MyColors.primaryColor,
                                  ),
                                  CustomButton(
                                    text: WithdrawStatus.getName(
                                        withdrawStatus:
                                            withdraw.withdrawStatus),
                                    onTap: () {},
                                    isFlexible: true,
                                    fontWeight: FontWeight.w600,
                                    borderRadius: 4,
                                    fontSize: 10,
                                    verticalMargin: 0,
                                    isBorder: true,
                                    verticalPadding: 2,
                                    borderColor: WithdrawStatus.getColor(
                                        withdrawStatus:
                                            withdraw.withdrawStatus),
                                    textColor: WithdrawStatus.getColor(
                                        withdrawStatus:
                                            withdraw.withdrawStatus),
                                    color: WithdrawStatus.getColor(
                                            withdrawStatus:
                                                withdraw.withdrawStatus)
                                        .withOpacity(0.05),
                                    horizontalPadding: 6,
                                  ),
                                ],
                              ),
                              vSizedBox02,
                              if (withdraw.withdrawMethod == "Paypal")
                                CustomText.smallText(
                                  'Paypal Email: ${withdraw.payPalEmail}',
                                  color: MyColors.blackColor50,
                                  fontSize: 11,
                                )
                              else
                                CustomText.smallText(
                                  'Venmo Username: ${withdraw.venmoUserName}',
                                  color: MyColors.blackColor50,
                                  fontSize: 11,
                                ),
                              if(withdraw.withdrawStatus==WithdrawStatus.accept&& withdraw.message.isNotEmpty)
                              CustomText.smallText(
                                withdraw.message,
                                color: MyColors.blackColor50,
                                fontSize: 11,
                              ),
                              if(withdraw.withdrawStatus==WithdrawStatus.reject&&withdraw.rejectReason.isNotEmpty )
                                CustomText.smallText(
                                "Reject Reason: ${withdraw.rejectReason}",
                                color: MyColors.blackColor50,
                                  fontSize: 11,
                                ),
                              vSizedBox05,
                              Row(
                                children: [
                                  Image.asset(
                                    MyImagesUrl.calendar,
                                    width: 11,
                                  ),
                                  hSizedBox05,
                                  CustomText.smallText(
                                    CustomTimeFunctions.formatDateTime(
                                        withdraw.createdAt),
                                    color: MyColors.blackColor50,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      height: 30,
                      color: Color(0xFFF8F8F8),
                    )
                  ],
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
                      'No Withdrawal Found',
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
