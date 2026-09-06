// import 'package:flutter/material.dart';
// import 'package:quadsu_app/pages/guide_module/student_profile_screen.dart';
// import 'package:quadsu_app/widget/app_specific/custom_drawer.dart';
// import 'package:quadsu_app/widget/custom_scaffold.dart';
// import '../../constants/global_data.dart';
// import '../../constants/my_colors.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../services/custom_navigation_services.dart';
// import '../../widget/app_specific/custom_shadow_container.dart';
// import '../../widget/custom_appbar.dart';
// import '../../widget/custom_image.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_text_field.dart';
//
// class StudentScreen extends StatefulWidget {
//   const StudentScreen({super.key});
//
//   @override
//   State<StudentScreen> createState() => _StudentScreenState();
// }
//
// class _StudentScreenState extends State<StudentScreen> {
//   TextEditingController searchController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//         appBar: CustomAppBar(
//           isBackIcon: false,
//           leadingWidth: 55,
//           leadImageUrl: MyImagesUrl.image02,
//           titleText: 'Students',
//           centerTitle: true,
//           isNotificationIcon: true,
//         ),
//         drawer: const CustomDrawer(),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             vSizedBox05,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 10),
//               child:  CustomTextField(
//                 controller: searchController,
//                 contentPaddingVertical: 0,
//                 contentPaddingHorizonatly: 10,
//                 borderRadius: 10,
//                 hintColor: MyColors.blackColor.withOpacity(0.4),
//                 hintTextFontSize: 14,
//                 fontSize: 14,
//                 height:46,
//                 borderColor: MyColors.transparent,
//                 showShadow: true,
//                 hintText: 'Search Student',
//                 fillColor: MyColors.whiteColor,
//                 prefix:Padding(
//                   padding: const EdgeInsets.all(14),
//                   child: Image.asset(MyImagesUrl.search_outline,
//                     color: const Color(0xFF979797),
//                     width: 18,height: 18,),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 20),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1/1,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing:10,
//                 ),
//                 itemCount: 18,
//                 itemBuilder: (context, index) {
//                   return  GestureDetector(
//                     onTap: (){
//                       CustomNavigation.push(context: context, screen: const StudentProfileScreen());
//                     },
//                     child: CustomShadowContainer(
//                       verticalPadding: 1,
//                       horizontalPadding: 4,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const CustomImage(
//                             imageUrl: MyImagesUrl.image04,
//                             height: 50,
//                             width: 50,
//                             isShowStackImage: true,
//                             fileType: CustomFileType.asset,
//                           ),
//                           vSizedBox02,
//                           CustomText.smallText(
//                             'Kasey B',
//                             textAlign: TextAlign.center,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           CustomText.smallText(
//                             'Chemistry',
//                             fontSize: 11,
//                             color: MyColors.blackColor40,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },),
//             )
//           ],
//         )
//     );
//   }
// }
