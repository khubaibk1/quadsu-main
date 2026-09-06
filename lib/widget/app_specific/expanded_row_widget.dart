

import 'package:flutter/material.dart';
import '../../constants/sized_box.dart';
import '../custom_text.dart';

class ExpandedRowWidget extends StatelessWidget {
  String title;
  String subTitle;
  double? vertical;
  FontWeight? fontWeight;
   ExpandedRowWidget({super.key,required this.title, required this.subTitle,this.vertical, this.fontWeight});

  @override
  Widget build(BuildContext context) {
      return  Padding(
        padding:  EdgeInsets.symmetric(vertical:vertical?? 6),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomText.bodyText2(
                title,
                fontWeight: fontWeight,
              ),
            ),
            vSizedBox02,
            Expanded(
              flex: 4,
              child: CustomText.bodyText2(
                subTitle,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      );
  }
}
