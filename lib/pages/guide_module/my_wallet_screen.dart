import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/functions/showCustomBottomSheet.dart';
import 'package:quadsu_app/modal/transaction_model.dart';
import 'package:quadsu_app/pages/bottom_sheet/request_withdrawal.dart';
import 'package:quadsu_app/pages/guide_module/withdraw_history_screen.dart';
import 'package:quadsu_app/provider/transaction_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/app_specific/custom_drawer.dart';
import 'package:quadsu_app/widget/common_alert_dailog.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          TransactionProvider transactionProvider =
              Provider.of<TransactionProvider>(context, listen: false);
          transactionProvider.transactionsOffset = 1;
          transactionProvider.getTransactions();
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        isBackIcon: false,
        leadingWidth: 55,
        leadImageUrl: MyImagesUrl.image02,
        titleText: 'My Wallet',
        centerTitle: true,
        isNotificationIcon: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: globalHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      alignment: Alignment.centerRight,
                      image: AssetImage(
                        MyImagesUrl.bg_image01,
                      )),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF35579D), Color(0xFF011E5A)]),
                  boxShadow: [
                    BoxShadow(
                        color: MyColors.blackColor.withOpacity(0.06),
                        blurRadius: 7)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.heading(
                        'Wallet Amount',
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      GestureDetector(
                        onTap: () {
                          CustomNavigation.push(
                              context: context,
                              screen: const WithdrawScreenScreen());
                        },
                        child: CustomText.smallText(
                          'Withdrawal History',
                          increamentFontSize: 2,
                          decoration: TextDecoration.underline,
                          color: MyColors.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  vSizedBox,
                  vSizedBox05,
                  ValueListenableBuilder(
                      valueListenable: userDataNotifier,
                      builder: (context, userdata, child) {
                        return CustomText.heading(
                          '$cur${userdata?.walletAmount}',
                          color: MyColors.whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        );
                      }),
                  vSizedBox,
                  vSizedBox05,
                  ValueListenableBuilder(
                      valueListenable: userDataNotifier,
                      builder: (context, userdata, child) {
                        if (userdata!.walletAmount.isNotEmpty &&
                            userdata.walletAmount != "0" &&
                            userdata.walletAmount != "0.0") {
                          return CustomButton(
                            onTap: () async {

                            bool? value=await   showCommonAlertDailog(
                                MyGlobalKeys.navigatorKey.currentContext!,
                                icon:   const Icon(
                                    Icons.warning,
                                  color: MyColors.redColor,
                                ),
                                headingText: 'Alert',
                              confirmButtonText: "Yes",
                              cancelButtonText: "No",
                              buttonAlignMent: MainAxisAlignment.spaceBetween,
                                message: "Are you sure you want to withdraw the complete wallet amount ?",
                              );

                            if(value==true)
                              {
                                await
                                showCustomBottomSheet(
                                    context: context, child: RequestWithdrawal());
                              }

                            },
                            height: 33,
                            text: 'Request Withdrawal',
                            color: MyColors.whiteColor,
                            fontSize: 12,
                            verticalMargin: 0,
                            verticalPadding: 0,
                            horizontalPadding: 14,
                            isFlexible: true,
                            textColor: MyColors.blackColor,
                            fontWeight: FontWeight.w600,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
            ),
            vSizedBox2,
            CustomText.headingSmall(
              'My Wallet History',
              fontWeight: FontWeight.w600,
            ),
            vSizedBox,
            Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
              if (transactionProvider.transactionModel != null) {
                if (transactionProvider.transactions.isNotEmpty) {
                  return Expanded(
                      child: CustomPaginatedListView(
                    onRefresh: () async {
                      transactionProvider.transactionsOffset = 1;
                      transactionProvider.isLastData = false;
                      transactionProvider.transactionsRefresh = true;
                      await transactionProvider.getTransactions();
                      transactionProvider.transactionsRefresh = false;
                    },
                    onLoadMore: () async {
                      transactionProvider.transactionsOffset =
                          transactionProvider.transactionsOffset + 1;
                      await transactionProvider.getTransactions();
                    },
                        itemCount: transactionProvider.transactions.length,

                        padding: const EdgeInsets.symmetric(vertical: 15),
                    itemBuilder: (context, index) {
                      final transaction =
                          transactionProvider.transactions[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              if (transaction.transactionType == TransactionType.debit)
                                Transform.rotate(
                                  angle: pi,
                                  child:  CustomImage(
                                    imageUrl: MyImagesUrl.transaction,
                                    fileType: CustomFileType.asset,
                                    imageColor: TransactionType.getColor(transactionType: transaction.transactionType),
                                    height: 50,
                                    width: 50,
                                  ),
                                )
                              else
                                 CustomImage(
                                  imageUrl: MyImagesUrl.transaction,
                                  fileType: CustomFileType.asset,
                                  height: 50,
                                  imageColor: TransactionType.getColor(transactionType: transaction.transactionType),
                                  width: 50,
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
                                          '${transaction.transactionType == TransactionType.debit?'-':"+"} $cur ${transaction.amount}',
                                          increamentFontSize: 1,
                                          color:TransactionType.getColor(transactionType: transaction.transactionType),
                                        ),
                                      ],
                                    ),
                                    vSizedBox02,
                                    CustomText.smallText(
                                      transaction.message,
                                      color: MyColors.blackColor50,
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
                                          CustomTimeFunctions.formatDateTime(transaction.createdAt),
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
                  ));
                } else {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CustomText.bodyText1(
                              'No Transactions Found',
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return const SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
