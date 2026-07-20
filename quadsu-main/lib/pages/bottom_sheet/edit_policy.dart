
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class EditPolicyDetails extends StatelessWidget {
  EditPolicyDetails({super.key});
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> reload=ValueNotifier(false);
  TextEditingController hourlyRateController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.hourlyRate);
  TextEditingController sessionCancellationController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.lessonCancellation);
  ValueNotifier<String> hoursAvailable =ValueNotifier(userDataNotifier.value?.guidePrefrence?.hoursAvailablePerWeek??'');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
          valueListenable: reload,
          builder:(context, reloadValue, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.headingSmall('Edit Policies',
                  fontWeight: FontWeight.w600,
                ),

                vSizedBox2,
                CustomTextField(
                  controller: hourlyRateController,
                  hintText: "",
                  headingText: 'Hourly Rate(\$):',
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
                  keyboardType: TextInputType.number,
                  headingFontWeight: FontWeight.w600,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: sessionCancellationController,
                  headingText: 'Session Cancellation:',
                  hintText: "",
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                vSizedBox2,
                CustomText.bodyText2(
                  "Hours Available Per Week:",
                  fontWeight: FontWeight.w600,
                  increamentFontSize: 1,
                ),
                vSizedBox,
                ValueListenableBuilder(
                  valueListenable: hoursAvailable,
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
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "1",
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
                                    value: '2',
                                    groupValue:value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged:(val){
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "2",
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
                                    value: '3-4',
                                    groupValue:value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged:(val){
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "3-4",

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
                                    value: '4-5',
                                    groupValue:value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged:(val){
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "4-5",
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
                                    value: '5-6',
                                    groupValue:value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged:(val){
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "5-6",
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
                                    value: '6',
                                    groupValue:value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged:(val){
                                      hoursAvailable.value=val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "6",
                              ),
                            ],
                          ),

                        ],
                      )
                ),
                vSizedBox2,
                CustomButton(
                  height: 50,
                  borderRadius: 4,
                  text: 'Save',
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      MyAuthProvider myAuthProvider=Provider.of<MyAuthProvider>(context,listen: false);
                      if(hoursAvailable.value==''){
                        showSnackbar('Please Select Hours Available Per Week');
                        return;
                      }
                      Map<String,dynamic> request= {
                        ApiKeys.hourlyRate:hourlyRateController.text.trim(),
                        ApiKeys.sessionCancellation:sessionCancellationController.text.trim(),
                        ApiKeys.hoursAvailablePerWeek:hoursAvailable.value,
                      };
                      myAuthProvider.editPolicy(context, request: request);
                    }
                  },
                )
              ],
            );
          }
      ),
    );
  }
}
