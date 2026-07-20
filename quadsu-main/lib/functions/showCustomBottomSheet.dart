
import 'package:flutter/material.dart';
import 'package:quadsu_app/functions/print_function.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double pageBreakpoint = 750.0;

Future showCustomBottomSheet(
    {required BuildContext context,
      required dynamic child,
      bool enableDrag = false,
      double paddingHorizontal = 20,}) async{


  SliverWoltModalSheetPage page1(
      BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      backgroundColor: Colors.white,
      enableDrag: enableDrag,
      hasTopBarLayer: false,
      child:Container(
        color: Colors.white,
        padding:  EdgeInsets.only(left: paddingHorizontal,right: paddingHorizontal,bottom: 20,top: 25),
        child: child,
      ),
    );
  }

  return await WoltModalSheet.show(context: context, pageListBuilder: (modalSheetContext){
    final textTheme = Theme.of(context).textTheme;
    return [
      page1(modalSheetContext, textTheme),

    ];
  },
    modalTypeBuilder: (context) {
      final size = MediaQuery.of(context).size.width;
      if (size < pageBreakpoint) {
        return WoltModalType.bottomSheet();
      } else {
        return WoltModalType.dialog();
      }
    },
    onModalDismissedWithBarrierTap: () {
      myCustomPrintStatement('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
    },
    // maxDialogWidth: 560,
    // minDialogWidth: 400,
    // minPageHeight: 0.0,
    // maxPageHeight: 0.9,
  );

}
