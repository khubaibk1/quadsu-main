// import 'package:flutter/material.dart';
// import 'package:quadsu_app/widget/custom_button.dart';
//
// import '../constants/global_keys.dart';
// import '../constants/my_colors.dart';
// import '../constants/sized_box.dart';
// import 'old_custom_text.dart';
//
//
// Future<bool?>  showCustomConfirmationDialog(
//     {
//       required String headingMessage,
//       String? description,
//
//     }
//     )async{
//   return await showDialog(
//       context: MyGlobalKeys.navigatorKey.currentContext!,
//       builder: (context) {
//         return Dialog(
//           insetPadding: EdgeInsets.symmetric(horizontal: 24),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SubHeadingText(
//                   headingMessage,
//                   color: Colors.red,
//                   fontSize: 22,
//                 ),
//                 vSizedBox,
//                 if(description!=null)
//                   ParagraphText( description),
//                 if(description!=null)
//                   vSizedBox2,
//                 vSizedBox2,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CustomButton(
//                       text: 'No',
//                       verticalPadding: 0,
//                       // horizontalPadding: 0,
//                       height: 36,
//                       width: 100,
//                       color: MyColors.primaryColor,
//                       isSolid: false,
//                       onTap: () {
//                         Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
//                       },
//                     ),
//                     hSizedBox2,
//                     CustomButton(
//                       text: 'Yes',
//                       verticalPadding: 0,
//                       height: 36,
//                       width: 100,
//                       color: MyColors.primaryColor,
//                       onTap: () {
//                         Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }

import 'package:flutter/material.dart';
import '../constants/global_keys.dart';
import '../constants/sized_box.dart';
import 'custom_button.dart';
import 'custom_text.dart';

Future<bool?> showCustomConfirmationDialog({
  String? headingMessage,
  String? description,
  String okButtonText = 'Yes',
  String cancelButtonText = 'Cancel',
  String? headingImage,
  IconData? headingIcon,
  Color? headingImageColor,
  Color? headingMessageColor,
  double? headingMessageFontSize,
  Color? descriptionMessageColor,
  double? descriptionMessageFontSize,
  double? imageHeight,
  Widget? widget,
  bool isCancelButton=true,
  double? horizontalPadding,
  double? verticalPadding,
  VoidCallback? okButtonClick,
  TextAlign ? headingAlign,
  TextAlign ? disAlign,
  double? padding
  // BuildContext? context
}) async {
  return await showDialog(
      context: MyGlobalKeys.navigatorKey.currentContext!,
      builder: (context) {
        return Dialog(
          insetPadding:  EdgeInsets.symmetric(
            horizontal:padding?? 36,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding:  EdgeInsets.symmetric(horizontal:horizontalPadding?? 24, vertical:verticalPadding?? 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // vSizedBox,
                // Text('dfgsdfg'),
                if (headingImage != null)
                  Image.asset(
                    headingImage,
                    fit: BoxFit.cover,
                    color: headingImageColor,
                    height: imageHeight ?? 70,
                  ),
                if (headingIcon != null)
                  Icon(
                    headingIcon,
                    color: headingImageColor,
                    size: imageHeight ?? 70,
                  ),
                if (headingImage != null||headingIcon != null) vSizedBox2,
                if (headingMessage != '')
                  CustomText.heading(
                    headingMessage ?? 'Are you sure?',
                     color: headingMessageColor,
                    fontSize: headingMessageFontSize??20,
                    textAlign: headingAlign,
                  ),
                vSizedBox,
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomText.bodyText1(
                      description,
                      color: descriptionMessageColor,
                      textAlign: disAlign??TextAlign.center,
                      fontSize:descriptionMessageFontSize?? 18,
                    ),
                  ),


                if (description != null) vSizedBox,
                if(widget != null)
                  widget,
                vSizedBox,

                Row(
                  mainAxisAlignment:isCancelButton? MainAxisAlignment.spaceEvenly:MainAxisAlignment.center,
                  children: [
                    // RoundEdgedButton(
                    //   text:cancelButtonText,
                    //   verticalPadding: 0,
                    //   height: 36,
                    //   width: 100,
                    //   isSolid: false,
                    //   color: MyColors.primaryColor,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    if(isCancelButton)
                    CustomButton(
                      text: cancelButtonText,
                      isSolid: false,
                      width: 100,
                      verticalMargin: 0,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context, false);
                    //   },
                    //   child: CustomText.buttonText(
                    //     cancelButtonText,
                    //     // color: Colors.black54,
                    //     // fontSize: 18,
                    //   ),
                    // ),
                    hSizedBox,
                    CustomButton(
                      text: okButtonText,
                      // verticalPadding: 0,
                      width: 100,
                      // isFlexible: true,
                      // height: 36,
                      // width: 100,
                      verticalMargin: 0,
                      onTap:okButtonClick?? () {
                        Navigator.pop(context, true);
                      },
                    ),
                    // RoundEdgedButton(
                    //   text: 'Yes',
                    //   verticalPadding: 0,
                    //   height: 36,
                    //   width: 100,
                    //   isSolid: false,
                    //   color: Colors.red,
                    //   onTap: () {
                    //     Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
                    //   },
                    // ),
                  ],
                ),
                // vSizedBox
              ],
            ),
          ),
        );
      });
}
