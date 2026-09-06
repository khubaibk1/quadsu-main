import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/functions/custom_time_functions.dart';
import '../../constants/api_keys.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../provider/my_auth_provider.dart';
import '../../widget/app_specific/scheduled_card.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';

class DaySchedule {
  TextEditingController startTimeController;
  TextEditingController endTimeController;
  ValueNotifier<bool> isDayOff;

  DaySchedule({
    required this.startTimeController,
    required this.endTimeController,
    required this.isDayOff ,
  });
}

class EditSchedule extends StatefulWidget {
  const EditSchedule({super.key});

  @override
  _EditScheduleState createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  final formKey = GlobalKey<FormState>();
  ValueNotifier<String> isInstantBooking=ValueNotifier('0');
  final Map<String, DaySchedule> schedules = {
    'sunday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
      isDayOff: ValueNotifier(false)
    ),
    'monday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
    'tuesday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
    'wednesday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
    'thursday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
    'friday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
    'saturday': DaySchedule(
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
        isDayOff: ValueNotifier(false)
    ),
  };

  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    isInstantBooking.value=userDataNotifier.value!.guidePrefrence!.instantBookingAvailability.toString();
    if (userDataNotifier.value!.guideScheduleList.isNotEmpty) {
      for (var schedule in userDataNotifier.value!.guideScheduleList) {
        schedules.forEach((key, value) {
          if (key == schedule.day) {
            value.startTimeController.text = CustomTimeFunctions.convertTo12HourFormat(schedule.startTime);
            value.endTimeController.text = CustomTimeFunctions.convertTo12HourFormat(schedule.endTime);
            value.isDayOff.value = schedule.isOffDay == 'true';
          }
        });
      }
    }

  },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.headingSmall(
             "Available for Instant Booking",
             fontWeight: FontWeight.w600,
           ),
           vSizedBox,
           ValueListenableBuilder(
             valueListenable: isInstantBooking,
             builder: (context, value, child) =>
                 Column(
                   children: [
                     Row(
                       children: [
                         Transform.scale(
                           scale: 0.8,
                           child: Radio(
                               activeColor: MyColors.primaryColor,
                               fillColor: WidgetStateColor.resolveWith((states) {
                                 return MyColors.primaryColor;
                               },),
                               value: '1',
                               groupValue:value ,
                               visualDensity: VisualDensity.compact,
                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                               onChanged:(val){
                                 isInstantBooking.value=val!;
                               }),
                         ),
                         CustomText.smallText(
                           "Yes",
                         ),
                       ],
                     ),
                     Row(
                       children: [
                         Transform.scale(
                           scale: 0.8,
                           child: Radio(
                               activeColor: MyColors.primaryColor,
                               fillColor: WidgetStateColor.resolveWith((states) {
                                 return MyColors.primaryColor;
                               },),
                               value: '0',
                               groupValue:value,
                               visualDensity: VisualDensity.compact,
                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                               onChanged:(val){
                                 isInstantBooking.value=val!;
                               }),
                         ),
                         CustomText.bodyText2(
                           "No",
                         ),
                       ],
                     ),

                   ],
                 )
           ),
           vSizedBox2,
           Row(
             children: [
               CustomText.headingSmall(
                 "Availability",
                 fontWeight: FontWeight.w600,
               ),
               CustomText.smallText(
                 "(All Times in EST)",
               ),
             ],
           ),
           vSizedBox,
          Column(
            children: schedules.entries.map((entry) {
              final day = entry.key;
              final schedule = entry.value;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable:schedule.isDayOff ,
                  builder: (context, value, child) =>
                      ScheduledCard(
                    title: day.capitalize(),
                    startTimeController: schedule.startTimeController,
                    endTimeController: schedule.endTimeController,
                    isDayOff: value,
                    onDayOffChanged: (val) {
                      schedule.startTimeController.clear();
                      schedule.endTimeController.clear();
                        schedule.isDayOff.value = !value;
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          vSizedBox2,
          CustomButton(
            height: 50,
            borderRadius: 4,
            text: 'Save',
            fontWeight: FontWeight.w600,
            onTap: () {
              if (formKey.currentState!.validate()) {
                MyAuthProvider myAuthProvider = Provider.of<MyAuthProvider>(context, listen: false);
                final Map<String, Map<String, String>> scheduleData = prepareScheduleData();
                final Map<String, dynamic> requestBody = {
                  ApiKeys.scheduleData: scheduleData,
                  ApiKeys.instantBooking: isInstantBooking.value,
                };
                myAuthProvider.editSchedule(context, request: requestBody);
              }
            },
          )
        ],
      ),
    );
  }

  // Widget customContainer({
  //   required String title,
  //   required TextEditingController startTimeController,
  //   required TextEditingController endTimeController,
  //   required bool isDayOff,
  //   required void Function(bool?)?  onDayOffChanged,
  // }) {
  //   return  Column(
  //     children: [
  //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           CustomText.smallText(
  //             title,
  //             fontWeight: FontWeight.w500,
  //             increamentFontSize: 1,
  //           ),
  //           Row(
  //             children: [
  //               Transform.scale(
  //                 scale: 0.9,
  //                 child: Checkbox(
  //                     visualDensity: VisualDensity.compact,
  //                     checkColor: MyColors.whiteColor,
  //                     fillColor:MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states)=>isDayOff? MyColors.primaryColor:MyColors.fillColor) ,
  //                     side: MaterialStateBorderSide.resolveWith(
  //                           (states) =>  BorderSide(width: 1.0, color:isDayOff? MyColors.primaryColor: MyColors.enabledTextFieldBorderColor),
  //                     ),
  //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                     value:true,
  //                     onChanged:onDayOffChanged
  //                 ),
  //               ),
  //               CustomText.smallText(
  //                 "Day off",
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       vSizedBox02,
  //       Row(
  //         children: [
  //           Expanded(
  //             child: CustomTextField(
  //               controller: startTimeController,
  //               obscureText: false,
  //               enabled: !isDayOff,
  //               headingText: 'Start Time:',
  //               readOnly: true,
  //               hintText: "Select",
  //               hintTextFontSize: 12,
  //               headingFontSize: 12,
  //               fontSize: 12,
  //               onChanged: (val){
  //
  //               },
  //               suffix:isDayOff?null:  const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Icon(Icons.watch_later_outlined,
  //                   color: MyColors.hintColor,
  //                 ),
  //               ),
  //               onTap: isDayOff?null: ()async{
  //                 TimeOfDay? picker= await showTimePicker(context: context,
  //                     initialTime: TimeOfDay.now());
  //                 if(picker!=null){
  //                   startTimeController.text=picker.format(context);
  //                 }
  //               },
  //               contentPaddingVertical: 11,
  //               validator:isDayOff?null: (val) {
  //                 return ValidationFunction.requiredValidation(val);
  //               },
  //             ),
  //           ),
  //           hSizedBox15,
  //           Expanded(
  //             child: CustomTextField(
  //               controller: endTimeController,
  //               obscureText: false,
  //               enabled: !isDayOff,
  //               headingText: 'End Time:',
  //               hintText: "Select",
  //               hintTextFontSize: 12,
  //               headingFontSize: 12,
  //               fontSize: 12,
  //               readOnly: true,
  //               contentPaddingVertical: 11,
  //               onTap: isDayOff?null:  ()async{
  //                 TimeOfDay? picker= await showTimePicker(context: context,
  //                     initialTime: TimeOfDay.now());
  //                 if(picker!=null){
  //                   endTimeController.text=picker.format(context);
  //                 }
  //               },
  //               suffix:isDayOff?null:  const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Icon(Icons.watch_later_outlined,
  //                 color: MyColors.hintColor,
  //                 ),
  //               ),
  //               validator:isDayOff?null: (val) {
  //                 return ValidationFunction.requiredValidation(val);
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Map<String, Map<String, String>> prepareScheduleData() {
    final Map<String, Map<String, String>> scheduleData = {};
    schedules.forEach((day, schedule) {
      scheduleData[day] = {
        'day': day,
        'startTime':schedule.startTimeController.text.isEmpty?'00:00':CustomTimeFunctions.convertTo24HourFormat(schedule.startTimeController.text),
        'endTime':schedule.endTimeController.text.isEmpty?'00:00':CustomTimeFunctions.convertTo24HourFormat(schedule.endTimeController.text),
        'isOffDay': schedule.isDayOff.value.toString(),
      };
    });

    return scheduleData;
  }
}


