
String formatToTwoDecimalPlaces(double value) {
  return value.toStringAsFixed(2);
}

// import 'package:quadsu_app/constants/global_data.dart';
// import 'package:quadsu_app/constants/global_keys.dart';
// import 'package:quadsu_app/constants/my_colors.dart';
// import 'package:quadsu_app/constants/my_image_url.dart';
// import 'package:quadsu_app/constants/sized_box.dart';
// import 'package:quadsu_app/functions/navigation_functions.dart';
// import 'package:quadsu_app/functions/validation_functions.dart';
// import 'package:quadsu_app/widget/custom_bottom_sheet.dart';
// import 'package:quadsu_app/widget/custom_circular_image.dart';
// import 'package:quadsu_app/widget/custom_gesture_detector.dart';
// import 'package:quadsu_app/widget/old_custom_text.dart';
// import 'package:quadsu_app/widget/custom_text_field.dart';
// import 'package:quadsu_app/widget/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// void unFocusKeyBoard() {
//   FocusManager.instance.primaryFocus?.unfocus();
// }
//
// enum RequestType { pending, running, completed, applied }
//
// Widget commonUserCard(
//     {Color? backgroundColor,
//     required RequestType requestType,
//     VoidCallback? onTap,
//     VoidCallback? trackTap,
//     VoidCallback? viewTap,
//     required int index}) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 15),
//     child: CustomGestureDetector(
//       onTap: onTap ??
//           () {
//             if (requestType == RequestType.pending) {
//               push(
//                   context: MyGlobalKeys.navigatorKey.currentContext!,
//                   screen: ShipmentDetailScreen(
//                     userTypeData: userDataNotifier.value!.userType,
//                   ));
//             } else {
//               push(
//                 context: MyGlobalKeys.navigatorKey.currentContext!,
//                 screen: RunningShipmentDetailScreen(
//                   requestType: requestType,
//                   userTypeData: userDataNotifier.value!.userType,
//                 ),
//               );
//             }
//           },
//       borderRadiusDouble: 25,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(width: 1, color: MyColors.blackColor50),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MainHeadingText(
//                   "${cur}50.00",
//                   fontSize: 16,
//                 ),
//                 Row(
//                   children: [
//                     if (requestType == RequestType.completed)
//                       CustomGestureDetector(
//                         onTap: () {
//                           if (index.isOdd) {
//                             rattingBottomsheet(
//                                 context:
//                                     MyGlobalKeys.navigatorKey.currentContext!);
//                           } else {
//                             viewRattingBottomsheet(
//                                 context:
//                                     MyGlobalKeys.navigatorKey.currentContext!);
//                           }
//                         },
//                         borderRadiusDouble: 20,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 9, vertical: 4),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: MyColors.primaryColor,
//                           ),
//                           child: ParagraphText(
//                               index.isOdd ? "Rate the driver" : "View Rating",
//                               fontSize: 12,
//                               color: MyColors.whiteColor,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     if (requestType == RequestType.completed) hSizedBox,
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 9, vertical: 4),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: requestType == RequestType.completed
//                             ? MyColors.greenColor
//                             : MyColors.yellowColor,
//                       ),
//                       child: ParagraphText(
//                           requestType == RequestType.pending
//                               ? 'Pending'
//                               : requestType == RequestType.running
//                                   ? "Running"
//                                   : "Shipped",
//                           fontSize: 12,
//                           color: requestType == RequestType.completed
//                               ? MyColors.whiteColor
//                               : MyColors.blackColor,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             vSizedBox,
//             Divider(
//               height: 1,
//               color: MyColors.blackColor50,
//             ),
//             vSizedBox,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const MainHeadingText(
//                       "California",
//                       fontSize: 15,
//                     ),
//                     vSizedBox02,
//                     ParagraphText(
//                       '03-Apr-2024',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.blackColor50,
//                     )
//                   ],
//                 ),
//                 Image.asset(
//                   MyImagesUrl.iconArrowForword,
//                   height: 12,
//                   width: 16,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const MainHeadingText(
//                       "Alaska",
//                       fontSize: 15,
//                     ),
//                     vSizedBox02,
//                     ParagraphText(
//                       '10-Apr-2024',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.blackColor50,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             if (requestType != RequestType.pending) vSizedBox,
//             if (requestType != RequestType.pending)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const CustomCircularImage(
//                           imageUrl: MyImagesUrl.iconDummyUser,
//                           width: 45,
//                           height: 45,
//                           borderRadius: 25,
//                           fileType: CustomFileType.asset),
//                       hSizedBox,
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                            MainHeadingText(
//                             "${userDataNotifier.value!.fullName}",
//                             // "John Doe",
//                             fontSize: 14,
//                           ),
//                           vSizedBox02,
//                           ParagraphText(
//                             '#123245865841BAD',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: MyColors.blackColor50,
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   if (requestType == RequestType.running)
//                     CustomGestureDetector(
//                       onTap: trackTap ??
//                           () {
//                             push(
//                                 context:
//                                     MyGlobalKeys.navigatorKey.currentContext!,
//                                 screen: const TrackingScreen(
//                                   // isCompany: false,
//                                 ));
//                           },
//                       borderRadiusDouble: 7,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 9, vertical: 4),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7),
//                           color: MyColors.primaryColor,
//                         ),
//                         child: const ParagraphText('Track Shipment',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: MyColors.whiteColor),
//                       ),
//                     )
//                   else
//                     CustomGestureDetector(
//                       onTap: viewTap,
//                       borderRadiusDouble: 7,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7),
//                           color: MyColors.primaryColor,
//                         ),
//                         child: const ParagraphText('View',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: MyColors.whiteColor),
//                       ),
//                     )
//                 ],
//               )
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// // Widget commonDriverCard({
// //   Color? backgroundColor,
// //   required int index,
// //   required RequestType requestType,
// //   VoidCallback? onTap,
// //   VoidCallback? trackTap,
// //   VoidCallback? viewTap,
// // }) {
// //   return Padding(
// //     padding: const EdgeInsets.only(bottom: 15),
// //     child: CustomGestureDetector(
// //       onTap: onTap ??
// //           () {
// //             if (requestType == RequestType.pending) {
// //               push(
// //                   context: MyGlobalKeys.navigatorKey.currentContext!,
// //                   screen: ShipmentDetailScreen(
// //                     userTypeData: userDataNotifier.value!.userType,
// //                   ));
// //             } else {
// //               push(
// //                 context: MyGlobalKeys.navigatorKey.currentContext!,
// //                 screen: RunningShipmentDetailScreen(
// //                   requestType: requestType,
// //                   userTypeData: userDataNotifier.value!.userType!,
// //                   // isCompany: false,
// //                 ),
// //               );
// //             }
// //           },
// //       borderRadiusDouble: 25,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
// //         decoration: BoxDecoration(
// //           color: backgroundColor,
// //           borderRadius: BorderRadius.circular(25),
// //           border: Border.all(width: 1, color: MyColors.blackColor50),
// //         ),
// //         child: Column(
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 MainHeadingText(
// //                   "${cur}50.00",
// //                   fontSize: 16,
// //                 ),
// //                 Row(
// //                   children: [
// //                     if (requestType == RequestType.completed)
// //                       CustomGestureDetector(
// //                         onTap: () {
// //                           if (index.isOdd) {
// //                             rattingBottomsheet(
// //                                 context:
// //                                     MyGlobalKeys.navigatorKey.currentContext!);
// //                           } else {
// //                             viewRattingBottomsheet(
// //                                 context:
// //                                     MyGlobalKeys.navigatorKey.currentContext!);
// //                           }
// //                         },
// //                         borderRadiusDouble: 20,
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 9, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(20),
// //                             color: MyColors.primaryColor,
// //                           ),
// //                           child: ParagraphText(
// //                               index.isOdd ? "Rate the user" : "View Ratting",
// //                               fontSize: 12,
// //                               color: MyColors.whiteColor,
// //                               fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                     if (requestType == RequestType.completed) hSizedBox,
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 9, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(20),
// //                         color: requestType == RequestType.completed
// //                             ? MyColors.greenColor
// //                             : MyColors.yellowColor,
// //                       ),
// //                       child: ParagraphText(
// //                           requestType == RequestType.pending
// //                               ? 'New'
// //                               : requestType == RequestType.running
// //                                   ? "Running"
// //                                   : "Shipped",
// //                           fontSize: 12,
// //                           color: requestType == RequestType.completed
// //                               ? MyColors.whiteColor
// //                               : MyColors.blackColor,
// //                           fontWeight: FontWeight.w600),
// //                     ),
// //                   ],
// //                 )
// //               ],
// //             ),
// //             vSizedBox,
// //             Divider(
// //               height: 1,
// //               color: MyColors.blackColor50,
// //             ),
// //             vSizedBox,
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const MainHeadingText(
// //                       "California",
// //                       fontSize: 15,
// //                     ),
// //                     vSizedBox02,
// //                     ParagraphText(
// //                       '03-Apr-2024',
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w400,
// //                       color: MyColors.blackColor50,
// //                     )
// //                   ],
// //                 ),
// //                 Image.asset(
// //                   MyImagesUrl.iconArrowForword,
// //                   height: 12,
// //                   width: 16,
// //                 ),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     const MainHeadingText(
// //                       "Alaska",
// //                       fontSize: 15,
// //                     ),
// //                     vSizedBox02,
// //                     ParagraphText(
// //                       '10-Apr-2024',
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w400,
// //                       color: MyColors.blackColor50,
// //                     )
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             vSizedBox,
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Row(
// //                   children: [
// //                     const CustomCircularImage(
// //                         imageUrl: MyImagesUrl.iconDummyUser,
// //                         width: 45,
// //                         height: 45,
// //                         borderRadius: 25,
// //                         fileType: CustomFileType.asset),
// //                     hSizedBox,
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                          MainHeadingText(
// //                           "${userDataNotifier.value!.fullName}",
// //                           // "John Doe",
// //                           fontSize: 14,
// //                         ),
// //                         vSizedBox02,
// //                         ParagraphText(
// //                           '#123245865841BAD',
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w400,
// //                           color: MyColors.blackColor50,
// //                         )
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 if (requestType == RequestType.running)
// //                   CustomGestureDetector(
// //                     onTap: trackTap ??
// //                         () {
// //                           push(
// //                               context:
// //                                   MyGlobalKeys.navigatorKey.currentContext!,
// //                               screen: const TrackingScreen(
// //                                 // isCompany: false,
// //                               ));
// //                         },
// //                     borderRadiusDouble: 7,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 9, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(7),
// //                         color: MyColors.primaryColor,
// //                       ),
// //                       child: const ParagraphText('Track Shipment',
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                           color: MyColors.whiteColor),
// //                     ),
// //                   )
// //                 else
// //                   CustomGestureDetector(
// //                     onTap: viewTap,
// //                     borderRadiusDouble: 7,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(7),
// //                         color: MyColors.primaryColor,
// //                       ),
// //                       child: const ParagraphText('View',
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                           color: MyColors.whiteColor),
// //                     ),
// //                   )
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }
//
// Widget commonCompanyCard() {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 15),
//     child: CustomGestureDetector(
//       onTap: () {
//         push(
//             context: MyGlobalKeys.navigatorKey.currentContext!,
//             screen: ShipmentDetailScreen(
//               userTypeData: userDataNotifier.value!.userType,
//               isCompany: true,
//             ));
//       },
//       borderRadiusDouble: 25,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           color: MyColors.whiteColor,
//           border: Border.all(width: 1, color: MyColors.blackColor50),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ParagraphText(
//                   '#123245865841BAD',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: MyColors.blackColor50,
//                 )
//               ],
//             ),
//             vSizedBox05,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MainHeadingText(
//                   "${cur}50.00",
//                   fontSize: 16,
//                 ),
//                 const MainHeadingText(
//                   "Weight: 200 kg",
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(7),
//                     color: MyColors.primaryColor,
//                   ),
//                   child: const ParagraphText('View',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: MyColors.whiteColor),
//                 )
//               ],
//             ),
//             vSizedBox,
//             Divider(
//               height: 1,
//               color: MyColors.blackColor50,
//             ),
//             vSizedBox,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const MainHeadingText(
//                       "California",
//                       fontSize: 15,
//                     ),
//                     vSizedBox02,
//                     ParagraphText(
//                       '03-Apr-2024',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.blackColor50,
//                     )
//                   ],
//                 ),
//                 Image.asset(
//                   MyImagesUrl.iconArrowForword,
//                   height: 12,
//                   width: 16,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const MainHeadingText(
//                       "Alaska",
//                       fontSize: 15,
//                     ),
//                     vSizedBox02,
//                     ParagraphText(
//                       '10-Apr-2024',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.blackColor50,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget reviewList() => ListView.builder(
//       itemCount: 3,
//       padding: const EdgeInsets.symmetric(
//         horizontal: globalHorizontalPadding,
//       ),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 15),
//           child: CustomGestureDetector(
//             onTap: () {},
//             borderRadiusDouble: 25,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(width: 1, color: MyColors.blackColor50),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const CustomCircularImage(
//                           imageUrl: MyImagesUrl.iconDummyUser,
//                           width: 50,
//                           height: 50,
//                           borderRadius: 25,
//                           padding: 0,
//                           fileType: CustomFileType.asset),
//                       hSizedBox,
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const MainHeadingText(
//                               "John Doe",
//                               fontSize: 14,
//                             ),
//                             MainHeadingText(
//                               "Apr 2022",
//                               fontSize: 12,
//                               color: MyColors.blackColor50,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Image.asset(
//                             MyImagesUrl.iconRatting,
//                             height: 16,
//                             width: 16,
//                           ),
//                           hSizedBox05,
//                           const Padding(
//                             padding: EdgeInsets.only(top: 3),
//                             child: MainHeadingText(
//                               "4.7",
//                               fontSize: 12,
//                               color: MyColors.blackColor,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   vSizedBox,
//                   const ParagraphText(
//                     "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//
// Widget uploadedImageView() {
//   return SizedBox(
//     height: 80,
//     child: ListView.builder(
//         itemBuilder: (context, index) {
//           return const Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: CustomCircularImage(
//                 imageUrl: MyImagesUrl.iconDummyUser,
//                 width: 80,
//                 height: 80,
//                 borderRadius: 15,
//                 padding: 0,
//                 fileType: CustomFileType.asset),
//           );
//         },
//         shrinkWrap: true,
//         itemCount: 10,
//         scrollDirection: Axis.horizontal),
//   );
// }
//
// Future<void> rattingBottomsheet({
//   required BuildContext context,
// }) async {
//   await customBottomSheet(
//     context,
//     child: SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           MainHeadingText(
//             /// commented to check 21/5/24
//             // userDataNotifier.value!.userType == UserType.user ? "Rate the driver" :
//             // "Rate the User",
//             "Rate the Company",
//             fontWeight: FontWeight.w600,
//             fontSize: 17,
//           ),
//           vSizedBox2,
//           RatingBar.builder(
//             initialRating: 1.0,
//             minRating: 1,
//             ignoreGestures: false,
//             direction: Axis.horizontal,
//             allowHalfRating: true,
//             itemCount: 5,
//             itemSize: 40.0,
//             itemBuilder: (context, _) => const Icon(
//               Icons.star,
//               color: MyColors.primaryColor,
//             ),
//             onRatingUpdate: (rating) {},
//           ),
//           vSizedBox2,
//           const MainHeadingText(
//             "Rate for better services",
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           ),
//           vSizedBox2,
//           InputTextFieldWidget(
//             controller: TextEditingController(),
//             borderRadius: 15,
//             maxLines: 4,
//             keyboardType: TextInputType.multiline,
//             hintText: "Write your feedback here...",
//             validator: (val) => ValidationFunction.requiredValidation(
//               val,
//             ),
//           ),
//           vSizedBox,
//           RoundEdgedButton(
//             text: "Submit",
//             onTap: () {
//               CustomNavigation.pop( context);
//             },
//             verticalMargin: 10,
//             fontSize: 18,
//             borderRadius: 15,
//             fontWeight: FontWeight.w700,
//             color: MyColors.primaryColor,
//           ),
//         ],
//       ),
//     ),
//     isHorizontalPadding: false,
//   );
// }
//
// Future<void> viewRattingBottomsheet({
//   required BuildContext context,
// }) async {
//   await customBottomSheet(
//     context,
//     child: SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const MainHeadingText(
//             "Your Review",
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//           vSizedBox,
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: globalHorizontalPadding, vertical: 12),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(width: 1, color: MyColors.blackColor50)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const CustomCircularImage(
//                     imageUrl: MyImagesUrl.iconDummyUser,
//                     width: 60,
//                     height: 60,
//                     borderRadius: 30,
//                     padding: 0,
//                     fileType: CustomFileType.asset),
//                 hSizedBox,
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const ParagraphText(
//                         "Simon	Dickens",
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       vSizedBox02,
//                       ParagraphText(
//                         "Nice to meet you too! Looks like we both enjoy going to comedy ows! ",
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                         color: MyColors.blackColor50,
//                       ),
//                       vSizedBox02,
//                       RatingBar.builder(
//                         initialRating: 5,
//                         minRating: 1,
//                         ignoreGestures: true,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 15,
//                         itemBuilder: (context, _) => const Icon(
//                           Icons.star,
//                           color: MyColors.primaryColor,
//                         ),
//                         onRatingUpdate: (rating) {},
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           vSizedBox2,
//           MainHeadingText(
//             /// commented to check 21/5/24
//             // userDataNotifier.value!.userType == UserType.user ? "Driver Review" :
//             "User Review",
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//           vSizedBox,
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: globalHorizontalPadding, vertical: 12),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(width: 1, color: MyColors.blackColor50)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const CustomCircularImage(
//                     imageUrl: MyImagesUrl.iconDummyUser,
//                     width: 60,
//                     height: 60,
//                     borderRadius: 30,
//                     padding: 0,
//                     fileType: CustomFileType.asset),
//                 hSizedBox,
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const ParagraphText(
//                         "Simon	Dickens",
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       vSizedBox02,
//                       ParagraphText(
//                         "Nice to meet you too! Looks like we both enjoy going to comedy ows! ",
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                         color: MyColors.blackColor50,
//                       ),
//                       vSizedBox02,
//                       RatingBar.builder(
//                         initialRating: 5,
//                         minRating: 1,
//                         ignoreGestures: true,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 15,
//                         itemBuilder: (context, _) => const Icon(
//                           Icons.star,
//                           color: MyColors.primaryColor,
//                         ),
//                         onRatingUpdate: (rating) {},
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           vSizedBox,
//         ],
//       ),
//     ),
//     isHorizontalPadding: false,
//   );
// }
//
// Widget commonTabBar({
//   required TabController tabController,
//   required BuildContext context,
//   required List<Widget> tabs,
//   ValueChanged<int>? onTap,
//   ScrollPhysics? physics,
//   Decoration? indicatorDecoration,
//   TabBarIndicatorSize tabBarIndicatorSize = TabBarIndicatorSize.tab,
//   TabAlignment tabAlignment = TabAlignment.fill,
//   EdgeInsetsGeometry? indicatorPadding,
//   EdgeInsetsGeometry? tabPadding,
//   double? indicatorWeight,
//   Color? indicatorColor,
//   Color? selectedLabelColor,
//   Color? unselectedLabelColor,
//   TextStyle? selectedLabelStyle,
//   TextStyle? unselectedLabelStyle,
//   bool isScrollable = false,
// }) =>
//     SizedBox(
//       height: 50,
//       child: Card(
//         elevation: 0,
//         margin: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0),
//         ),
//         color: indicatorColor ?? Colors.white,
//         child: TabBar(
//           physics: physics ?? const NeverScrollableScrollPhysics(),
//           onTap: onTap,
//           isScrollable: isScrollable,
//           automaticIndicatorColorAdjustment: false,
//           indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
//           padding: tabPadding ?? EdgeInsets.zero,
//           indicatorWeight: indicatorWeight ?? 0,
//           labelColor: selectedLabelColor ?? MyColors.primaryColor,
//           unselectedLabelColor: selectedLabelColor ?? MyColors.blackColor50,
//           labelStyle: TextStyle(
//               color: MyColors.whiteColor,
//               fontWeight: FontWeight.w600,
//               fontFamily: fontFamily,
//               fontSize: 15),
//           unselectedLabelStyle: TextStyle(
//               color: MyColors.blackColor,
//               fontWeight: FontWeight.w600,
//               fontFamily: fontFamily,
//               fontSize: 15),
//           tabAlignment: tabAlignment,
//           splashBorderRadius: BorderRadius.circular(0),
//           indicatorSize: tabBarIndicatorSize,
//           labelPadding: EdgeInsets.zero,
//           dividerColor: Colors.transparent,
//           indicator: indicatorDecoration ??
//               BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: MyColors.primaryColor),
//           tabs: tabs,
//           controller: tabController,
//         ),
//       ),
//     );
