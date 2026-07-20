
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_scaffold.dart';

class AdminApproveScreen extends StatefulWidget {
  const AdminApproveScreen({super.key});

  @override
  State<AdminApproveScreen> createState() => _AdminApproveScreenState();
}

class _AdminApproveScreenState extends State<AdminApproveScreen> {
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: loginFormKey,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.comfortable,
                          onPressed: (){
                            var provider=Provider.of<MyAuthProvider>(context,listen: false);
                            provider.logoutPopup(context);
                          },
                          icon: Image.asset(MyImagesUrl.logout,width: 23,),
                        ),
                        hSizedBox05,
                        CustomText.headingSmall('Logout')

                      ],
                    ),
                    vSizedBox4,

                    Center(
                      child: Image.asset(
                        MyImagesUrl.splash,
                        height: 95,
                        // width: 150,
                      ),
                    ),
                    vSizedBox4,
                    Column(
                      children: [
                        vSizedBox,
                        CustomText.headingLarge(
                          "Thank you!",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        vSizedBox2,
                        CustomText.bodyText1(
                          "Your profile is under review. We will check and get back to you within 1-2 business days.",
                          textAlign: TextAlign.center,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
