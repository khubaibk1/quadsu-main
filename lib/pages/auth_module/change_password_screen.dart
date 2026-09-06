
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';

import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordAddress = TextEditingController();
  ValueNotifier<bool> visibility0= ValueNotifier(true);
  TextEditingController newPasswordAddress = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  ValueNotifier<bool> visibility1 = ValueNotifier(true);
  ValueNotifier<bool> visibility2 = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Change password',
      ),
      bottomNavigationBar: Consumer<MyAuthProvider>(
        builder:(context, myAuthProvider, child) {
          return CustomButton(
            horizontalMargin: globalHorizontalPadding,
            height: 45,
            text: "Save",
            borderRadius: 4,
            fontWeight: FontWeight.w600,
            onTap: () {
              if (formKey.currentState!.validate()) {
                myAuthProvider.changePassword(context, request: {
                  ApiKeys.oldPassword:oldPasswordAddress.text.trim(),
                  ApiKeys.newPassword:newPasswordAddress.text.trim(),

                });

              }
            },
          );
        }
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 15),
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: visibility0,
                  builder: (_, value, __) => CustomTextField(
                    controller: oldPasswordAddress,
                    obscureText: value,
                    hintText: "*********",
                    headingText: 'Old password',
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 12,
                    validator: (val) =>
                        ValidationFunction.passwordValidation(val),
                    keyboardType: TextInputType.emailAddress,
                    suffix: IconButton(
                      onPressed: () {
                        visibility0.value = !value;
                      },
                      icon: Icon(
                        !value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: MyColors.color8A9FBA,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                vSizedBox2,      ValueListenableBuilder(
                  valueListenable: visibility1,
                  builder: (_, value, __) => CustomTextField(
                    controller: newPasswordAddress,
                    obscureText: value,
                    hintText: "*********",
                    headingText: 'New password',
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 12,
                    validator: (val) =>
                        ValidationFunction.passwordValidation(val),
                    keyboardType: TextInputType.emailAddress,
                    suffix: IconButton(
                      onPressed: () {
                        visibility1.value = !value;
                      },
                      icon: Icon(
                        !value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: MyColors.color8A9FBA,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                vSizedBox2,
                ValueListenableBuilder(
                  valueListenable: visibility2,
                  builder: (_, value, __) => CustomTextField(
                    controller: confirmPasswordController,
                    obscureText: value,
                    hintText: "*********",
                    headingText: 'Confirm password',
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 12,
                    validator: (val) =>
                        ValidationFunction.confirmPasswordValidation(val.toString(),newPasswordAddress.text.trim()),
                    keyboardType: TextInputType.emailAddress,
                    suffix: IconButton(
                      onPressed: () {
                        visibility2.value = !value;
                      },
                      icon: Icon(
                        !value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: MyColors.color8A9FBA,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                vSizedBox2,

              ],
            ),
          ),
        ),
      ),
    );
  }
}
