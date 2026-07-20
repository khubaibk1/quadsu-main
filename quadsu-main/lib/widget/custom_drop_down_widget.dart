// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/language_en.dart';
import '../constants/my_colors.dart';
import '../themes/custom_text_styles.dart';
import 'custom_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class NewCustomDropDownField extends StatelessWidget {
  final Function()? onTap;
  final SingleValueDropDownController controller;
  final List<DropDownValueModel> itemsList;
  final double? width;
  final double? height;
  final bool isCollapsed;
  final Color? focusedBorderColor;
  final BoxBorder? border;
  final double horizontalPadding;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Color? bgColor;
  final Color? fillColor;
  final Color? borderColor;
  final String hintText;
  final TextAlign textAlign;
  final Color? textColor;
  final String? headingText;
  final double? headingFontSize;
  final FontWeight? headingFontWeight;
  final double borderRadius;
  final double? fontSize;
  final double? hintTextFontSize;
  final Color? hintColor;
  final double verticalPadding;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizonatly;
  final double? cursorHeight;
  final String? suffixText;
  final Widget? suffix;
  final Widget? prefix;
  final String? prefixText;
  TextInputType? keyboardType;
  final bool filled;
  final bool enabled;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final bool? autofocus;
  final bool? showShadow;
  final FocusNode? focusNode;
  final Function(dynamic)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? headingColor;

  NewCustomDropDownField({
    super.key,
    required this.controller,
    required this.itemsList,
    required this.hintText,
    this.width,
    this.height,
    this.isCollapsed = false,
    this.border,
    this.inputFormatters,
    this.contentPaddingHorizonatly,
    this.maxLines,
    this.validator,
    this.maxLength,
    this.onSaved,
    this.fontSize,
    this.textColor,
    this.hintTextFontSize,
    this.headingFontSize,
    this.headingText,
    this.headingFontWeight,
    this.cursorHeight,
    this.autofocus = false,
    this.readOnly = false,
    this.prefix,
    this.filled = true,
    this.contentPaddingVertical,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.obscureText = false,
    this.fillColor ,
    this.bgColor,
    this.hintColor,
    this.borderRadius = 10,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
    this.suffix,
    this.suffixText,
    this.focusedBorderColor,
    this.prefixText,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.textAlign = TextAlign.left,
    this.showShadow = false,
    this.headingColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (headingText != null)
            CustomText.textFieldHeading(
              headingText!,
              color: headingColor ?? MyColors.blackColor,
              fontSize: headingFontSize,
              fontWeight: headingFontWeight,
            ),
          if (headingText != null) const SizedBox(height: 8),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              if (showShadow!)
                Container(
                  height: height ?? 50,
                  margin: const EdgeInsets.only(top: 2),
                  width: width ?? MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  decoration: BoxDecoration(
                      color: bgColor,
                      border: border,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                            color: MyColors.blackColor.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 0)
                      ]),
                ),
              DropDownTextField(
                controller: controller,
                textStyle: CustomTextStyle.textFieldText.copyWith(
                  color: enabled ? textColor : hintColor,
                  fontSize: fontSize,
                ),
                clearOption: false,
                enableSearch: false,
                onChanged: onChanged,
                listPadding: ListPadding(top: 11,bottom: 1),
                validator: validator,
                dropDownItemCount: itemsList.length>6?6:itemsList.length,
                dropDownList: itemsList,
                dropdownRadius: borderRadius,

                dropDownIconProperty: IconProperty(
                  icon: Icons.keyboard_arrow_down_outlined,
                  color: Colors.grey.withOpacity(0.6),
                ),
                textFieldDecoration:InputDecoration(
                  enabled: enabled,
                  isDense: true,
                  counterText: '',
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: filled,
                  fillColor: fillColor ?? MyColors.fillColor,
                  suffixIcon: suffix,
                  suffixIconConstraints: const BoxConstraints(
                      maxHeight: 40,
                      minHeight: 20,
                    minWidth: 35
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    maxHeight: 55,
                    // minHeight: 10
                  ),
                  prefixIcon: prefix,
                  hintText: translate(hintText),
                  suffixText: translate(suffixText ?? ''),
                  prefixText: translate(prefixText ?? ''),
                  suffixStyle: const TextStyle(fontSize: 16),
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: contentPaddingVertical ?? 15,
                    horizontal: contentPaddingHorizonatly ?? 20,
                  ),
                  hintStyle: CustomTextStyle.textFieldHint.copyWith(
                    color: hintColor,
                    fontSize: hintTextFontSize,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: borderColor ??
                            MyColors.enabledTextFieldBorderColor),
                    borderRadius: BorderRadius.circular(
                        borderRadius), // Set the border radius here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: borderColor ??
                            MyColors.enabledTextFieldBorderColor),
                    borderRadius: BorderRadius.circular(
                        borderRadius), // Set the border radius here
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: borderColor ??
                            MyColors.disabledTextFieldBorderColor),
                    borderRadius: BorderRadius.circular(
                        borderRadius), // Set the border radius here
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: focusedBorderColor ?? Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(
                        borderRadius), // Set the border radius here
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: focusedBorderColor ?? Colors.blue),
                    borderRadius: BorderRadius.circular(
                        borderRadius), // Set the border radius here
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
