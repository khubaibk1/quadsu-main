import 'package:flutter/services.dart';

void copyToClipboard({required String text}) {
  Clipboard.setData(ClipboardData(text: text));
  //showSnackbar("Copied to clipboard");

}