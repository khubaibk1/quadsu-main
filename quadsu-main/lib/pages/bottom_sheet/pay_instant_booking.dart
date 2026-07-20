import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/functions/common_function.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/response_modal.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/provider/instant_booking_provider.dart';
import 'package:quadsu_app/services/pay_pal_service.dart';
import 'package:quadsu_app/services/paypal_v2_service.dart';
import 'package:quadsu_app/widget/custom_button.dart';

import '../../constants/api_keys.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../modal/instant_booking_model.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/app_specific/expanded_row_widget.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_text.dart';

class PayInstanceBooking extends StatelessWidget {
  double totalHours=0.0;
  double totalCost=0.0;
  int  serviceFeePar=20;
  double serviceFee = 0.0;
  int taxPar=6;
  double tax = 0.0;
  double grandTotal=0.0;
  PayInstanceBooking({super.key, required this.instantBooking});

  final InstantBooking instantBooking;

  final TextEditingController commentController = TextEditingController();




  @override
  Widget build(BuildContext context) {

    totalHours =
        CustomTimeFunctions.calculateTimeDifference(
            CustomTimeFunctions.convertTo12HourFormat( instantBooking.startTime) ,
            CustomTimeFunctions.convertTo12HourFormat( instantBooking.endTime) );
    totalCost = totalHours *
        (double.tryParse(myAppSettings?.sessionPrice ??
            "0.0") ??
            0.0);
    serviceFee = (totalCost * serviceFeePar) / 100;
    tax = (totalCost * taxPar) / 100;
    grandTotal = totalCost + serviceFee + tax;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomText.headingSmall(
            'Pay Instant Booking',
            fontWeight: FontWeight.w600,
          ),
        ),
        vSizedBox,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: MyColors.blackColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomImage(
                    imageUrl:
                        instantBooking.guidePreference?.profileImage ?? '',
                    staticBlurImage: MyImagesUrl.profileImage,
                    height: 70,
                    width: 70,
                    isShowStackImage: true,
                    fileType: CustomFileType.network,
                  ),
                  hSizedBox15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.headingSmall(
                        "${instantBooking.guideData?.firstName} ${instantBooking.guideData?.lastName}",
                        fontWeight: FontWeight.w600,
                      ),
                      vSizedBox02,
                      if (instantBooking
                              .guidePreference?.speciality.isNotEmpty ==
                          true)
                        CustomText.smallText(
                          instantBooking.guidePreference?.speciality ?? "",
                          fontSize: 10,
                          color: MyColors.blackColor40,
                        ),
                    ],
                  ),
                ],
              ),
              CustomText.bodyText2(
                'Date: ${CustomTimeFunctions.convertDateFormat( instantBooking.date)}',
                fontSize: 13,
              ),
              vSizedBox05,
              Row(
                children: [
                  CustomText.bodyText2(
                    'Start Time: ${CustomTimeFunctions.convertTo12HourFormat( instantBooking.startTime)}',
                    fontSize: 13,
                  ),
                  hSizedBox3,
                  CustomText.bodyText2(
                    'End Time: ${CustomTimeFunctions.convertTo12HourFormat( instantBooking.endTime)}',
                    fontSize: 13,
                  ),
                ],
              )
            ],
          ),
        ),
        vSizedBox2,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandedRowWidget(
                  title: 'Total Hours', subTitle: '${formatToTwoDecimalPlaces(totalHours)} hours', vertical: 4),
              ExpandedRowWidget(
                  title: 'Total Cost', subTitle: '$cur${formatToTwoDecimalPlaces(totalCost)}', vertical: 4),
              ExpandedRowWidget(
                  title: 'Service Fee ($serviceFeePar%)', subTitle: '$cur${formatToTwoDecimalPlaces(serviceFee)}', vertical: 4),
              ExpandedRowWidget(
                  title: 'Tax ($taxPar%)', subTitle:'$cur${formatToTwoDecimalPlaces(tax)}', vertical: 4),
              ExpandedRowWidget(
                  title: 'Grand Total',
                  subTitle:  '$cur${formatToTwoDecimalPlaces(grandTotal)}',
                  fontWeight: FontWeight.w600,
                  vertical: 4), vSizedBox2,
              CustomButton(
                onTap: () async {
                  BookGuideProvider bookGuideProvider=Provider.of<BookGuideProvider>(context,listen: false);
                  InstantBookingProvider instantBookingProvider=Provider.of<InstantBookingProvider>(context,listen: false);
                  CustomNavigation.pop(context);

                  if(myAppSettings?.isHide==true)
                    {
                      ResponseModal ?response=  await bookGuideProvider.createBooking(request: {
                        ApiKeys.trxId:"TestPayPalId54325342",
                        ApiKeys.instantId:instantBooking.id,
                        ApiKeys.paymentGateway:"PayPal",
                        ApiKeys.selectedDate: CustomTimeFunctions.formatDateNew(DateTime.parse(instantBooking.date)),
                        ApiKeys.startTime: CustomTimeFunctions.convertTo12HourFormat( instantBooking.startTime),
                        ApiKeys.endTime: CustomTimeFunctions.convertTo12HourFormat( instantBooking.endTime),
                        ApiKeys.guideId:instantBooking.guidePreference?.userId,
                        ApiKeys.studentId:userDataNotifier.value?.userId,
                        ApiKeys.totalHours:formatToTwoDecimalPlaces(totalHours),
                        ApiKeys.totalHoursCost:formatToTwoDecimalPlaces(totalCost),
                        ApiKeys.serviceFee:formatToTwoDecimalPlaces(serviceFee),
                        ApiKeys.tax:formatToTwoDecimalPlaces(tax),
                        ApiKeys.totalPaidAmount:formatToTwoDecimalPlaces(grandTotal),
                      });


                      if(response != null)
                      {
                        instantBookingProvider.instantSessionsOffset=1;
                        instantBookingProvider.getInstantBooking();
                        Future.delayed(
                          const Duration(milliseconds: 500),
                              () {
                            showPaymentConfirmPopup(
                                message: response.message??"");
                          },
                        );

                      }
                    }
                  else
                    {
                      usePayPalV2(
                        payAmount: grandTotal,
                        onSuccess: (String orderId) async {
                          ResponseModal? response =
                              await bookGuideProvider.createBooking(request: {
                            ApiKeys.trxId: orderId,
                            ApiKeys.instantId: instantBooking.id,
                            ApiKeys.paymentGateway: "PayPal",
                            ApiKeys.selectedDate: CustomTimeFunctions.formatDateNew(
                                DateTime.parse(instantBooking.date)),
                            ApiKeys.startTime:
                                CustomTimeFunctions.convertTo12HourFormat(
                                    instantBooking.startTime),
                            ApiKeys.endTime:
                                CustomTimeFunctions.convertTo12HourFormat(
                                    instantBooking.endTime),
                            ApiKeys.guideId: instantBooking.guidePreference?.userId,
                            ApiKeys.studentId: userDataNotifier.value?.userId,
                            ApiKeys.totalHours: formatToTwoDecimalPlaces(totalHours),
                            ApiKeys.totalHoursCost: formatToTwoDecimalPlaces(totalCost),
                            ApiKeys.serviceFee: formatToTwoDecimalPlaces(serviceFee),
                            ApiKeys.tax: formatToTwoDecimalPlaces(tax),
                            ApiKeys.totalPaidAmount: formatToTwoDecimalPlaces(grandTotal),
                          });

                          if (response != null) {
                            instantBookingProvider.instantSessionsOffset = 1;
                            instantBookingProvider.getInstantBooking();
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                showPaymentConfirmPopup(
                                    message: response.message ?? "");
                              },
                            );
                          }
                        },
                        onCancel: () {
                          showPaymentCancelPopup();
                        },
                        onError: (errorResult) {
                          showPaymentCancelPopup();
                        },
                        message:
                            'Appointment for booking with ${instantBooking.guideData?.firstName ?? ""} ${instantBooking.guideData?.lastName ?? ""} at ${CustomTimeFunctions.formatDateddmmyy(DateTime.parse(instantBooking.date))} ${CustomTimeFunctions.convertTo12HourFormat(instantBooking.startTime)} to ${CustomTimeFunctions.convertTo12HourFormat(instantBooking.endTime)}.',
                      );
                    }

                },
                height: 45,
                text: myAppSettings?.isHide==true?"Book now":'Pay now',
                verticalMargin: 0,
                borderRadius: 4,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        )
      ],
    );
  }
}
