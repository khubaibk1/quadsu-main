import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/functions/common_function.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/response_modal.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_dropdown.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../services/pay_pal_service.dart';
import '../../services/paypal_v2_service.dart';
import '../../widget/app_specific/custom_shadow_container.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_text.dart';

class ContactToGuideScreen extends StatefulWidget {
  const ContactToGuideScreen({super.key});

  @override
  State<ContactToGuideScreen> createState() => _ContactToGuideScreenState();
}

class _ContactToGuideScreenState extends State<ContactToGuideScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController selectStartTimeController = TextEditingController();
  TextEditingController selectEndTimeController = TextEditingController();
  ValueNotifier<String?> selectedStartDate = ValueNotifier(null);
  ValueNotifier<String?> selectedEndDate = ValueNotifier(null);
  List availabilityList = [];
  List startAvailabilityList = [];
  List endAvailabilityList = [];
  DateTime? picker;

  double totalHours = 0.0;
  double totalCost = 0.0;
  double serviceFee = 0.0;
  int serviceFeePar = 20;
  double tax = 0.0;
  int taxPar = 6;
  double grandTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Profile',
      ),
      body: Consumer<BookGuideProvider>(
          builder: (context, bookGuideProvider, child) {
        final selectedGuide = bookGuideProvider.selectedGuide;
        if (selectedGuide != null) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomImage(
                      imageUrl:
                          selectedGuide.guidePrefrence?.profileImage ?? "",
                      height: 75,
                      width: 75,
                      showLoader: false,
                      isBackgroundImage: false,
                      isShowStackImage: false,
                      fileType: CustomFileType.network,
                    ),
                    hSizedBox,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.heading(
                            '${selectedGuide.firstName } ${selectedGuide.lastName }',
                            fontWeight: FontWeight.w600,
                          ),
                          vSizedBox05,
                          Wrap(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    MyImagesUrl.star_fill,
                                    width: 12,
                                  ),
                                  hSizedBox02,
                                  CustomText.smallText(
                                    '${selectedGuide.avgRatting} (${selectedGuide.guideReviews.length} reviews)',
                                    color: MyColors.blackColor40,
                                  ),
                                  hSizedBox,
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    MyImagesUrl.clock_icon,
                                    width: 12,
                                  ),
                                  hSizedBox02,
                                  CustomText.smallText(
                                    selectedGuide
                                                .guidePrefrence
                                                ?.workingHoursCalculated
                                                .isNotEmpty ==
                                            true
                                        ? "${selectedGuide.guidePrefrence?.workingHoursCalculated.split(":").first} hr ${selectedGuide.guidePrefrence?.workingHoursCalculated.split(":").last} min of guiding"
                                        : "0 hr 00min of guiding",
                                    color: MyColors.blackColor40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          vSizedBox05,
                        ],
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText.bodyText2(
                      'ADD SCHEDULE: ',
                      fontWeight: FontWeight.w600,
                      increamentFontSize: 1,
                    ),
                    CustomText.bodyText1(
                      '(All Times in EST)',
                      fontSize: 12,
                    ),
                  ],
                ),
                vSizedBox,
                CustomShadowContainer(
                  horizontalPadding: 15,
                  verticalPadding: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.bodyText1(
                        'Pick schedule.',
                      ),
                      vSizedBox05,
                      vSizedBox02,
                      CustomTextField(
                        controller: dateController,
                        headingText: 'Date',
                        onTap: () async {
                          picker = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(
                                    2100,
                                  )) ??
                              picker;

                          if (picker != null) {
                            availabilityList.clear();
                            startAvailabilityList.clear();
                            endAvailabilityList.clear();
                            selectedStartDate.value = null;
                            selectedEndDate.value = null;
                            dateController.text = CustomTimeFunctions.formatDateddmmyy(picker!);
                            String selectedDay =
                                CustomTimeFunctions.getDayInitial(picker!);
                            GuideSchedule? guideSchedule = selectedGuide
                                .guideSchedule
                                .where((element) =>
                                    element.day.toLowerCase() ==
                                        selectedDay.toLowerCase() &&
                                    element.isOffDay == "false")
                                .firstOrNull;
                            List<String> slotList = [];

                            if (guideSchedule != null) {
                              slotList =
                                  bookGuideProvider.generateTimeIntervals(
                                      guideSchedule, picker!);
                              // print("dtdadatdatdat:::::::::::::$picker");
                              // print("dtdadatdatdat:::::::::::::$selectedDay");
                              // print("dtdadatdatdat:::::::::::::${guideSchedule.startTime}");
                              // print("dtdadatdatdat:::::::::::::${guideSchedule.endTime}");
                              // print("dtdadatdatdat:::::::::::::$slotList");
                            }

                            for (int i = 0; i < slotList.length; i++) {
                              startAvailabilityList.add({"key": slotList[i]});
                              availabilityList.add({"key": slotList[i]});
                            }

                            if (startAvailabilityList.isNotEmpty) {
                              startAvailabilityList.removeLast();
                            }

                            selectedStartDate.value = null;
                            selectedEndDate.value = null;
                            bookGuideProvider.reload();
                          }
                        },
                        contentPaddingVertical: 11,
                        readOnly: true,
                        contentPaddingHorizonatly: 14,
                        borderRadius: 10,
                        hintColor: MyColors.blackColor.withOpacity(0.4),
                        hintTextFontSize: 14,
                        fontSize: 14,
                        hintText: 'Select date',
                        fillColor: MyColors.whiteColor,
                        suffix: Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                              Image.asset(MyImagesUrl.calendar_fill, width: 20),
                        ),
                      ),
                      vSizedBox2,
                      Row(
                        children: [
                          if (startAvailabilityList.isNotEmpty)
                            ValueListenableBuilder(
                              valueListenable: selectedStartDate,
                              builder: (context, universityValue, child) =>
                                  Expanded(
                                child: CustomDropdownButton(
                                  items: startAvailabilityList,
                                  headingText: "Start Time",
                                  hint: 'Select',
                                  headingFontWeight: FontWeight.w600,
                                  singleSelectedItem: universityValue,
                                  itemMapKey: "key",
                                  onChangedSingle: (val) {
                                    endAvailabilityList.clear();
                                    selectedEndDate.value = null;

                                    selectedStartDate.value = val['key'];
                                    // Find the index of the targetTime
                                    int targetIndex =
                                        availabilityList.indexWhere((time) =>
                                            time["key"] == val["key"]);
                                    // Get all entries after the target time
                                    List filteredTimes = availabilityList
                                        .sublist(targetIndex + 1);
                                    endAvailabilityList =
                                        List.from(filteredTimes);
                                    bookGuideProvider.reload();
                                  },
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: CustomTextField(
                                controller: selectStartTimeController,
                                onTap: () async {
                                  showSnackbar("No slot available");
                                },
                                headingText: 'Start Time',
                                contentPaddingVertical: 11,
                                readOnly: true,
                                contentPaddingHorizonatly: 14,
                                borderRadius: 10,
                                hintColor: MyColors.blackColor.withOpacity(0.4),
                                hintTextFontSize: 14,
                                fontSize: 14,
                                hintText: 'Select',
                                fillColor: MyColors.whiteColor,
                                suffix: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(MyImagesUrl.clock_icon,
                                      width: 20),
                                ),
                              ),
                            ),
                          hSizedBox2,
                          if (endAvailabilityList.isNotEmpty)
                            ValueListenableBuilder(
                              valueListenable: selectedEndDate,
                              builder: (context, universityValue, child) =>
                                  Expanded(
                                child: CustomDropdownButton(
                                  items: endAvailabilityList,
                                  hint: 'Select',
                                  headingText: "End Time",
                                  headingFontWeight: FontWeight.w600,
                                  singleSelectedItem: universityValue,
                                  itemMapKey: "key",
                                  onChangedSingle: (val) async {
                                    selectedEndDate.value = val['key'];
                                    bool result = await bookGuideProvider
                                        .checkAvailability(request: {
                                      ApiKeys.user_Id: selectedGuide.id,
                                      ApiKeys.selectedDate: CustomTimeFunctions.formatDateddmmyy(picker!),
                                      ApiKeys.startSlot: selectedStartDate.value,
                                      ApiKeys.endSlot: selectedEndDate.value,
                                    });

                                    if (result == false) {
                                      selectedStartDate.value = null;
                                      endAvailabilityList.clear();
                                      selectedEndDate.value = null;
                                      bookGuideProvider.reload();
                                    }
                                  },
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: CustomTextField(
                                controller: selectStartTimeController,
                                onTap: () async {
                                  showSnackbar("No slot available");
                                },
                                headingText: 'End Time',
                                contentPaddingVertical: 11,
                                readOnly: true,
                                contentPaddingHorizonatly: 14,
                                borderRadius: 10,
                                hintColor: MyColors.blackColor.withOpacity(0.4),
                                hintTextFontSize: 14,
                                fontSize: 14,
                                hintText: 'Select',
                                fillColor: MyColors.whiteColor,
                                suffix: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(MyImagesUrl.clock_icon,
                                      width: 20),
                                ),
                              ),
                            ),
                        ],
                      ),
                      vSizedBox2,
                      ValueListenableBuilder(
                          valueListenable: selectedEndDate,
                          builder: (context, selectedEndDateValue, child) {
                            if (selectedEndDateValue != null) {
                              totalHours =
                                  CustomTimeFunctions.calculateTimeDifference(
                                      selectedStartDate.value ?? '',
                                      selectedEndDateValue);
                              totalCost = totalHours *
                                  (double.tryParse(selectedGuide
                                              .guidePrefrence?.hourlyRate ??
                                          "0.0") ??
                                      0.0);
                              serviceFee = (totalCost * serviceFeePar) / 100;
                              tax = (totalCost * taxPar) / 100;
                              grandTotal = totalCost + serviceFee + tax;

                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomText.smallText(
                                          'Total Hours',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        vSizedBox05,
                                        CustomText.smallText(
                                          'Total Cost',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        vSizedBox05,
                                        CustomText.smallText(
                                          'Service Fee ($serviceFeePar%)',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        vSizedBox05,
                                        CustomText.smallText(
                                          'Tax ($taxPar%)',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        vSizedBox05,
                                        CustomText.smallText(
                                          'Grand Total',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  hSizedBox2,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText.smallText(
                                        '${formatToTwoDecimalPlaces(totalHours)} hours',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      vSizedBox05,
                                      CustomText.smallText(
                                        '$cur${formatToTwoDecimalPlaces(totalCost)}',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      vSizedBox05,
                                      CustomText.smallText(
                                        '$cur${formatToTwoDecimalPlaces(serviceFee)}',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      vSizedBox05,
                                      CustomText.smallText(
                                        '$cur${formatToTwoDecimalPlaces(tax)}',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      vSizedBox05,
                                      CustomText.smallText(
                                        '$cur${formatToTwoDecimalPlaces(grandTotal)}',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  height: 45,
                  text: myAppSettings?.isHide==true?"Book now":'Pay now',
                  onTap: () async {
                    print("datdatdatdtadta::::${
                         CustomTimeFunctions.formatDateNew(picker!)

                    }");
                    if (picker == null) {
                      showSnackbar("Please select date");
                      return;
                    } else if (selectedStartDate.value == null) {
                      showSnackbar("Please select start time");
                      return;
                    } else if (selectedEndDate.value == null) {
                      showSnackbar("Please select end time");
                      return;
                    } else {
                      if(myAppSettings?.isHide==true)
                        {
                          ResponseModal ?response=  await bookGuideProvider.createBooking(request: {
                            ApiKeys.trxId:"TestPayPalId534342",
                            ApiKeys.paymentGateway:"PayPal",
                            ApiKeys.selectedDate: CustomTimeFunctions.formatDateNew(picker!),
                            ApiKeys.startTime: selectedStartDate.value,
                            ApiKeys.endTime: selectedEndDate.value,
                            ApiKeys.guideId:selectedGuide.id,
                            ApiKeys.studentId:userDataNotifier.value?.userId,
                            ApiKeys.totalHours:formatToTwoDecimalPlaces(totalHours),
                            ApiKeys.totalHoursCost:formatToTwoDecimalPlaces(totalCost),
                            ApiKeys.serviceFee:formatToTwoDecimalPlaces(serviceFee),
                            ApiKeys.tax:formatToTwoDecimalPlaces(tax),
                            ApiKeys.totalPaidAmount:formatToTwoDecimalPlaces(grandTotal),
                          });
                          if(response != null)
                          {
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
                                ApiKeys.paymentGateway: "PayPal",
                                ApiKeys.selectedDate: CustomTimeFunctions.formatDateNew(picker!),
                                ApiKeys.startTime: selectedStartDate.value,
                                ApiKeys.endTime: selectedEndDate.value,
                                ApiKeys.guideId: selectedGuide.id,
                                ApiKeys.studentId: userDataNotifier.value?.userId,
                                ApiKeys.totalHours: formatToTwoDecimalPlaces(totalHours),
                                ApiKeys.totalHoursCost: formatToTwoDecimalPlaces(totalCost),
                                ApiKeys.serviceFee: formatToTwoDecimalPlaces(serviceFee),
                                ApiKeys.tax: formatToTwoDecimalPlaces(tax),
                                ApiKeys.totalPaidAmount: formatToTwoDecimalPlaces(grandTotal),
                              });
                              if (response != null) {
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
                                'Appointment for booking with ${selectedGuide.firstName} ${selectedGuide.lastName} at ${CustomTimeFunctions.formatDateddmmyy(picker!)} ${selectedStartDate.value} to ${selectedEndDate.value}.',
                          );
                        }


                    }
                  },
                  borderRadius: 4,
                  fontWeight: FontWeight.w600,
                ),
                vSizedBox,
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
