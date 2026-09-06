import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import '../constants/global_data.dart';
import '../constants/my_colors.dart';
import '../constants/my_image_url.dart';
import '../constants/sized_box.dart';
import 'custom_button.dart';

showCommonAlertDailog(context,
    {String? message,
    String? headingText,
    double? headingFontSize,
    FontWeight? headingFontWeight,
    Widget? richText,
    String? cancelButtonText,
    String? confirmButtonText,
    bool successIcon = false,
    bool error = false,
    MainAxisAlignment buttonAlignMent = MainAxisAlignment.end,
    bool showCancelButton = true,
    String? imageUrl,
      Icon? icon,
      Color? imageColor,
    List<Widget>? actions}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: MyColors.whiteColor,
        backgroundColor: MyColors.whiteColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        titlePadding: const EdgeInsets.symmetric(vertical: 18),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        title: imageUrl != null
            ? Center(
                child: Image.asset(
                  imageUrl,
                  width: 70,
                  color: imageColor,
                ),
              )
            : icon != null
                ? Center(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border:
                                Border.all(color: MyColors.redColor, width: 2)),
                        child: icon),
                  )
                : successIcon
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 2)),
                          child: const Icon(
                            Icons.done_outline_sharp,
                            color: MyColors.primaryColor,
                            size: 45,
                          ),
                        ),
                      )
                    : error
                        ? Center(
                            child: Container(
                              // padding: const EdgeInsets.all(10),
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const Icon(
                                Icons.error_outline_outlined,
                                color: MyColors.redColor,
                                size: 60,
                              ),
                            ),
                          )
                        : Container(),
        actions: actions ??
            [
              Row(
                mainAxisAlignment: buttonAlignMent,
                children: [
                  if (showCancelButton)
                    CustomButton(
                      text: cancelButtonText??"Cancel",
                      width: 100,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  hSizedBox2,
                  CustomButton(
                    text: confirmButtonText ?? "Ok",
                    width: 100,
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (headingText != null)
              Align(
                  alignment: Alignment.center,
                  child: CustomText.heading(
                    headingText,
                    textAlign: TextAlign.center,
                    fontSize: headingFontSize ?? 20,
                    fontWeight: FontWeight.w600,
                  ),
              ),
            if (headingText != null)
              vSizedBox2,
            if (message != null)
              CustomText.bodyText2(
                message,
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
            if (richText != null) richText
          ],
        ),
      );
    },
  );
}

Future<void> showSuccessPopup({
  required BuildContext context,
  required String heading,
  required String subtitle,
  required Widget bottomWidget,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: MyColors.whiteColor,
        insetPadding: const EdgeInsets.symmetric(
            horizontal: globalHorizontalPadding + globalHorizontalPadding),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: globalHorizontalPadding, vertical: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: MyColors.whiteColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.bodyText1(
                heading,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              vSizedBox2,
              Image.asset(
                MyImagesUrl.logout,
                height: 92,
                width: 92,
              ),
              vSizedBox2,
              Center(
                  child: CustomText.bodyText1(
                subtitle,
                fontSize: 13,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w400,
              )),
              vSizedBox,
              bottomWidget,
            ],
          ),
        ),
      );
    },
  );
}
