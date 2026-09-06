// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../constants/my_colors.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;
  const CustomLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? MyColors.primaryColor,
      ),
    );
    // return Center(
    //   child: Container(
    //     alignment: Alignment.center,
    //     height: 100,
    //     width: 100,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(15),
    //       color: MyColors.blackColor.withOpacity(0.6),
    //     ),
    //     child: cupertino.CupertinoActivityIndicator(
    //       color: color ?? MyColors.whiteColor,
    //     ),
    //   ),
    // );
    // return cupertino.CupertinoActivityIndicator
  }
}

// void loadingHide(context) {
//   // Navigator.pop(dialogContext,true);
//   Navigator.of(context, rootNavigator: true).pop();
// }
//
// Future<dynamic> loadingShow(context) {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           insetPadding: const EdgeInsets.all(10),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: WillPopScope(
//             onWillPop: () async {
//               return false;
//             },
//             child: loadingWidget(context),
//           ));
//     },
//   ).then((exit) {
//     if (exit == null) return;
//   });
// }
//
// Widget loadingWidget(context) {
//   return Stack(clipBehavior: Clip.none, children: [
//     SizedBox(
//         width: double.infinity,
//         // height: 200,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: ListView(
//             shrinkWrap: true,
//             children: <Widget>[
//               Row(
//                 children: [
//                   Container(
//                     clipBehavior: Clip.none,
//                     width: (MediaQuery.of(context).size.width - 70),
//                     // padding:EdgeInsets.fromLTRB(0, 0, 20, 0),
//                     child: const SpinKitFadingCircle(
//                       color: MyColors.primaryColor,
//                       size: 50.0,
//                       // controller: ,
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         )),
//   ]);
// }
