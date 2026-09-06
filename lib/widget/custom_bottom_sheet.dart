import 'package:flutter/material.dart';
import '../constants/global_data.dart';
import '../constants/my_colors.dart';

Future<void> customBottomSheet(context,
    {isHorizontalPadding = false, required child}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    useSafeArea: true,
    backgroundColor: MyColors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: EdgeInsets.symmetric(
                horizontal: isHorizontalPadding ? 0 : globalHorizontalPadding,
                vertical: isHorizontalPadding ? 0 : 20),
            child: child),
      );
    },
  );
}
