// import 'package:flutter/material.dart';
// import 'package:quadsu_app/constants/global_data.dart';
// import 'package:quadsu_app/widget/custom_appbar.dart';
// import 'package:quadsu_app/widget/custom_scaffold.dart';
// import '../../constants/my_colors.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../widget/app_specific/custom_shadow_container.dart';
// import '../../widget/custom_image.dart';
//
// import '../../widget/custom_text.dart';
//
//
// class StudentProfileScreen extends StatefulWidget {
//   const StudentProfileScreen({super.key});
//
//   @override
//   State<StudentProfileScreen> createState() => _StudentProfileScreenState();
// }
//
// class _StudentProfileScreenState extends State<StudentProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: CustomAppBar(
//         titleText: 'Profile',
//       ),
//       body: SingleChildScrollView(
//         padding:
//         const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const CustomImage(
//                   imageUrl: MyImagesUrl.image01,
//                   height: 90,
//                   width: 90,
//                   isShowStackImage: true,
//                   fileType: CustomFileType.asset,
//                 ),
//                 hSizedBox,
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText.heading(
//                       'Katharine Miao',
//                       fontWeight: FontWeight.w600,
//                     ),
//                     vSizedBox02,
//                     CustomText.bodyText2(
//                       'Indore, india',
//                       color:MyColors.blackColor50 ,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             vSizedBox2,
//
//             CustomText.bodyText2('Basic Details',
//               fontWeight: FontWeight.w600,
//              increamentFontSize: 1,
//             ),
//             vSizedBox,
//             CustomShadowContainer(
//               horizontalPadding: 15,
//               verticalPadding: 15,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText.smallText('First name',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Last name',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Email',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Phone number',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText.smallText('Katharine',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('kmiao',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('kmiao1@gmail.com',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('+91 987 654 3210',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             vSizedBox2,
//             CustomText.bodyText2('Complete Address',
//               fontWeight: FontWeight.w600,
//               increamentFontSize: 1,
//             ),
//             vSizedBox,
//             CustomShadowContainer(
//               horizontalPadding: 15,
//               verticalPadding: 15,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText.smallText('Address',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Country',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('State',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('City',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Zip Code',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText.smallText('315, Pukhraj',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('India',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Madhya Pradesh',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('Indore',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         vSizedBox05,
//                         CustomText.smallText('452001',
//                           increamentFontSize: 1,
//                           fontWeight: FontWeight.w500,
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
