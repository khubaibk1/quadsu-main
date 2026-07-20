
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
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

class EditSkillsDetails extends StatefulWidget {
  const EditSkillsDetails({super.key});

  @override
  State<EditSkillsDetails> createState() => _EditSkillsDetailsState();
}

class _EditSkillsDetailsState extends State<EditSkillsDetails> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> reload = ValueNotifier(false);

  TextEditingController bioController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.profileHeadline);

  TextEditingController tagLineController = TextEditingController(text: userDataNotifier.value?.guidePrefrence?.tagLine);

  SingleValueDropDownController specialistNotifier = SingleValueDropDownController();

  ValueNotifier<String> campusRepresentative = ValueNotifier(userDataNotifier.value?.guidePrefrence!.campusRepresentative.toString()??'0');

  ValueListenable<List> specialist = ValueNotifier([]);

  ValueNotifier specialitiesNotifier = ValueNotifier(null);

  List speciality=userDataNotifier.value?.guidePrefrence?.speciality.split(', ')??[];


  List aspiringStudentsList = [
    {
      'title': 'College',
      'value': ValueNotifier(false),
    },
    {
      'title': 'Graduate School',
      'value': ValueNotifier(false),
    },
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(userDataNotifier.value?.guidePrefrence?.studentTypes != null){
        List studentTypesList= userDataNotifier.value?.guidePrefrence?.studentTypes.split(',')??[];
        for(int j =0; j<aspiringStudentsList.length;j++){
        for(int i =0; i<studentTypesList.length;i++){
            if(studentTypesList[i].trim()==aspiringStudentsList[j]['title']){
              aspiringStudentsList[j]['value'].value=true;
              aspiringStudentsList[j]['value'].notifyListeners();
            }
          }
        }
      }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child)  {
          return Consumer<MyAuthProvider>(
            builder: (context, myAuthProvider, child)  {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.headingSmall(
                      'Edit Skills & Preferences',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox3,
                    if( myAuthProvider.globalLanguages.isNotEmpty)
                    Wrap(
                      children:List.generate(speciality.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              speciality.removeAt(index);
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
                                "${speciality[index]} ×",
                                fontWeight: FontWeight.w600,
                                increamentFontSize: 1,
                              ),
                            ),
                          );
                        },),
                    ),
                    if(speciality.isNotEmpty)
                      const SizedBox(
                        height: 5,
                      ),
                    if( myAuthProvider.globalSpecialities.isNotEmpty)
                      ValueListenableBuilder(
                        valueListenable:specialitiesNotifier ,
                        builder: (context, specialitiesValue, child) =>
                            CustomDropdownButton(
                              items: myAuthProvider.globalSpecialities,
                              hint:'' ,
                              hintTextFontSize: 14,
                              contentPaddingVertical: 11,
                              headingText: 'Your Specialities',
                              headingFontWeight:FontWeight.w600,
                              itemMapKey: "title",
                              singleSelectedItem: specialitiesValue,
                              // validatorSingle: (val) {
                              //   return ValidationFunction.requiredValidation(val);
                              // },
                              onChangedSingle: (val){
                                if(!speciality.contains(val['title'])) {
                                  speciality.add(val['title']);
                                  print('lklklk---$speciality');
                                }
                                reload.value= !reload.value;
                              },
                            ),
                      ),
                    if( myAuthProvider.globalSpecialities.isNotEmpty)
                    vSizedBox2,
                    CustomTextField(
                      controller: bioController,
                      headingText: 'What about your Bio',
                      hintText: "Write here..",
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
                      controller: tagLineController,
                      headingText: 'Fun Fact About You!',
                      hintText: "Write here..",
                      hintTextFontSize: 14,
                      fontSize: 14,
                      contentPaddingVertical: 11,
                      validator: (val) {
                        return ValidationFunction.requiredValidation(val);
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    vSizedBox2,
                    CustomText.bodyText2(
                      "Prefer Student type",
                      increamentFontSize: 1,
                      fontWeight: FontWeight.w400,
                    ),
                    vSizedBox,
                    ListView.builder(
                      shrinkWrap: true,
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
                                  fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                          (Set<WidgetState> states) =>
                                              value == true
                                                  ? MyColors.primaryColor
                                                  : MyColors.fillColor),
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0,
                                        color: value == true
                                            ? MyColors.primaryColor
                                            : MyColors.enabledTextFieldBorderColor),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: value == true ? true : false,
                                  onChanged: (val) {
                                    aspiringStudentsList[index]['value'].value =
                                        val;
                                  }),
                            ),
                            CustomText.smallText(
                              aspiringStudentsList[index]["title"],
                            ),
                          ],
                        ),
                      ),
                    ),
                    vSizedBox2,
                    CustomText.bodyText2(
                      "Interested to get a designation of \"Campus Representative\" in your profile ?",
                      fontWeight: FontWeight.w600,
                      increamentFontSize: 1,
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
                                    fillColor: WidgetStateColor.resolveWith(
                                          (states) {
                                        return MyColors.primaryColor;
                                      },
                                    ),
                                    value: '1',
                                    groupValue: value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (val) {
                                      campusRepresentative.value = val!;
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
                                    fillColor: WidgetStateColor.resolveWith(
                                          (states) {
                                        return MyColors.primaryColor;
                                      },
                                    ),
                                    value: '0',
                                    groupValue: value,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (val) {
                                      campusRepresentative.value = val!;
                                    }),
                              ),
                              CustomText.smallText(
                                "No",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    vSizedBox2,
                    CustomButton(
                      height: 50,
                      borderRadius: 4,
                      text: 'Save',
                      fontWeight: FontWeight.w600,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Map<String,dynamic> request= {
                            ApiKeys.profileHeadline:bioController.text.trim(),
                            ApiKeys.tagLine:tagLineController.text.trim(),
                            ApiKeys.campusRepresentative:campusRepresentative.value,
                          };
                          if(aspiringStudentsList.isNotEmpty)
                          {
                            List<String> aspiringData=[];
                            for(int i=0;i<aspiringStudentsList.length;i++)
                            {
                              if(aspiringStudentsList[i]['value'].value)
                              {
                                aspiringData.add(aspiringStudentsList[i]['title']);
                              }
                              request[ApiKeys.studentTypes]=aspiringData;
                            }
                          }
                          if(speciality.isEmpty) {
                            showSnackbar("Please enter specialist");
                            return;
                          }
                          else
                          {
                            List<String> specialityData=[];
                            for(int i=0;i<speciality.length;i++) {
                              specialityData.add(speciality[i]);
                            }
                            request[ApiKeys.speciality]=specialityData;
                          }
                          myAuthProvider.editSkillsDetail(context, request: request);
                        }
                      },
                    )
                  ],
                );
              });
        }
      ),
    );
  }
}
