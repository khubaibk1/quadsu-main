// import 'package:flutter/material.dart';
// import 'package:quadsu_app/constants/my_colors.dart';
//
// class BookingStatus {
//   static const int pending = 0;
//   static const int accepted = 1;
//   static const int rejected = 2;
//   static const int booked = 3;
//   static const int cancelled = 4;
//   static const int completed = 5;
//
//   static String getName(int status, {int? secsLeft}) {
//     switch (status) {
//       case BookingStatus.pending:
//         return 'Running';
//       case BookingStatus.accepted:
//         return 'Accepted';
//       case BookingStatus.rejected:
//         return 'Rejected';
//       case BookingStatus.booked:
//         return 'Booked';
//       case BookingStatus.cancelled:
//         return 'Cancelled';
//       case BookingStatus.completed:
//         return 'Completed';
//       default:
//         return 'Pending';
//     }
//   }
//
//   static Color getColor(int status, {int? secsLeft}) {
//     switch (status) {
//       case BookingStatus.pending:
//         return MyColors.primaryColor;
//       case BookingStatus.accepted:
//         return MyColors.greenColor;
//       case BookingStatus.rejected:
//         return MyColors.redColor;
//       case BookingStatus.cancelled:
//         return MyColors.redColor;
//       case BookingStatus.completed:
//         return MyColors.greenColor;
//       default:
//         return MyColors.yellowColor;
//     }
//   }
//
//   static getBgColor(int status) {
//     return getColor(status).computeLuminance() > 0.5
//         ? MyColors.blackColor
//         : MyColors.whiteColor;
//   }
// }
