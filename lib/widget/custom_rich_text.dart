import 'package:quadsu_app/themes/custom_text_styles.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomRichText extends StatelessWidget {
  String firstText;
  String secondText;
  String? thirdText;
  String? forthText;
  double? firstTextFontSize;
  double? secondTextFontSize;
  double? thirdTextFontSize;
  double? height;
  Color? firstTextColor;
  Color? secondTextColor;
  Color? thirdTextColor;
  FontWeight? firstTextFontWeight;
  String? firstTextFontFamily;
  String? secondTextFontFamily;
  String? thirdTextFontFamily;
  FontWeight? secondTextFontWeight;
  FontWeight? thirdTextFontWeight;
  TextDecoration? firstTextDecoration;
  TextDecoration? secondTextDecoration;
  TextDecoration? thirdTextDecoration;
  TextAlign? textAlign;

  CustomRichText({
    super.key,
    required this.firstText,
    required this.secondText,
    this.thirdText = '',
    this.forthText,
    this.textAlign,
    this.height,
    this.firstTextFontSize,
    this.secondTextFontSize,
    this.thirdTextFontSize,
    this.firstTextColor,
    this.secondTextColor,
    this.thirdTextColor,
    this.firstTextFontWeight,
    this.secondTextFontWeight,
    this.thirdTextFontWeight,
    this.firstTextDecoration,
    this.secondTextDecoration,
    this.thirdTextDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign:textAlign?? TextAlign.start,
      text: TextSpan(
        text: firstText,
        style: CustomTextStyle.richTextStyle.copyWith(
            fontSize: firstTextFontSize,
            color: firstTextColor,
            fontWeight: firstTextFontWeight,
            decoration: firstTextDecoration),
        children: <TextSpan>[
          TextSpan(
            text: secondText,
            style: CustomTextStyle.richTextStyle.copyWith(
                fontSize: secondTextFontSize,
                color: secondTextColor,
                fontWeight: secondTextFontWeight,
                decoration: secondTextDecoration),
          ),
          TextSpan(
            text: thirdText,
            style: CustomTextStyle.richTextStyle.copyWith(
                fontSize: thirdTextFontSize,
                color: thirdTextColor,
                fontWeight: thirdTextFontWeight,
                decoration: thirdTextDecoration),
          ),
          TextSpan(
            text: forthText,
            style: CustomTextStyle.richTextStyle.copyWith(
                fontSize: secondTextFontSize,
                color: secondTextColor,
                fontWeight: secondTextFontWeight,
                decoration: secondTextDecoration),
          ),
        ],
      ),
    );
  }
}
