import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class EditInterests extends StatefulWidget {
  const EditInterests({super.key});

  @override
  State<EditInterests> createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  ValueNotifier<bool> reload = ValueNotifier(false);
  TextEditingController hobbyController = TextEditingController();
  List hobbies = userDataNotifier.value?.guidePrefrence?.hobbies.trim().isEmpty == true
      ? []
      : userDataNotifier.value?.guidePrefrence?.hobbies.split(',') ?? [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: reload,
      builder: (context, reloadValue, child) {
        return Consumer<MyAuthProvider>(
          builder: (context, myAuthProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.headingSmall(
                  'Edit Interests',
                  fontWeight: FontWeight.w600,
                ),
                vSizedBox2,
                if (hobbies.isNotEmpty)
                  Wrap(
                    children: List.generate(
                      hobbies.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            hobbies.removeAt(index);
                            reload.value = !reload.value;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(right: 10, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: MyColors.fillColor,
                                border: Border.all(
                                    color: MyColors.enabledTextFieldBorderColor)),
                            child: CustomText.bodyText2(
                              "${hobbies[index]} ×",
                              fontWeight: FontWeight.w600,
                              increamentFontSize: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (hobbies.isNotEmpty) vSizedBox,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: hobbyController,
                        hintText: "Add an interest",
                        hintTextFontSize: 14,
                        fontSize: 14,
                        contentPaddingVertical: 11,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (hobbyController.text.trim().isNotEmpty) {
                          if (!hobbies.contains(hobbyController.text.trim())) {
                            hobbies.add(hobbyController.text.trim());
                            hobbyController.clear();
                            reload.value = !reload.value;
                          } else {
                            showSnackbar("Interest already added");
                          }
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                CustomButton(
                  height: 50,
                  borderRadius: 4,
                  text: 'Save',
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    if (hobbies.isEmpty) {
                      showSnackbar("Please add at least one interest");
                      return;
                    }
                    Map<String, dynamic> request = {
                      ApiKeys.hobbiesOrActivities: hobbies,
                    };
                    myAuthProvider.editSkillsDetail(context, request: request);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
