import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';

class EditAreasOfExpertise extends StatefulWidget {
  const EditAreasOfExpertise({super.key});

  @override
  State<EditAreasOfExpertise> createState() => _EditAreasOfExpertiseState();
}

class _EditAreasOfExpertiseState extends State<EditAreasOfExpertise> {
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (userDataNotifier.value?.guidePrefrence?.studentTypes != null) {
        List studentTypesList =
            userDataNotifier.value?.guidePrefrence?.studentTypes.split(',') ??
                [];
        for (int j = 0; j < aspiringStudentsList.length; j++) {
          for (int i = 0; i < studentTypesList.length; i++) {
            if (studentTypesList[i].trim() == aspiringStudentsList[j]['title']) {
              aspiringStudentsList[j]['value'].value = true;
              aspiringStudentsList[j]['value'].notifyListeners();
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(
      builder: (context, myAuthProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText.headingSmall(
              'Edit Areas of Expertise',
              fontWeight: FontWeight.w600,
            ),
            vSizedBox2,
            CustomText.bodyText2(
              "Select student types you prefer to guide",
              increamentFontSize: 1,
              fontWeight: FontWeight.w400,
            ),
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
                              (Set<WidgetState> states) => value == true
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
                            aspiringStudentsList[index]['value'].value = val;
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
            CustomButton(
              height: 50,
              borderRadius: 4,
              text: 'Save',
              fontWeight: FontWeight.w600,
              onTap: () {
                List<String> aspiringData = [];
                for (int i = 0; i < aspiringStudentsList.length; i++) {
                  if (aspiringStudentsList[i]['value'].value) {
                    aspiringData.add(aspiringStudentsList[i]['title']);
                  }
                }
                Map<String, dynamic> request = {
                  ApiKeys.studentTypes: aspiringData,
                };
                myAuthProvider.editSkillsDetail(context, request: request);
              },
            )
          ],
        );
      },
    );
  }
}
