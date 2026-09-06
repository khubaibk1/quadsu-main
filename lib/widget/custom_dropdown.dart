import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/language_en.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/themes/custom_text_styles.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../constants/my_colors.dart';
import '../functions/print_function.dart';

// class CustomDropdownButton<T> extends StatelessWidget {
//   final String? text;
//   final bool isLabel;
//   final Color labelColor;
//   final List<T> items;
//    T? selectedItem;
//   final String hint;
//   final BoxBorder? border;
//   final void Function(T? value)? onChanged;
//   final double margin;
//   final double labelFontSize;
//   final String itemMapKey;
//   final Color fieldColor;
//   final Color bgColor;
//   final double borderRadius;
//   final CrossAxisAlignment crossAxisAlignment;
//   final String? Function(T?)? validator;
//    CustomDropdownButton({Key? key,
//     this.margin = 0,
//     this.labelFontSize = 15,
//     this.validator,
//      this.text,
//     this.selectedItem,
//     this.labelColor =Colors.black,
//     required this.items,
//     required this.hint,
//     this.onChanged,
//     this.border,
//      this.borderRadius = globalBorderRadius,
//     this.isLabel = true,
//     this.itemMapKey = 'name',
//     this.fieldColor=Colors.transparent,
//     this.bgColor=Colors.transparent,
//     this.crossAxisAlignment = CrossAxisAlignment.start
//
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: crossAxisAlignment,
//       children: [
//
//
//         if(text!=null)
//         Text(text!, style: TextStyle(fontSize: labelFontSize, color: labelColor, fontFamily: 'bold'),),
//         Container(
//           height: 60,
//           margin: EdgeInsets.symmetric(vertical: margin),
//           decoration: BoxDecoration(
//             color:bgColor,
//             borderRadius: BorderRadius.circular(borderRadius)
//           ),
//           child:  DropdownSearch<T>(
//             validator: validator,
//             selectedItem: selectedItem,
//             onChanged: onChanged,
//             items: items,
//             popupProps: PopupProps.modalBottomSheet(
//               fit: FlexFit.loose,
//               showSelectedItems: false,
//               title: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SubHeadingText('$hint',),
//               ),
//             ),
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 hintText: "$hint",
//                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//                 hintStyle: CustomTextStyle.textFieldHint,
//                 border:OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.blackColor50,width: 1.5),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   // borderSide: BorderSide(color: Colors.black),
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.blackColor50),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.primaryColor,width: 1.5),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.redColor,width: 1.5),
//                 ),
//               )
//
//             ),
//
//             dropdownButtonProps: DropdownButtonProps(
//
//             ),
//
//
//             dropdownBuilder:
//                 (context,value){
//               if(value==null){
//                 return Container(
//                   child: ParagraphText('$hint', color: MyColors.blackColor50,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,),
//                 );
//               }
//               try{
//                 return Text('${(value as Map)['${itemMapKey}']}');
//
//               }catch(e){
//                 myCustomPrintStatement('Error in catch block  5d55 $e');
//               }
//               return Container(
//                 decoration: BoxDecoration(
//
//                 ),
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(value.toString()+'sdfas'),
//                     // Divider(),
//                   ],
//                 ),
//               );
//
//
//             },
//             itemAsString: (T? value){
//               myCustomPrintStatement('this is called');
//               try{
//                 return ' ${(value as Map)['${itemMapKey}']}';
//               }catch(e){
//                 myCustomPrintStatement('Error in catch block  555 $e');
//               }
//               return '  ${value}';
//             },
//
//
//           ),
//         ),
//       ],
//     );
//   }
// }

class CustomDropdownButton<T> extends StatelessWidget {
  final String? headingText;
  final bool isLabel;
  final Color labelColor;
  final List<T> items;
  final List<T>? multipleSelectedItems;
  final T? singleSelectedItem;
  final String hint;
  final BoxBorder? border;
  final void Function(List<T>)? onChangedMultiple;
  final void Function(T?)? onChangedSingle;
  final double margin;
  final bool wantSearch;
  final double? headingFontSize;
  final FontWeight? headingFontWeight;
  final String itemMapKey;
  final String? selectedItemString;
  final Color fieldColor;
  final Color bgColor;
  final Color? hintColor;
  final double? hintTextFontSize;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizontal;
  final double borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final CrossAxisAlignment crossAxisAlignment;
  final String? Function(T?)? validatorSingle;
  final String? Function(List<T>?)? validatorMultiple;
  final bool isMultiSelect;

  const CustomDropdownButton({
    super.key,
    this.margin = 0,
    this.headingFontSize,
    this.headingFontWeight,
    this.validatorSingle,
    this.selectedItemString,
    this.validatorMultiple,
    this.headingText,
    this.multipleSelectedItems,
    this.singleSelectedItem,
    this.labelColor = Colors.black,
    required this.items,
    required this.hint,
    this.onChangedMultiple,
    this.onChangedSingle,
    this.border,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 10,
    this.isLabel = true,
    this.itemMapKey = 'title',
    this.fieldColor = Colors.transparent,
    this.hintColor ,
    this.hintTextFontSize ,
    this.contentPaddingVertical ,
    this.contentPaddingHorizontal ,
    this.bgColor = Colors.transparent,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.isMultiSelect = false,  this.wantSearch=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (headingText != null)
          CustomText.textFieldHeading(
            headingText!,
            fontSize: headingFontSize,
            color: labelColor,
            fontWeight: headingFontWeight,
          ),
        if (headingText != null)vSizedBox05,
        Container(
          margin: EdgeInsets.symmetric(vertical: margin),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: isMultiSelect
              ? DropdownSearch<T>.multiSelection(
                  validator: validatorMultiple,
                  selectedItems: multipleSelectedItems ?? [],
                  onChanged: (val) {
                    unFocusKeyBoard();
                    if (onChangedMultiple != null) {
                      onChangedMultiple!(val);
                    }
                  },
                  items: items,
                  compareFn: (item, selectedItem) {
                    return (item as Map)[itemMapKey] ==
                        (selectedItem as Map)[itemMapKey];
                  },
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    showSelectedItems: true,
                    fit: FlexFit.loose,
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomText.headingSmall(
                        hint,
                      ),
                    ),
                  ),
                  itemAsString: (T? value) {
                    myCustomPrintStatement('this is calledf');
                    try {
                      return ' ${(value as Map)[itemMapKey]}';
                    } catch (e) {
                      myCustomPrintStatement('Error in catch block  555 $e');
                    }

                    try {
                      return selectedItemString!;
                    } catch (e) {
                      myCustomPrintStatement(
                          'Error in catch block  the list do not have the full data $e');
                    }

                    return '  $value';
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: translate(hint),
                      fillColor: MyColors.fillColor,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      hintStyle: CustomTextStyle.textFieldHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor ??
                              MyColors.enabledTextFieldBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                            color: borderColor ??
                                MyColors.enabledTextFieldBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: focusedBorderColor ?? Colors.blue,
                        ),

                      ),
                    ),
                  ),
                )
              : DropdownSearch<T>(
                  validator: validatorSingle,
                  selectedItem: singleSelectedItem,
                  // onChanged: onChangedSingle,
                  onChanged: (val) {
                    unFocusKeyBoard();
                    if (onChangedSingle != null) {
                      onChangedSingle!(val);
                    }
                  },
                  compareFn: items.first.runtimeType != Map
                      ? (v, a) {
                          return false;
                        }
                      :
                      // !isMultiSelect?null:
                      (item, selectedItem) {
                          print('safsdfasf ${items.first.runtimeType}');
                          return (item as Map)[itemMapKey] ==
                              (selectedItem as Map)[itemMapKey];
                          // return selectedItemString==selectedItem.fullData
                        },

                  items: items,
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    fit: FlexFit.loose,
                    showSearchBox: wantSearch,
                    searchFieldProps: const TextFieldProps(


                    ),
                    title:wantSearch ?Padding(
                      padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 2),
                      child: CustomText.bodyText1(
                        hint.isNotEmpty?hint:"Search",
                        fontWeight: FontWeight.w600,
                      ),
                    ):null,
                  ),
                  itemAsString: (T? value) {
                    try {
                      return ' ${(value as Map)[itemMapKey]}';
                    } catch (e) {
                      myCustomPrintStatement('Error in catch block  555 $e');
                    }
                    try {
                      return (value as dynamic).fullData[itemMapKey]!;
                    } catch (e) {
                      myCustomPrintStatement(
                          'Error in catch block  the list do not have the full data $e');
                    }
                    return ' $value';
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: translate(hint),
                      fillColor: MyColors.fillColor,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: contentPaddingVertical ?? 15,
                        horizontal: contentPaddingHorizontal ?? 20,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      hintStyle: CustomTextStyle.textFieldHint.copyWith(
                        color: hintColor,
                        fontSize: hintTextFontSize,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor ??
                              MyColors.enabledTextFieldBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                            color: borderColor ??
                                MyColors.enabledTextFieldBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: focusedBorderColor ?? Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// class CustomDropdownButton<T> extends StatelessWidget {
//   final String? text;
//   final bool isLabel;
//   final Color labelColor;
//   final List<T> items;
//   final List<T>? selectedItems;
//   final String hint;
//   final BoxBorder? border;
//   final void Function(List<T>)? onChanged;
//   final double margin;
//   final double labelFontSize;
//   final String itemMapKey;
//   final Color fieldColor;
//   final Color bgColor;
//   final double borderRadius;
//   final CrossAxisAlignment crossAxisAlignment;
//   final String? Function(T?)? validator;
//
//   CustomDropdownButton({
//     Key? key,
//     this.margin = 0,
//     this.labelFontSize = 15,
//     this.validator,
//     this.text,
//     this.selectedItems,
//     this.labelColor = Colors.black,
//     required this.items,
//     required this.hint,
//     this.onChanged,
//     this.border,
//     this.borderRadius = globalBorderRadius,
//     this.isLabel = true,
//     this.itemMapKey = 'title',
//     this.fieldColor = Colors.transparent,
//     this.bgColor = Colors.transparent,
//     this.crossAxisAlignment = CrossAxisAlignment.start,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: crossAxisAlignment,
//       children: [
//         if (text != null)
//           CustomText.textFieldHeading(
//             text!,
//             fontSize: labelFontSize,
//             color: labelColor,
//           ),
//         Container(
//           margin: EdgeInsets.symmetric(vertical: margin),
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//           child: DropdownSearch<T>.multiSelection(
//             validator: validator,
//             selectedItems: selectedItems?? [],
//             onChanged: onChanged,
//             items: items,
//             compareFn: (item, selectedItem) {
//               return (item as Map)[itemMapKey] == (selectedItem as Map)[itemMapKey];
//             },
//             popupProps: PopupPropsMultiSelection.modalBottomSheet(
//               showSelectedItems: true,
//               fit: FlexFit.loose,
//
//               title: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: CustomText.headingSmall(hint,color: MyColors.blackColor,),
//               ),
//             ),
//             // dropdownBuilder: (context, value) {
//             //   // if (value == null || value.isEmpty) {
//             //   //   return Container(
//             //   //     child: ParagraphText(
//             //   //       '${hint}okokkk',
//             //   //       color: MyColors.blackColor50,
//             //   //       fontSize: 14,
//             //   //       fontWeight: FontWeight.w500,
//             //   //     ),
//             //   //   );
//             //   // }
//             //   try {
//             //     return Text(value.map((e) => (e as Map)[itemMapKey]).join(', '));
//             //   } catch (e) {
//             //     myCustomPrintStatement('Error in catch block  5d55 $e');
//             //   }
//             //   return Container(
//             //     decoration: BoxDecoration(),
//             //     padding: const EdgeInsets.all(8.0),
//             //     child: Column(
//             //       mainAxisSize: MainAxisSize.min,
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       children: [
//             //         Text(value.toString() + 'sdfas'),
//             //         // Divider(),
//             //       ],
//             //     ),
//             //   );
//             // },
//             itemAsString: (T? value) {
//               myCustomPrintStatement('this is calledf');
//               try {
//                 return ' ${(value as Map)[itemMapKey]}';
//               } catch (e) {
//                 myCustomPrintStatement('Error in catch block  555 $e');
//               }
//               return '  ${value}';
//             },
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 hintText: hint,
//                 fillColor: MyColors.fillColor,
//                 filled: true,
//                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//                 hintStyle: CustomTextStyle.textFieldHint,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.blackColor50, width: 1.5),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.blackColor50),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide(color: MyColors.redColor, width: 1.5),
//                 ),
//               ),
//             ),
//
//           ),
//         ),
//       ],
//     );
//   }
// }
