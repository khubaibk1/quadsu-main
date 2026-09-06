import 'dart:ui';

import '../my_colors.dart';

class InstantBookingStatus {
  static const int pending = 0;
  static const int accepted = 1;
  static const int rejected = 2;
  static const int booked = 3;
  static const int completed = 4;

  static const int canceled = 5;

  static String getName(int status, {int? secsLeft}) {
    switch (status) {
      case InstantBookingStatus.pending:
        return 'Pending';
      case InstantBookingStatus.accepted:
        return 'Accepted';
      case InstantBookingStatus.rejected:
        return 'Rejected';
      case InstantBookingStatus.canceled:
        return 'Canceled';
      case InstantBookingStatus.booked:
        return 'Booked';
      case InstantBookingStatus.completed:
        return 'Completed';
      default:
        return 'Pending';
    }
  }

  static Color getColor(int status, {int? secsLeft}) {
    print("gyhsxghxgh:::$status");
    switch (status) {
      case InstantBookingStatus.pending:
        return MyColors.yellowColor;
      case InstantBookingStatus.accepted:
        return MyColors.greenColor;
      case InstantBookingStatus.rejected:
        return MyColors.redColor;
      case InstantBookingStatus.canceled:
        return MyColors.redColor;
      case InstantBookingStatus.booked:
        return MyColors.primaryColor;
      case InstantBookingStatus.completed:
        return MyColors.greenColor;
      default:
        return MyColors.yellowColor;
    }
  }
}
