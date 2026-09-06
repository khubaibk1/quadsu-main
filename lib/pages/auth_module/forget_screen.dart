import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController emailAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          color: MyColors.whiteColor,
          image: DecorationImage(
              alignment: Alignment.bottomLeft,
              image: AssetImage(MyImagesUrl.loginBgImage),
          fit: BoxFit.fill
          )),
      child: CustomScaffold(
        backgroundColor: MyColors.transparent,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: GestureDetector(
            onTap: () {
              CustomNavigation.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.bodyText2(
                  "Back to ",
                  fontSize: 13,
                ),
                CustomText.bodyText2(
                  "Log In.",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: MyColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox8,
                  Center(
                    child: Image.asset(
                      MyImagesUrl.splash,
                      height: 90,
                      // width: 150,
                    ),
                  ),
                  vSizedBox4,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: globalHorizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSizedBox,
                        CustomText.headingLarge(
                          "Forgot password",
                          fontSize: 18,
                        ),
                        CustomText.headingSmall(
                          "Please enter registered email.",
                          fontSize: 14,
                          color: MyColors.blackColor50,
                        ),
                        vSizedBox3,
                        CustomTextField(
                          controller: emailAddress,
                          obscureText: false,
                          hintText: "Email ID",
                          validator: (val) {
                            return ValidationFunction.emailValidation(val);
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        vSizedBox3,
                        Consumer<MyAuthProvider>(
                            builder: (context, myAuthProvider, child) {
                              return CustomButton(
                                height: 50,
                                text: "Send",
                                onTap: () {
                                  if (loginFormKey.currentState!.validate()) {
                                    myAuthProvider.forgetPassword(context, email: emailAddress.text.trim());
                                  }
                                },
                              );
                            }),
                        vSizedBox3,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
