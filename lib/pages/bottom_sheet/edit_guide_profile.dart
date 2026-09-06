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
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class EditGuideProfile extends StatefulWidget {
  const EditGuideProfile({super.key});

  @override
  State<EditGuideProfile> createState() => _EditGuideProfileState();
}

class _EditGuideProfileState extends State<EditGuideProfile> {
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> reload = ValueNotifier(false);

  // Basic Details
  TextEditingController firstNameController = TextEditingController(text: userDataNotifier.value?.firstName);
  TextEditingController lastNameController = TextEditingController(text: userDataNotifier.value?.lastName);
  TextEditingController mobileNumberController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.phone);
  TextEditingController hometownController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.hometown);
  ValueNotifier<String> selectedCountryCode = ValueNotifier(userDataNotifier.value?.guidePrefrence?.countryCode ?? defaultCountryCode);

  // Profile Details
  TextEditingController bioController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.profileHeadline);
  TextEditingController tagLineController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.tagLine);

  // Education
  TextEditingController ugCollegeController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.ugCollegeName);
  TextEditingController ugDegreeController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.ugDegreeType);
  TextEditingController gCollegeController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.gCollegeName);
  TextEditingController gDegreeController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.gDegreeType);

  // Hobbies
  TextEditingController hobbiesController = TextEditingController();
  List hobbies = userDataNotifier.value?.guidePrefrence?.hobbies.split(',') ?? [];

  // Specialities
  List speciality = userDataNotifier.value?.guidePrefrence?.speciality.split(', ') ?? [];
  ValueNotifier specialitiesNotifier = ValueNotifier(null);

  // Student Types
  List aspiringStudentsList = [
    {'title': 'College', 'value': ValueNotifier(false)},
    {'title': 'Graduate School', 'value': ValueNotifier(false)},
  ];

  // Campus Representative
  ValueNotifier<String> campusRepresentative = ValueNotifier(
      userDataNotifier.value?.guidePrefrence?.campusRepresentative.toString() ?? '0');

  // Universities
  List<int> selectedUniversityIds = [];
  ValueNotifier universityNotifier = ValueNotifier(null);

  // Languages
  List<int> selectedLanguageIds = [];
  ValueNotifier languageNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Initialize student types
      if (userDataNotifier.value?.guidePrefrence?.studentTypes != null) {
        List studentTypesList = userDataNotifier.value?.guidePrefrence?.studentTypes.split(',') ?? [];
        for (int j = 0; j < aspiringStudentsList.length; j++) {
          for (int i = 0; i < studentTypesList.length; i++) {
            if (studentTypesList[i].trim() == aspiringStudentsList[j]['title']) {
              aspiringStudentsList[j]['value'].value = true;
            }
          }
        }
      }

      // Initialize universities
      if (userDataNotifier.value?.guidePrefrence?.university != null) {
        List temp = userDataNotifier.value?.guidePrefrence?.university.split(',') ?? [];
        for (int i = 0; i < temp.length; i++) {
          selectedUniversityIds.add(int.parse(temp[i]));
        }
      }

      // Initialize languages
      if (userDataNotifier.value?.guidePrefrence?.guideLanguage != null) {
        List temp = userDataNotifier.value?.guidePrefrence?.guideLanguage.split(',') ?? [];
        for (int i = 0; i < temp.length; i++) {
          selectedLanguageIds.add(int.parse(temp[i]));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
        valueListenable: reload,
        builder: (context, reloadValue, child) {
          return Consumer<MyAuthProvider>(
            builder: (context, myAuthProvider, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.headingSmall('Edit Profile',
                        fontWeight: FontWeight.w600),
                    vSizedBox3,

                    // BASIC DETAILS SECTION
                    CustomText.bodyText2('Basic Details',
                        fontWeight: FontWeight.w600, increamentFontSize: 2),
                    vSizedBox2,
                    CustomTextField(
                      controller: firstNameController,
                      headingText: 'First Name:',
                      hintText: "First name",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: lastNameController,
                      headingText: 'Last Name:',
                      hintText: "Last name",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox2,
                    ValueListenableBuilder(
                      valueListenable: selectedCountryCode,
                      builder: (context, value, child) {
                        return CustomTextField(
                          controller: mobileNumberController,
                          headingText: 'Phone Number',
                          keyboardType: TextInputType.number,
                          hintText: "Mobile No.",
                          hintTextFontSize: 14,
                          fontSize: 14,
                          contentPaddingVertical: 11,
                          validator: (val) => ValidationFunction.mobileNumberValidation(val),
                          prefix: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (country) {
                                  selectedCountryCode.value = country.phoneCode;
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8, left: 1),
                              padding: const EdgeInsets.symmetric(vertical: 11.5),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(9)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 10),
                                  CustomText.textFieldText("+$value", fontSize: 14),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(Icons.keyboard_arrow_down, size: 20, color: MyColors.hintColor),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: hometownController,
                      headingText: 'Hometown',
                      hintText: "What is your hometown",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox3,

                    // PROFILE DETAILS SECTION
                    CustomText.bodyText2('Profile Details',
                        fontWeight: FontWeight.w600, increamentFontSize: 2),
                    vSizedBox2,
                    CustomTextField(
                      controller: bioController,
                      headingText: 'Bio',
                      hintText: "Write about yourself",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      maxLines: 3,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.multiline,
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: tagLineController,
                      headingText: 'Fun Fact About You!',
                      hintText: "Write here..",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox3,

                    // EDUCATION SECTION
                    CustomText.bodyText2('Education',
                        fontWeight: FontWeight.w600, increamentFontSize: 2),
                    vSizedBox2,
                    CustomTextField(
                      controller: ugCollegeController,
                      headingText: 'Undergraduate College',
                      hintText: "College name",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: ugDegreeController,
                      headingText: 'Graduation Year',
                      hintText: "e.g., 2024",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: gCollegeController,
                      headingText: 'Graduate College (Optional)',
                      hintText: "College name",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox2,
                    CustomTextField(
                      controller: gDegreeController,
                      headingText: 'Graduate Degree (Optional)',
                      hintText: "Degree type",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox3,

                    // UNIVERSITIES SECTION
                    if (myAuthProvider.globalUniversity.isNotEmpty) ...[
                      CustomText.bodyText2('Universities',
                          fontWeight: FontWeight.w600, increamentFontSize: 2),
                      vSizedBox,
                      Wrap(
                        children: List.generate(selectedUniversityIds.length, (index) {
                          var uni = myAuthProvider.globalUniversity.firstWhere(
                            (u) => u['id'] == selectedUniversityIds[index],
                            orElse: () => {'university_name': 'Unknown'},
                          );
                          return GestureDetector(
                            onTap: () {
                              selectedUniversityIds.removeAt(index);
                              reload.value = !reload.value;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: const EdgeInsets.only(right: 10, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: MyColors.fillColor,
                                border: Border.all(color: MyColors.enabledTextFieldBorderColor),
                              ),
                              child: CustomText.bodyText2(
                                "${uni['university_name']} ×",
                                fontWeight: FontWeight.w600,
                                increamentFontSize: 1,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (selectedUniversityIds.isNotEmpty) const SizedBox(height: 5),
                      ValueListenableBuilder(
                        valueListenable: universityNotifier,
                        builder: (context, universityValue, child) => CustomDropdownButton(
                          items: myAuthProvider.globalUniversity,
                          hint: 'Select University',
                          hintTextFontSize: 14,
                          contentPaddingVertical: 11,
                          itemMapKey: "university_name",
                          singleSelectedItem: universityValue,
                          onChangedSingle: (val) {
                            if (!selectedUniversityIds.contains(val['id'])) {
                              selectedUniversityIds.add(val['id']);
                              reload.value = !reload.value;
                            }
                          },
                        ),
                      ),
                      vSizedBox3,
                    ],

                    // SPECIALITIES SECTION
                    if (myAuthProvider.globalSpecialities.isNotEmpty) ...[
                      CustomText.bodyText2('Specialities',
                          fontWeight: FontWeight.w600, increamentFontSize: 2),
                      vSizedBox,
                      Wrap(
                        children: List.generate(speciality.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              speciality.removeAt(index);
                              reload.value = !reload.value;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: const EdgeInsets.only(right: 10, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: MyColors.fillColor,
                                border: Border.all(color: MyColors.enabledTextFieldBorderColor),
                              ),
                              child: CustomText.bodyText2(
                                "${speciality[index]} ×",
                                fontWeight: FontWeight.w600,
                                increamentFontSize: 1,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (speciality.isNotEmpty) const SizedBox(height: 5),
                      ValueListenableBuilder(
                        valueListenable: specialitiesNotifier,
                        builder: (context, specialitiesValue, child) => CustomDropdownButton(
                          items: myAuthProvider.globalSpecialities,
                          hint: 'Select Speciality',
                          hintTextFontSize: 14,
                          contentPaddingVertical: 11,
                          itemMapKey: "title",
                          singleSelectedItem: specialitiesValue,
                          onChangedSingle: (val) {
                            if (!speciality.contains(val['title'])) {
                              speciality.add(val['title']);
                              reload.value = !reload.value;
                            }
                          },
                        ),
                      ),
                      vSizedBox3,
                    ],

                    // LANGUAGES SECTION
                    if (myAuthProvider.globalLanguages.isNotEmpty) ...[
                      CustomText.bodyText2('Languages',
                          fontWeight: FontWeight.w600, increamentFontSize: 2),
                      vSizedBox,
                      Wrap(
                        children: List.generate(selectedLanguageIds.length, (index) {
                          var lang = myAuthProvider.globalLanguages.firstWhere(
                            (l) => l['id'] == selectedLanguageIds[index],
                            orElse: () => {'language': 'Unknown'},
                          );
                          return GestureDetector(
                            onTap: () {
                              selectedLanguageIds.removeAt(index);
                              reload.value = !reload.value;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: const EdgeInsets.only(right: 10, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: MyColors.fillColor,
                                border: Border.all(color: MyColors.enabledTextFieldBorderColor),
                              ),
                              child: CustomText.bodyText2(
                                "${lang['language']} ×",
                                fontWeight: FontWeight.w600,
                                increamentFontSize: 1,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (selectedLanguageIds.isNotEmpty) const SizedBox(height: 5),
                      ValueListenableBuilder(
                        valueListenable: languageNotifier,
                        builder: (context, languageValue, child) => CustomDropdownButton(
                          items: myAuthProvider.globalLanguages,
                          hint: 'Select Language',
                          hintTextFontSize: 14,
                          contentPaddingVertical: 11,
                          itemMapKey: "language",
                          singleSelectedItem: languageValue,
                          onChangedSingle: (val) {
                            if (!selectedLanguageIds.contains(val['id'])) {
                              selectedLanguageIds.add(val['id']);
                              reload.value = !reload.value;
                            }
                          },
                        ),
                      ),
                      vSizedBox3,
                    ],

                    // HOBBIES SECTION
                    CustomText.bodyText2('Hobbies',
                        fontWeight: FontWeight.w600, increamentFontSize: 2),
                    vSizedBox,
                    Wrap(
                      children: List.generate(hobbies.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            hobbies.removeAt(index);
                            reload.value = !reload.value;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(right: 10, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: MyColors.fillColor,
                              border: Border.all(color: MyColors.enabledTextFieldBorderColor),
                            ),
                            child: CustomText.bodyText2(
                              "${hobbies[index]} ×",
                              fontWeight: FontWeight.w600,
                              increamentFontSize: 1,
                            ),
                          ),
                        );
                      }),
                    ),
                    if (hobbies.isNotEmpty) const SizedBox(height: 5),
                    CustomTextField(
                      controller: hobbiesController,
                      hintText: "Add hobby and press enter",
                      maxLines: 2,
                      onSaved: (p0) {
                        if (p0 != null && p0.isNotEmpty) {
                          hobbies.add(p0);
                          reload.value = !reload.value;
                        }
                        hobbiesController.clear();
                      },
                      keyboardType: TextInputType.text,
                    ),
                    vSizedBox3,

                    // STUDENT TYPES SECTION
                    CustomText.bodyText2('Prefer Student Type',
                        fontWeight: FontWeight.w600, increamentFontSize: 2),
                    vSizedBox,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: aspiringStudentsList.length,
                      itemBuilder: (context, index) => ValueListenableBuilder(
                        valueListenable: aspiringStudentsList[index]['value'],
                        builder: (context, value, child) => Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                visualDensity: VisualDensity.compact,
                                checkColor: MyColors.whiteColor,
                                fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) =>
                                      value == true ? MyColors.primaryColor : MyColors.fillColor,
                                ),
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0,
                                    color: value == true
                                        ? MyColors.primaryColor
                                        : MyColors.enabledTextFieldBorderColor,
                                  ),
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: value == true ? true : false,
                                onChanged: (val) {
                                  aspiringStudentsList[index]['value'].value = val;
                                },
                              ),
                            ),
                            CustomText.smallText(aspiringStudentsList[index]["title"]),
                          ],
                        ),
                      ),
                    ),
                    vSizedBox3,

                    // CAMPUS REPRESENTATIVE SECTION
                    CustomText.bodyText2(
                      'Interested in "Campus Representative" designation?',
                      fontWeight: FontWeight.w600,
                      increamentFontSize: 2,
                    ),
                    vSizedBox,
                    ValueListenableBuilder(
                      valueListenable: campusRepresentative,
                      builder: (context, value, child) => Column(
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Radio(
                                  activeColor: MyColors.primaryColor,
                                  fillColor: WidgetStateColor.resolveWith((states) => MyColors.primaryColor),
                                  value: '1',
                                  groupValue: value,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (val) {
                                    campusRepresentative.value = val!;
                                  },
                                ),
                              ),
                              CustomText.smallText("Yes"),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Radio(
                                  activeColor: MyColors.primaryColor,
                                  fillColor: WidgetStateColor.resolveWith((states) => MyColors.primaryColor),
                                  value: '0',
                                  groupValue: value,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (val) {
                                    campusRepresentative.value = val!;
                                  },
                                ),
                              ),
                              CustomText.smallText("No"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    vSizedBox3,

                    // SAVE BUTTON
                    CustomButton(
                      height: 50,
                      borderRadius: 4,
                      text: 'Save',
                      fontWeight: FontWeight.w600,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Build request map
                          Map<String, dynamic> request = {
                            ApiKeys.firstName: firstNameController.text.trim(),
                            ApiKeys.lastName: lastNameController.text.trim(),
                            ApiKeys.number: mobileNumberController.text.trim(),
                            ApiKeys.countryCode: selectedCountryCode.value,
                            ApiKeys.hometown: hometownController.text.trim(),
                            ApiKeys.profileHeadline: bioController.text.trim(),
                            ApiKeys.tagLine: tagLineController.text.trim(),
                            ApiKeys.ugCollageName: ugCollegeController.text.trim(),
                            ApiKeys.ugDegreeType: ugDegreeController.text.trim(),
                            ApiKeys.campusRepresentative: campusRepresentative.value,
                          };

                          // Add optional graduate education
                          if (gCollegeController.text.trim().isNotEmpty) {
                            request[ApiKeys.gCollageName] = gCollegeController.text.trim();
                          }
                          if (gDegreeController.text.trim().isNotEmpty) {
                            request[ApiKeys.gDegreeType] = gDegreeController.text.trim();
                          }

                          // Add hobbies
                          if (hobbies.isNotEmpty) {
                            request[ApiKeys.hobbiesOrActivities] = hobbies;
                          } else {
                            showSnackbar("Please add at least one hobby");
                            return;
                          }

                          // Add specialities
                          if (speciality.isNotEmpty) {
                            request[ApiKeys.speciality] = speciality;
                          } else {
                            showSnackbar("Please select at least one speciality");
                            return;
                          }

                          // Add student types
                          List<String> studentTypes = [];
                          for (var item in aspiringStudentsList) {
                            if (item['value'].value == true) {
                              studentTypes.add(item['title']);
                            }
                          }
                          if (studentTypes.isNotEmpty) {
                            request[ApiKeys.studentTypes] = studentTypes;
                          }

                          // Add universities
                          if (selectedUniversityIds.isNotEmpty) {
                            request[ApiKeys.university] = selectedUniversityIds;
                          } else {
                            showSnackbar("Please select at least one university");
                            return;
                          }

                          // Add languages
                          if (selectedLanguageIds.isNotEmpty) {
                            request[ApiKeys.language] = selectedLanguageIds;
                          } else {
                            showSnackbar("Please select at least one language");
                            return;
                          }

                          // Call API to save
                          myAuthProvider.editBasicDetail(context, request: request, userType: usertype);
                        }
                      },
                    ),
                    vSizedBox2,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
