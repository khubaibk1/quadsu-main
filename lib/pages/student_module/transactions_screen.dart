import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/provider/transaction_provider.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

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
        titleText: 'Transactions',
      ),
      body:Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child){

          if(transactionProvider.transactionModel != null)
            {

              if(transactionProvider.transactions.isNotEmpty) {
                return CustomPaginatedListView(
                  onRefresh: () async {
                    transactionProvider.transactionsOffset = 1;
                    transactionProvider.isLastData = false;
                    transactionProvider.transactionsRefresh = true;
                    await transactionProvider.getTransactions();
                    transactionProvider.transactionsRefresh = false;
                  },
                  onLoadMore: () async {
                    transactionProvider.transactionsOffset =
                        transactionProvider
                            .transactionsOffset + 1;
                    await transactionProvider.getTransactions();
                  },
                padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 15),
                itemCount: transactionProvider.transactions.length,
                itemBuilder: (context, index) {
                    final transaction=transactionProvider.transactions[index];
                  return Column(children: [
                    Row(
                      children: [
                        Transform.rotate(
                          angle: pi, // 360 degrees in radians
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
                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText.bodyText2('$cur ${transaction.amount}',
                                    color: MyColors.primaryColor,
                                    increamentFontSize: 1,
                                  ),
                                  CustomText.bodyText2('Booking Id: #${transaction.bookingId}',
                                  )
                                ],
                              ),
                              vSizedBox02,
                              CustomText.smallText('Transaction ID #${transaction.trxId}',
                                color: MyColors.blackColor50,
                                fontSize: 10,
                              ),

                              vSizedBox02,
                              if(transaction.bookingDatetime.isNotEmpty)
                              CustomText.smallText('Booking Date #${CustomTimeFunctions.formatDateTime(transaction.bookingDatetime)}',
                                color: MyColors.blackColor50,
                                fontSize: 10,
                              ),
                              vSizedBox05,
                              Row(
                                children: [
                                  Image.asset(MyImagesUrl.calendar,width: 11,),
                                  hSizedBox05,
                                  CustomText.smallText(CustomTimeFunctions.formatDateTime(transaction.createdAt),
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
                      color:  Color(0xFFF8F8F8),
                    )
                  ],);
                },);
              }
              else
                {
                  return  Center(
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
                  );
                }

            }
          else
            {
              return const SizedBox();

            }
        }
      ),
    );
  }
}
