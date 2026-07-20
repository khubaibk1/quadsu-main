


import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/custom_time_functions.dart';
import '../../functions/validation_functions.dart';
import '../custom_text.dart';
import '../custom_text_field.dart';

class ScheduledCard extends StatelessWidget {
   String title;
       TextEditingController  startTimeController;
       TextEditingController endTimeController;
       bool isDayOff;
       void Function(bool?)?  onDayOffChanged;
   ScheduledCard({super.key,
    required this.title,
  required this.startTimeController,
  required this.endTimeController,
  required this.isDayOff,
  required this.onDayOffChanged,
  });

  @override
  Widget build(BuildContext context) {
    return    Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.smallText(
                title,
                fontWeight: FontWeight.w500,
                increamentFontSize: 1,
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                        visualDensity: VisualDensity.compact,
                        checkColor: MyColors.whiteColor,
                        fillColor:WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states)=>isDayOff? MyColors.primaryColor:MyColors.fillColor) ,
                        side: WidgetStateBorderSide.resolveWith(
                              (states) =>  BorderSide(width: 1.0, color:isDayOff? MyColors.primaryColor: MyColors.enabledTextFieldBorderColor),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value:true,
                        onChanged:onDayOffChanged
                    ),
                  ),
                  CustomText.smallText(
                    "Day off",
                  ),
                ],
              ),
            ],
          ),
          vSizedBox02,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: startTimeController,
                  obscureText: false,
                  enabled: !isDayOff,
                  headingText: 'Start Time:',
                  readOnly: true,
                  hintText: "Select",
                  hintTextFontSize: 12,
                  headingFontSize: 12,
                  fontSize: 12,
                  onChanged: (val){

                  },
                  suffix:isDayOff?null:  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.watch_later_outlined,
                      color: MyColors.hintColor,
                    ),
                  ),
                  onTap: isDayOff?null: ()async{
                    String time=startTimeController.text.isEmpty?"":CustomTimeFunctions.convertTo24HourFormat(startTimeController.text);
                    TimeOfDay initDay=startTimeController.text.isEmpty?TimeOfDay.now():
                    TimeOfDay(hour: int.parse(time.split(':')[0].toString()), minute: int.parse(time.split(':')[1].toString()));

                    TimeOfDay? picker= await showTimePicker(context: context, initialTime:initDay);
                    if(picker!=null){
                      startTimeController.text=picker.format(context);
                    }
                  },
                  contentPaddingVertical: 11,
                  validator:isDayOff?null: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
              ),
              hSizedBox15,
              Expanded(
                child: CustomTextField(
                  controller: endTimeController,
                  obscureText: false,
                  enabled: !isDayOff,
                  headingText: 'End Time:',
                  hintText: "Select",
                  hintTextFontSize: 12,
                  headingFontSize: 12,
                  fontSize: 12,
                  readOnly: true,
                  contentPaddingVertical: 11,
                  onTap: isDayOff?null:  ()async{
                    String time=endTimeController.text.isEmpty?"":CustomTimeFunctions.convertTo24HourFormat(endTimeController.text);
                    TimeOfDay initDay=endTimeController.text.isEmpty?TimeOfDay.now():
                    TimeOfDay(hour: int.parse(time.split(':')[0].toString()), minute: int.parse(time.split(':')[1].toString()));
                    TimeOfDay? picker= await showTimePicker(
                        context: context,
                        initialTime:initDay);
                    // TimeOfDay? picker= await showTimePicker(context: context,
                    //     initialTime: TimeOfDay.now());
                    if(picker!=null){
                      endTimeController.text=picker.format(context);
                    }
                  },
                  suffix:isDayOff?null:  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.watch_later_outlined,
                      color: MyColors.hintColor,
                    ),
                  ),
                  validator:isDayOff?null: (val) {
                    return ValidationFunction.requiredValidationForEndAvailability(val,startTime: startTimeController.text);
                  },
                ),
              ),
            ],
          ),
        ],
      );
  }

}
extension StringCapitalization on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
