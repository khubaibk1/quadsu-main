import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../constants/global_keys.dart';

showSnackbar(String text,{int? seconds, BuildContext? context}){
  final activeContext = context ?? MyGlobalKeys.navigatorKey.currentContext;
  if (activeContext != null) {
    try {
      ScaffoldMessenger.of(activeContext).showSnackBar(
          SnackBar(content: Text(text),
            duration: Duration(seconds:seconds??2),
          )
      );
      return;
    } catch (e) {
      print('🟡 [showSnackbar] ScaffoldMessenger failed: $e');
    }
  }
  
  // Fallback to EasyLoading if no active context is available
  try {
    EasyLoading.showToast(text);
  } catch (e) {
    print('🔴 [showSnackbar] EasyLoading fallback failed: $e');
  }
}