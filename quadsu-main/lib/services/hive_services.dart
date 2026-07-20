//
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import '../functions/print_function.dart';
// import 'package:http/http.dart' as http;
//
// String globalFilesPath = '';
//
// class HS {
//
//   static const databaseName = 'sidelick_app';
//   // static const issuesBoxString = 'issuesBoxTemp';
//   static const chatFilesBoxName = 'chatFiles';
//   // static const hiddenFilesBoxName = 'HiddenFiles';
//   static Box chatFilesBox = Hive.box(chatFilesBoxName);
//   // static Box hiddenFilesBox = Hive.box('HiddenFiles');
//
//   static Future initializeAllBoxes() async {
//
//     if(Platform.isIOS || Platform.isMacOS){
//       final directory = await getApplicationDocumentsDirectory();
//       globalFilesPath = directory.path;
//     }else{
//       final directory = await getTemporaryDirectory();
//       globalFilesPath = directory.path;
//     }
//     // final directory = await getLibraryDirectory();
//     myCustomPrintStatement('the path is ${globalFilesPath}');
//
//     Hive.init(globalFilesPath);
//     await BoxCollection.open(databaseName, {chatFilesBoxName}, path: globalFilesPath);
//     chatFilesBox= await Hive.openBox(chatFilesBoxName);
//     // await Hive.openBox(hiddenFilesBoxName);
//   }
//
//
//
//   static  insertBodyBytes(String url,int messageId)async{
//
//     print('Successfully saving ...in progress ${messageId}');
//
//     var data = HS.chatFilesBox.get(messageId);
//     if(data==null){
//       final response = await http.get(Uri.parse(url));
//       final bytes = response.bodyBytes;
//       print('Successfully saving ...bytes fetched ${messageId}');
//       await HS.chatFilesBox.put(messageId, bytes);
//       print('Successfully saved ${messageId}');
//     }
//     // GPXFileModal gpxFileModal = GPXFileModal(bodyBytes: data, fileName: fileName, body: body);
//     //   HiveServices.gpxFileDataBox.put(fileName, gpxFileModal.toJson());
//     //   return gpxFileModal;
//
//   }
//
//   static getFile(int messageId){
//     return HS.chatFilesBox.get(messageId);
//   }
//
//
// }
//
// class HK{
//   static const String boxChat = 'chatBox';
//
// }