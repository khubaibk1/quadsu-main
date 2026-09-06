// import 'package:flutter/material.dart';
// import 'package:quadsu_app/widget/custom_button.dart';
// import '../constants/my_colors.dart';
// import '../constants/sized_box.dart';
// import 'old_custom_text.dart';
//
// popMenuButton({required buttonText,
//   required List<dynamic>sortList,
//   required double width,
//   String? image}) {
//   return PopupMenuButton(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8)
//     ),
//     surfaceTintColor: Colors.white,
//     offset: const Offset(0, 25),
//     itemBuilder: (context) =>List.generate(sortList.length,(index) => PopupMenuItem(
//       value: sortList[index]['title'],
//       height: 30,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SubHeadingText(
//                 sortList[index]['title'].toString(),
//                 fontWeight: FontWeight.w400,
//                 color: MyColors.secondaryColor,
//                 fontSize: 12,
//               ),
//               if(sortList[index]['takingTime']!=null)
//                 hSizedBox2,
//               if(sortList[index]['takingTime']!=null)
//                 SubHeadingText(
//                   '\$${sortList[index]['takingTime']}/M',
//                   fontWeight: FontWeight.w400,
//                   color: MyColors.redColor,
//                   fontSize: 12,
//                 ),
//             ],
//           ),
//           if (index!=sortList.length-1) vSizedBox05,
//           if (index!=sortList.length-1)
//             const Divider(height: 2,color: MyColors.greyColor,)
//         ],
//       ),
//     )
//         )
//         .toList(),
//     onSelected: (value) {
//       if (value == 'edit') {
//         // Handle edit action
//         print('Edit action for ');
//       } else if (value == 'delete') {
//         // Handle delete action
//         print('Delete action for}');
//       }
//     },
//     child: image==null?  const CustomButton(
//       width: 140,
//       height: 25,
//       fontSize: 14,
//       borderRadius: 7,
//       verticalPadding: 0,
//       horizontalPadding: 0,
//       fontWeight: FontWeight.w500,
//       text: 'Choose Farmhouse',
//       onTap:null,
//       verticalMargin: 3,
//       textColor: MyColors.blackColor,
//       color: MyColors.primaryColor,
//     ):CustomButton(
//       width: width,
//       height: 22,
//       fontSize:buttonText=='Sort'? 13:10,
//       borderRadius: 4,
//       textAlign: TextAlign.left,
//       horizontalPadding: 0,
//       verticalMargin: 0,
//       prefix: Image.asset(image,width: 25,),
//       icon:image,
//       isIconStart: buttonText=='Sort'? true:false,
//       iconHeight:buttonText=='Sort'? 15:6,
//       showShadow:false,
//       fontWeight: FontWeight.w400,
//       text: buttonText,
//       onTap:null,
//       textColor: MyColors.blackColor,
//       color: MyColors.greyColor,
//     ),
//
//     // Container(
//     //   height: 20,
//     //   padding: const EdgeInsets.symmetric(horizontal: 4,),
//     //   decoration: BoxDecoration(
//     //     color: MyColors.greyColor,
//     //     borderRadius: BorderRadius.circular(4),
//     //   ),
//     //   child: Row(
//     //     children: [
//     //       if (!isArrowDown)
//     //         Image.asset(
//     //           MyImagesUrl.sortList,
//     //           width: 14,
//     //           height: 11,
//     //           color: MyColors.blackColor,
//     //         ),
//     //       hSizedBox02,
//     //       SubHeadingText(
//     //         buttonText,
//     //         fontSize: buttonText == 'Sort' ? 13 : 10,
//     //         color: MyColors.blackColor,
//     //         fontWeight: FontWeight.w400,
//     //       ),
//     //       if (isArrowDown)
//     //         const Icon(
//     //           Icons.keyboard_arrow_down,
//     //           color: MyColors.blackColor,
//     //           size: 16,
//     //         )
//     //     ],
//     //   ),
//     // ),
//   );
// }
//
// showPopupMenu({
//   context,
//   position,
//   required List<PopupMenuEntry<dynamic>> item,
// }) {
//   return showMenu(
//     context: context,
//     position: position,
//     color: MyColors.whiteColor,
//     shape: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: const BorderSide(color: Colors.transparent)),
//     items: item,
//     elevation: 8.0,
//   );
// }
