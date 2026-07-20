import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import 'package:quadsu_app/modal/instant_booking_model.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';

import '../constants/sized_box.dart';
import '../functions/validation_functions.dart';
import '../services/api_urls.dart';
import '../services/newest_webservices.dart';
import '../widget/custom_confirmation_dialog.dart';
import '../widget/custom_dropdown.dart';
import '../widget/custom_text.dart';
import '../widget/show_snackbar.dart';
import 'book_guide_provider.dart';

class InstantBookingProvider extends ChangeNotifier {
  bool instantSessionsRefresh = false;
  int instantSessionsOffset = 1;
  bool instantSessionsLoad = false;
  bool isLastSessions = false;
  List<InstantBooking> instantSessions = [];
  InstantBookingModel ? instantSessionsModel;

  Future<void> getInstantBooking() async {
    instantSessionsLoad = true;

    if (instantSessionsOffset == 1 && instantSessionsRefresh == false) {
      EasyLoading.show();
    }

     notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl:usertype==UserType.student? ApiUrls.instantBookingRequestStudent:ApiUrls.instantBookingRequestGuide,
      request: {
        ApiKeys.page: instantSessionsOffset,
      },
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("instant booking :::::::::::::${jsonResponse.data}");

      if (instantSessionsOffset == 1) {
        isLastSessions=false;
        notifyListeners();
        instantSessionsModel = InstantBookingModel.fromJson(jsonResponse.data);
        instantSessions = List.from(instantSessionsModel?.instantBookings??[]);
      } else {
        instantSessionsModel = InstantBookingModel.fromJson(jsonResponse.data);
        if (instantSessionsModel?.instantBookings.isNotEmpty == true) {
          instantSessions = instantSessions+List.from(instantSessionsModel?.instantBookings??[]);
          isLastSessions=false;
          notifyListeners();
        } else {
          isLastSessions=true;
        }
      }
    }

    EasyLoading.dismiss();
    instantSessionsLoad=false;
    notifyListeners();


  }

  Future<void> requestInstantBooking(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.instantBookingRequest,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );

    print("request Instant Booking :::::::::::::${jsonResponse.status}");

    if (jsonResponse.status == 1) {
      CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
    }

    EasyLoading.dismiss();
  }

  Future<void> rejectInstantBooking(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.instantBookingReject,
      request: request,
      apiMethod: ApiMethod.post,
    );

    if (jsonResponse.status == 1) {
      instantSessionsOffset=1;
      getInstantBooking();
    }

    EasyLoading.dismiss();
  }

  Future<void> acceptInstantBooking(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.instantBookingAccept,
      request: request,
      apiMethod: ApiMethod.post,
    );

    print("request Instant Booking :::::::::::::${jsonResponse.status}");

    if (jsonResponse.status == 1) {
      instantSessionsOffset=1;
      getInstantBooking();
    }
    EasyLoading.dismiss();
  }

  void showRejectDialog({required String id})
  {
    var formKey = GlobalKey<FormState>();
    var reasonController =
    TextEditingController();
    // showSnackbar("Coming Soon");
    showCustomConfirmationDialog(
      headingIcon: Icons.cancel_outlined,
      headingMessage: "Are you sure you want to reject this booking?",
      widget: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller:
              reasonController,
              headingText:
              'Reason for rejection :',
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
          Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);

          await rejectInstantBooking(
              request:  {
                "instant_id": id,
                "reason": reasonController.text.trim(),
              }
          );
        }
      },
    );
  }

  List<String> generateTimeIntervals() {
    List<String> timeIntervals = [];
    final now = DateTime.now(); // Get the current date and time
    final currentTime = TimeOfDay.fromDateTime(now); // Convert to TimeOfDay

    // Calculate the next half-hour mark
    int startHour = currentTime.hour;
    int startMinute = currentTime.minute;

    // Round up to the next half-hour
    if (startMinute < 30) {
      startMinute = 30;
    } else {
      startMinute = 0;
      startHour++;
    }

    // Ensure hour is wrapped within 24-hour format
    startHour = startHour % 24;

    // Generate time intervals starting from the calculated start time
    for (int i = 0; i < 24; i++) { // Generate for the next 24 intervals (12 hours)
      // Calculate the new time for each 30-minute interval
      final newMinute = startMinute + (i * 30);
      final newHour = startHour + newMinute ~/ 60; // Calculate new hour based on minute overflow
      final adjustedMinute = newMinute % 60; // Get the valid minute (0-59)

      // Create the TimeOfDay object
      final time = TimeOfDay(hour: newHour % 24, minute: adjustedMinute); // Use modulo 24 to wrap hour

      // Add the formatted time to the list if it is before or equal to 11:30 PM
      if (time.hour < 23 || (time.hour == 23 && time.minute <= 30)) {
        timeIntervals.add(formatTime(time)); // Add the formatted time to the list
      }

      // Stop if the time reaches 11:30 PM
      if (time.hour == 23 && time.minute == 30) {
        break;
      }
    }

    return timeIntervals;
  }

// Helper function to format TimeOfDay to AM/PM string
  String formatTime(TimeOfDay time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12; // Convert to 12-hour format
    final minute = time.minute.toString().padLeft(2, '0'); // Pad minutes with leading zero
    final period = time.hour >= 12 ? 'PM' : 'AM'; // Determine AM/PM
    return '$hour:$minute $period'; // Return formatted string
  }

  void showAcceptBookingDialog({required String id,})
  {

    DateTime picker=DateTime.now();
    // picker=picker.subtract(picker.timeZoneOffset);
    // picker=picker.add(Duration(minutes: timezoneOffset));

    TextEditingController dateController = TextEditingController();
    TextEditingController selectStartTimeController = TextEditingController();
    TextEditingController selectEndTimeController = TextEditingController();
    ValueNotifier<String?> selectedStartDate = ValueNotifier(null);
    ValueNotifier<String?> selectedEndDate = ValueNotifier(null);
    List availabilityList = [];
    List startAvailabilityList = [];
    List endAvailabilityList = [];

    dateController.text = CustomTimeFunctions.formatDateddmmyy(picker);




    List<String> slotList = [];

    slotList = generateTimeIntervals();

    for (int i = 0; i < slotList.length; i++) {
      startAvailabilityList.add({"key": slotList[i]});
      availabilityList.add({"key": slotList[i]});
    }

    if (startAvailabilityList.isNotEmpty) {
      startAvailabilityList.removeLast();
    }

    showCustomConfirmationDialog(
      headingMessage: "Accept Booking ?",
      padding: 10,
      widget: Consumer<BookGuideProvider>(
        builder: (context, bookGuideProvider, child)  {
          return Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ApiKeys.user_Id: userDataNotifier.value!.userId,
                                  ApiKeys.selectedDate: CustomTimeFunctions.formatDateddmmyy(picker),
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
            ],
          );
        }
      ),
      okButtonText: "Submit",
      okButtonClick: () async {
        if(selectedStartDate.value == null)
          {
            showSnackbar("Please select start time");
            return;
          }

        if(selectedEndDate.value == null)
          {
            showSnackbar("Please select end time");
            return;
          }


        Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);

        await acceptInstantBooking(
            request:  {
              "instant_id": id,
              ApiKeys.startSlot:selectedStartDate.value,
              ApiKeys.endSlot:selectedEndDate.value,
              ApiKeys.bookingDate:CustomTimeFunctions.formatDateNewWithDash(picker)
            }
        );

      },
    );
  }

  void showPayDialog({required InstantBooking  instantBooking})
  {

    showCustomConfirmationDialog(
      headingMessage: "Pay Instant Booking",
      widget: const Column(
        children: [

        ],
      ),
      okButtonClick: () async {

      },
    );
  }

  void reload() {
    notifyListeners();
  }

  void reset() {
    instantSessionsRefresh = false;
    instantSessionsOffset = 1;
    instantSessionsLoad = false;
    isLastSessions = false;
    instantSessions = [];
    instantSessionsModel=null;
  }
}
