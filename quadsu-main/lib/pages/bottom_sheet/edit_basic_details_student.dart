import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class EditBasicDetailsStudent extends StatelessWidget {
  EditBasicDetailsStudent({super.key});
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> reload=ValueNotifier(false);
  TextEditingController firstNameController = TextEditingController(text: userDataNotifier.value?.firstName);
  TextEditingController lastNameController = TextEditingController(text: userDataNotifier.value?.lastName);
  TextEditingController mobileNumberController = TextEditingController(text: userDataNotifier.value?.studentPrefrence?.phone);
  ValueNotifier<String> selectedCountryCode = ValueNotifier(userDataNotifier.value?.studentPrefrence?.countryCode??defaultCountryCode);




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
                CustomText.headingSmall('Edit Basic Details',
                  fontWeight: FontWeight.w600,
                ),

                vSizedBox3,
                CustomTextField(
                  controller: firstNameController,
                  headingText: 'First Name:',
                  hintText: "First name",
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                vSizedBox2,
                CustomTextField(
                  controller: lastNameController,
                  headingText: 'Last Name:',
                  hintText: "Last name",
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                vSizedBox2,
                ValueListenableBuilder(
                    valueListenable: selectedCountryCode,
                    builder: (context, value, child) {
                      return CustomTextField(
                        controller: mobileNumberController,
                        headingText: 'Enter Your Phone Number',
                        keyboardType: TextInputType.number,
                        hintText: "Mobile No.",
                        hintTextFontSize: 14,
                        fontSize: 14,
                        contentPaddingVertical: 11,
                        validator: (val){
                          return ValidationFunction.mobileNumberValidation(val,);
                        },
                        prefix: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (value) {
                                selectedCountryCode.value = value.phoneCode;
                              },
                            );
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.only(right: 8,left: 1),
                            padding: const EdgeInsets.symmetric(vertical: 11.5),
                            decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(9))
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText.textFieldText(
                                  "+$value",
                                  fontSize: 14,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.keyboard_arrow_down,
                                      size: 20, color: MyColors.hintColor),
                                ),

                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                vSizedBox2,
                CustomButton(
                  height: 50,
                  borderRadius: 4,
                  text: 'Save',
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      MyAuthProvider myAuthProvider=Provider.of<MyAuthProvider>(context,listen: false);
                      Map<String,dynamic> request= {
                        ApiKeys.firstName:firstNameController.text.trim(),
                        ApiKeys.lastName:lastNameController.text.trim(),
                        ApiKeys.number:mobileNumberController.text.trim(),
                        ApiKeys.countryCode:selectedCountryCode.value,
                      };

                      myAuthProvider.editBasicDetail(context, request: request,userType: usertype);
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
