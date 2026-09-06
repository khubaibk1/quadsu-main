import 'package:country_picker/country_picker.dart';
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

class EditBasicDetails extends StatelessWidget {
   EditBasicDetails({super.key});
   final formKey = GlobalKey<FormState>();
   ValueNotifier<bool> reload=ValueNotifier(false);
   TextEditingController firstNameController = TextEditingController(text: userDataNotifier.value?.firstName);
   TextEditingController lastNameController = TextEditingController(text: userDataNotifier.value?.lastName);
   TextEditingController mobileNumberController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.phone);
   TextEditingController addressController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.hometown);
   TextEditingController hobbiesController = TextEditingController(text: "");
   ValueNotifier<String> selectedCountryCode = ValueNotifier(userDataNotifier.value?.guidePrefrence?.countryCode??defaultCountryCode);
   List hobbies= userDataNotifier.value?.guidePrefrence?.hobbies.split(',')??[];




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
              CustomText.bodyText2(
                "What hobbies or activities do you participate in?",
                increamentFontSize: 1,
                fontWeight: FontWeight.w400,
              ),
              vSizedBox,
              Wrap(
                children:List.generate(hobbies.length,
                      (index) {
                    return GestureDetector(
                      onTap: () {
                        hobbies.removeAt(index);
                        reload.value=!reload.value;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        margin: const EdgeInsets.only(right: 10,bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.fillColor,
                            border: Border.all(
                                color: MyColors.enabledTextFieldBorderColor
                            )
                        ),
                        child:  CustomText.bodyText2(
                          "${hobbies[index]} ×",
                          fontWeight: FontWeight.w600,
                          increamentFontSize: 1,
                        ),
                      ),
                    );
                  },),

              ),
              if(hobbies.isNotEmpty)
                const SizedBox(
                  height: 5,
                ),
              CustomTextField(
                controller: hobbiesController,
                hintText: "",
                maxLines: 3,
                onSaved: (p0) {
                  if(p0 != null && p0.isNotEmpty)
                  {
                    hobbies.add(p0);
                    reload.value=!reload.value;
                  }
                  hobbiesController.clear();
                },
                keyboardType: TextInputType.text,
              ),
              vSizedBox2,
              CustomTextField(
                controller: addressController,
                headingText: 'What is your hometown',
                hintText: "What is your hometown",
                hintTextFontSize: 14,
                fontSize: 14,
                contentPaddingVertical: 11,
                validator: (val) {
                  return ValidationFunction.requiredValidation(val);
                },
                keyboardType: TextInputType.emailAddress,
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
                     Map<String,dynamic> request= {
                       ApiKeys.firstName:firstNameController.text.trim(),
                       ApiKeys.lastName:lastNameController.text.trim(),
                       ApiKeys.number:mobileNumberController.text.trim(),
                       ApiKeys.countryCode:selectedCountryCode.value,
                       ApiKeys.hometown:addressController.text.trim(),
                    };
                     List<String> hobbiesData=[];

                     if(hobbies.isNotEmpty)
                       {
                         for(int i=0;i<hobbies.length;i++)
                         {
                           hobbiesData.add(hobbies[i]);
                         }
                         request[ApiKeys.hobbiesOrActivities]=hobbiesData;

                       }
                  else if(hobbiesController.text.trim().isNotEmpty)
                    {

                      hobbiesData.add(hobbiesController.text.trim());
                      request[ApiKeys.hobbiesOrActivities]=hobbiesData;

                    }
                     else
                       {
                         showSnackbar("Please enter hobbies");
                         return;

                       }

                     myAuthProvider.editBasicDetail(context, request: request, userType:usertype);
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
