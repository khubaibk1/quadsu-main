
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../provider/bottom_tabbar_provider.dart';
import '../../widget/common_alert_dailog.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/home_nav.dart';

class BottomBarScreen extends StatelessWidget {
   const BottomBarScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return  Consumer<BottomTabBarProvider>(
        builder: (context,bottomTabBarProvider,_) {
          print("datdtadta:::::::$usertype");
          return WillPopScope(
            onWillPop: () async {
              BottomTabBarProvider bottomTabBarProvider =
              Provider.of<BottomTabBarProvider>(context, listen: false);
              if (bottomTabBarProvider.currentIndex == 0) {
                return await showCommonAlertDailog(context,
                    headingText: "Are you sure?",
                    message: "Do you want to exit the app",
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            text: "No",
                            verticalPadding: 0,
                            isSolid: true,
                            width: 100,
                            height: 40,
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          hSizedBox2,
                          CustomButton(
                            text: "Yes",
                            width: 100,
                            verticalPadding: 0,
                            height: 40,
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          hSizedBox,
                        ],
                      ),
                    ],
                    imageUrl: MyImagesUrl.logout);
              } else {

                bottomTabBarProvider.changeIndex(index: 0);
                return false;
              }
            },
            child: CustomScaffold(
              body: bottomTabBarProvider.tabs[bottomTabBarProvider.currentIndex],
              bottomNavigationBar: const HomeNav(),
            ),
          );
        }
    );
  }
}
