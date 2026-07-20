import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import '../constants/my_colors.dart';
import '../constants/sized_box.dart';
import 'custom_loader.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final Color color;
  final Color? borderColor;
  final String text;
  final String? fontFamily;
  final Function()? onTap;
  final double horizontalMargin;
  final double verticalPadding;
  final double horizontalPadding;
  final double verticalMargin;
  final bool isSolid;
  final bool isBorder;
  final Color? textColor;
  final double? borderRadius;
  final TextAlign textAlign;
  final double? fontSize;
  final double? width;
  final bool showGradient;
  final bool showShadow;
  final FontWeight? fontWeight;
  final bool load;
  final bool isFlexible;
  final bool enabled;
  final Widget? suffix;
  final Widget? prefix;

  const CustomButton(
      {super.key,
      this.color = MyColors.primaryColor,
      this.enabled = true,
      this.borderColor,
      required this.text,
      this.isFlexible = false,
      this.onTap,
      this.horizontalPadding = 10,
      this.horizontalMargin = 0,
      this.borderRadius = 10,
      this.isBorder = false,
      this.verticalMargin = 12,
      this.verticalPadding = 10,
      this.width,
      this.showGradient = false,
      this.showShadow = false,
      this.height,
      this.textColor,
      this.fontWeight,
      this.fontSize,
      this.textAlign = TextAlign.center,
      this.fontFamily,
      this.load = false,
      this.suffix,
      this.prefix,
      this.isSolid = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (load || !enabled) ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
          height: height,
          margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin, vertical: verticalMargin),
          width: isFlexible ? null : width ?? (MediaQuery.of(context).size.width),
          constraints: BoxConstraints(
            maxWidth: (MediaQuery.of(context).size.width),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: enabled == false
                ? Colors.grey
                : isSolid
                    ? color
                    : Colors.transparent,
            gradient: showGradient
                ? const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xfff02321),
                      Color(0xff781211),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(borderRadius!),
            border: isBorder
                ? Border.all(color: borderColor ?? color)
                : isSolid
                    ? null
                    : Border.all(color: borderColor ?? color),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                        color: MyColors.blackColor.withOpacity(0.2),
                        blurRadius: 10)
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: textAlign == TextAlign.start
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (prefix != null) prefix!,
              if (prefix != null) hSizedBox02,
              Flexible(
                  child: CustomText.buttonText(
                text,
                textAlign: textAlign,
                color: textColor ?? (isSolid ? Colors.white : color),
                fontSize: fontSize,
                fontWeight: fontWeight,
              )),
              if (suffix != null) hSizedBox02,
              if (suffix != null) suffix!,
              if (load)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomLoader(
                    color: textColor ?? (isSolid ? Colors.white : color),
                  ),
                )
            ],
          )),
    );
  }
}
