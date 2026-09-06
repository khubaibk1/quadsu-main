import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class CustomShadowContainer extends StatelessWidget {
  dynamic child;
  double? horizontalPadding;
  double? verticalPadding;
  Color? color;
  double? height;
  double? width;
  bool wantWidth;
   CustomShadowContainer({super.key,required this.child, this.verticalPadding, this.horizontalPadding,this.color,this.height,this.width,this.wantWidth=true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: wantWidth?width??double.infinity:null,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding??12, vertical:verticalPadding?? 12),
      decoration: BoxDecoration(
          color:color?? MyColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue,width: 0.8),
          boxShadow: [
            BoxShadow(
                color: MyColors.blackColor.withOpacity(0.06),
                blurRadius: 7)
          ]),
      child: child
    );
  }
}
