import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_rating.dart';
import 'package:quadsu_app/widget/custom_text.dart';

import '../../provider/search_guide_provider.dart';
import '../../widget/custom_button.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  ValueNotifier<bool> reload = ValueNotifier(false);

  ValueNotifier<List<double>> rangeSlider = ValueNotifier([1, 500]);

  List<String> selectedStudentPre = [];
  List<String> studentPreList = [
    "College",
    "Graduate School"
  ];

  List<String> selectedUniversity = [];
  List universityList = [];

  List<String> selectedLanguages = [];
  List languageList = [];

  List<String> availability = [];
  List<String> daysList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  List<String> ratting = [];
  List<String> rattingList = ["5", "4", "3", "2", "1"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        SearchGuideProvider searchGuideProvider =
            Provider.of<SearchGuideProvider>(context, listen: false);
        MyAuthProvider myAuthProvider =
            Provider.of<MyAuthProvider>(context, listen: false);

        if(searchGuideProvider.searchHourlyRate.isNotEmpty)
          {
            rangeSlider.value[0]=double.parse(searchGuideProvider.searchHourlyRate.split('-').first);
            rangeSlider.value[1]=double.parse(searchGuideProvider.searchHourlyRate.split('-').last);
          }


        selectedStudentPre=List.from(searchGuideProvider.searchStudentPrefValues);

        universityList = List.from(myAuthProvider.globalUniversity);
        selectedUniversity = List.from(searchGuideProvider.searchUniversityValues);

        languageList = List.from(myAuthProvider.globalLanguages);
        selectedLanguages =List.from( searchGuideProvider.searchLanguageValues);

        availability = List.from(searchGuideProvider.searchAvailableDaysValues);

        ratting = List.from(searchGuideProvider.searchRattingValues);

        reload.value = !reload.value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchGuideProvider>(
        builder: (context, searchGuideProvider, child) {
      return ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.headingSmall(
                      'Hourly rate',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    ValueListenableBuilder(
                      valueListenable: rangeSlider,
                      builder: (context, value, child) => FlutterSlider(
                        rangeSlider: true,
                        max: 500,
                        min: 0,
                        values: value,
                        handlerHeight: 20,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          rangeSlider.value[0] = lowerValue;
                          rangeSlider.value[1] = upperValue;
                          reload.value = !reload.value;
                        },
                        tooltip: FlutterSliderTooltip(
                          alwaysShowTooltip: true,
                          positionOffset:
                              FlutterSliderTooltipPositionOffset(top: 35),
                          direction: FlutterSliderTooltipDirection.top,
                          custom: (value) {
                            return const SizedBox(height: 10,width: 10,);
                          },
                        ),
                        trackBar: const FlutterSliderTrackBar(
                            activeTrackBar: BoxDecoration(
                              color: MyColors.primaryColor,
                            ),
                            activeTrackBarHeight: 2,
                            inactiveTrackBarHeight: 2),
                        handler: FlutterSliderHandler(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.primaryColor),
                            child: const Material(
                              elevation: 40,
                            )),
                        rightHandler: FlutterSliderHandler(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.primaryColor),
                            child: const Material(
                              elevation: 40,
                            )),
                      ),
                    ),
                    vSizedBox05,
                    ValueListenableBuilder(
                        valueListenable: rangeSlider,
                        builder: (context, value, child)  {
                        return CustomText.bodyText2(
                          '\$${value.first.toInt()} - \$${value.last.toInt()}',
                          fontWeight: FontWeight.w600,
                        );
                      }
                    ),
                    vSizedBox3,
                    CustomText.headingSmall(
                      'Search By Student Type',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    Column(
                      children: [

                        for(int i=0;i<studentPreList.length;i++)
                        customCheckBox(
                            widget: CustomText.bodyText2(
                                studentPreList[i],
                            ),
                            value: selectedStudentPre.contains( studentPreList[i]),
                            onChanged: (val) {
                                if (selectedStudentPre.contains(studentPreList[i])) {
                                  selectedStudentPre.remove(studentPreList[i]);
                                } else {
                                  selectedStudentPre.add(studentPreList[i]);
                                }
                                reload.value = !reload.value;
                            }),

                      ],
                    ),
                    vSizedBox2,
                    CustomText.headingSmall(
                      'Search By University',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    SizedBox(
                      height: 145,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: universityList.length,
                        itemBuilder: (context, index) {
                          final universityId = universityList[index][ApiKeys.id].toString();

                          return customCheckBox(
                            widget: CustomText.bodyText2(
                              universityList[index][ApiKeys.universityName],
                            ),
                            value: selectedUniversity.contains(universityId)
                                ? true
                                : false,
                            onChanged: (val) {

                              if (selectedUniversity.contains(universityId)) {
                                selectedUniversity.remove(universityId);
                              } else {
                                selectedUniversity.add(universityId);
                              }
                              reload.value = !reload.value;
                            },);
                        },
                      ),
                    ),

                    vSizedBox2,
                    CustomText.headingSmall(
                      'Search By Language',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    SizedBox(
                      height: 145,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: languageList.length,
                        itemBuilder: (context, index) {
                          final languageId = languageList[index][ApiKeys.id].toString();

                          return customCheckBox(
                              widget: CustomText.bodyText2(
                                languageList[index][ApiKeys.language],
                              ),
                              value: selectedLanguages.contains(languageId)
                                  ? true
                                  : false,
                            onChanged: (val) {

                              if (selectedLanguages.contains(languageId)) {
                                selectedLanguages.remove(languageId);
                              } else {
                                selectedLanguages.add(languageId);
                              }
                              reload.value = !reload.value;
                            },);
                        },
                      ),
                    ),
                    vSizedBox2,
                    CustomText.headingSmall(
                      'Search By Availability',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    Column(
                      children: [
                        for (int i = 0; i < daysList.length; i++)
                          customCheckBox(
                              widget: CustomText.bodyText2(
                                daysList[i],
                              ),
                              value:
                                  availability.contains(daysList[i]) ? true : false,
                              onChanged: (val) {
                                if (availability.contains(daysList[i])) {
                                  availability.remove(daysList[i]);
                                } else {
                                  availability.add(daysList[i]);
                                }
                                reload.value = !reload.value;
                              }),
                      ],
                    ),
                    vSizedBox2,
                    CustomText.headingSmall(
                      'Search By Rating',
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox05,
                    Column(
                      children: [
                        for (int i = 0; i < rattingList.length; i++)
                          customCheckBox(
                              widget: CustomRating(
                                itemSize: 16,
                                rating: int.parse(rattingList[i]).toDouble(),
                              ),
                              value:
                                  ratting.contains(rattingList[i]) ? true : false,
                              onChanged: (val) {
                                if (ratting.contains(rattingList[i])) {
                                  ratting.remove(rattingList[i]);
                                } else {
                                  ratting.add(rattingList[i]);
                                }
                                reload.value = !reload.value;
                              }),
                        vSizedBox2,
                        CustomButton(
                          height: 45,
                          onTap: () {
                            searchGuideProvider.searchHourlyRate='${rangeSlider.value.first.toInt()}-${rangeSlider.value.last.toInt()}';
                            searchGuideProvider.searchStudentPrefValues = selectedStudentPre;
                            searchGuideProvider.searchUniversityValues = selectedUniversity;
                            searchGuideProvider.searchLanguageValues = selectedLanguages;
                            searchGuideProvider.searchAvailableDaysValues = availability;
                            searchGuideProvider.searchRattingValues = ratting;
                            CustomNavigation.pop(context);
                          },
                          text: 'Apply',
                          verticalMargin: 0,
                          borderRadius: 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          });
    });
  }

  customCheckBox(
      {required value,
      required Widget widget,
      required void Function(bool?)? onChanged}) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
              visualDensity: VisualDensity.compact,
              checkColor: MyColors.whiteColor,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) =>
                      value ? MyColors.primaryColor : MyColors.fillColor),
              side: WidgetStateBorderSide.resolveWith(
                (states) => BorderSide(
                    width: 1.0,
                    color: value
                        ? MyColors.primaryColor
                        : MyColors.enabledTextFieldBorderColor),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              onChanged: onChanged),
        ),
        Expanded(child: widget)
      ],
    );
  }
}
