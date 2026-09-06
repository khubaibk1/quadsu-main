import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_dropdown.dart';
import '../../constants/global_data.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

// ignore: must_be_immutable
class EditEducation extends StatefulWidget {
  const EditEducation({super.key});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> reload = ValueNotifier(false);
  TextEditingController ugCollageName = TextEditingController(
      text: userDataNotifier.value?.guidePrefrence?.ugCollegeName);
  TextEditingController ugDegreeType = TextEditingController(
      text: userDataNotifier.value?.guidePrefrence?.ugDegreeType);
  TextEditingController gCollageName = TextEditingController(
      text: userDataNotifier.value?.guidePrefrence?.gCollegeName);
  ValueNotifier gDegreeType = ValueNotifier(null);
  TextEditingController gCollageName2 = TextEditingController(
      text: userDataNotifier.value?.guidePrefrence?.gCollegeName2);
  ValueNotifier gDegreeType2 = ValueNotifier(null);
  ValueNotifier teachingCertificate = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        MyAuthProvider myAuthProvider =
            Provider.of<MyAuthProvider>(context, listen: false);
        if (userDataNotifier.value?.guidePrefrence?.gDegreeType != null &&
            userDataNotifier.value!.guidePrefrence!.gDegreeType.isNotEmpty) {
          var v=myAuthProvider.globalDegreeTypes.where(
                (element) =>
            element["key"].toString().toLowerCase() ==
                userDataNotifier.value!.guidePrefrence!.gDegreeType
                    .toLowerCase(),
          ).toList().first;
          gDegreeType.value ={"key":v["key"]};
        }

        if (userDataNotifier.value?.guidePrefrence?.gDegreeType2 != null &&
            userDataNotifier.value!.guidePrefrence!.gDegreeType2.isNotEmpty) {
          var v= myAuthProvider.globalDegreeTypes.where(
                (element) =>
            element["key"].toString().toLowerCase() ==
                userDataNotifier.value!.guidePrefrence!.gDegreeType2
                    .toLowerCase(),
          ).toList().first;
          gDegreeType2.value = {"key":v["key"]};
        }

        if (userDataNotifier.value?.guidePrefrence?.teachingCertificate !=
                null &&
            userDataNotifier
                .value!.guidePrefrence!.teachingCertificate.isNotEmpty) {
          var  v= myAuthProvider.globalCertificate.where(
                (element) =>
            element["key"].toString().toLowerCase() ==
                userDataNotifier.value!.guidePrefrence!.teachingCertificate
                    .toLowerCase(),
          ).toList().first;
          teachingCertificate.value ={"key":v["key"]};
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child:
          Consumer<MyAuthProvider>(builder: (context, myAuthProvider, child) {
        return ValueListenableBuilder(
            valueListenable: reload,
            builder: (context, reloadValue, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.headingSmall(
                    'Edit Education',
                    fontWeight: FontWeight.w600,
                  ),
                  vSizedBox3,
                  CustomTextField(
                    controller: ugCollageName,
                    headingText: 'Undergraduate College Name:',
                    hintText: "Undergraduate College Name",
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 11,
                    validator: (val) {
                      print("gdjgdhjgdgdh::::::${ugDegreeType.text.trim()}");

                      if (ugDegreeType.text.trim().isNotEmpty) {
                        return ValidationFunction.requiredValidation(val);
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: ugDegreeType,
                    headingText: 'Undergraduate Degree Type:',
                    hintText: "Undergraduate Degree Type",
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 11,
                    validator: (val) {
                      print("gdjgdhjgdgdh::::::${ugCollageName.text.trim()}");
                      return ValidationFunction.requiredValidation(val);

                      // if (ugCollageName.text.trim().isNotEmpty) {
                      //   return ValidationFunction.requiredValidation(val);
                      // } else {
                      //   return null;
                      // }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: gCollageName,
                    headingText: 'Graduate College Name',
                    hintText: "Graduate College Name",
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 11,
                    validator: (val) {
                      return ValidationFunction.requiredValidation(val);

                      if (gDegreeType.value != null) {
                        return ValidationFunction.requiredValidation(val);
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox2,
                  ValueListenableBuilder(
                    valueListenable: gDegreeType,
                    builder: (context, universityValue, child) =>
                        CustomDropdownButton(
                      items: myAuthProvider.globalDegreeTypes,
                      hint: 'Select Degree Type',
                      headingText: 'Graduate Degree Type',
                      validatorSingle: (val) {
                        return ValidationFunction.requiredValidation(val);

                        if (gCollageName.text.trim().isNotEmpty) {
                          return ValidationFunction.requiredValidation(val);
                        } else {
                          return null;
                        }
                      },
                      headingFontWeight: FontWeight.w400,
                      singleSelectedItem: universityValue,
                      itemMapKey: "key",
                      onChangedSingle: (val) {
                        gDegreeType.value = val;
                      },
                    ),
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: gCollageName2,
                    headingText: 'Graduate College Name',
                    hintText: "Graduate College Name",
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 11,
                    validator: (val) {
                      return ValidationFunction.requiredValidation(val);
                      if (gDegreeType2.value != null) {
                        return ValidationFunction.requiredValidation(val);
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox2,
                  ValueListenableBuilder(
                    valueListenable: gDegreeType2,
                    builder: (context, universityValue, child) =>
                        CustomDropdownButton(
                      items: myAuthProvider.globalDegreeTypes,
                      hint: 'Select Degree Type',
                      headingText: 'Graduate Degree Type',
                      headingFontWeight: FontWeight.w400,
                      singleSelectedItem: universityValue,
                      validatorSingle: (val) {
                        return ValidationFunction.requiredValidation(val);

                        if (gCollageName2.text.trim().isNotEmpty) {
                          return ValidationFunction.requiredValidation(val);
                        } else {
                          return null;
                        }
                      },
                      itemMapKey: "key",
                      onChangedSingle: (val) {
                        gDegreeType2.value = val;
                      },
                    ),
                  ),
                  vSizedBox2,
                  // ValueListenableBuilder(
                  //   valueListenable: teachingCertificate,
                  //   builder: (context, universityValue, child) =>
                  //       CustomDropdownButton(
                  //     items: myAuthProvider.globalCertificate,
                  //     hint: 'Select Teaching Certificate',
                  //     headingText: 'Teaching Certificate',
                  //     headingFontWeight: FontWeight.w400,
                  //     singleSelectedItem: universityValue,
                  //     validatorSingle: (val) {
                  //       return ValidationFunction.requiredValidation(val);
                  //
                  //       return null;
                  //     },
                  //     itemMapKey: "key",
                  //     onChangedSingle: (val) {
                  //       teachingCertificate.value = val;
                  //     },
                  //   ),
                  // ),
                  // vSizedBox2,
                  CustomButton(
                    height: 50,
                    borderRadius: 4,
                    text: 'Save',
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        MyAuthProvider myAuthProvider =
                            Provider.of<MyAuthProvider>(context, listen: false);

                        Map<String, dynamic> request = {
                          ApiKeys.ugCollageName: ugCollageName.text.trim(),
                          ApiKeys.ugDegreeType: ugDegreeType.text.trim(),
                          ApiKeys.gCollageName: gCollageName.text.trim(),
                          ApiKeys.gCollageName2: gCollageName2.text.trim(),
                        };

                        if (gDegreeType.value != null) {
                          request[ApiKeys.gDegreeType] =
                              gDegreeType.value['key'];
                        }

                        if (gDegreeType2.value != null) {
                          request[ApiKeys.gDegreeType2] =
                              gDegreeType2.value['key'];
                        }
                        //
                        // if (teachingCertificate.value != null) {
                        //   request[ApiKeys.teachingCertificate] =
                        //       teachingCertificate.value['key'];
                        // }

                        myAuthProvider.editEducation(context, request: request);
                      }
                    },
                  )
                ],
              );
            });
      }),
    );
  }
}
