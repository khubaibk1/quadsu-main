// // ignore_for_file: avoid_print, depend_on_referenced_packages
//
// import 'dart:convert' as convert;
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../constants/global_data.dart';
// import '../functions/print_function.dart';
// import '../modal/response_modal.dart';
// import '../widget/show_snackbar.dart';
//
// ResponseModal failedResponseModal = ResponseModal(status: 0, message: 'Api Failed in catch', error: {"Api":"Api Failed in catch block"}, data: [], fullData: {});
//
// class NewWebServices {
//
//
//   static Future<ResponseModal<dynamic>> postData({
//     required String apiUrl,
//     required Map<String, dynamic> request,
//     bool showSuccessMessage  = false,
//     bool isGetMethod = false,
//     bool showErrorMessage = true,
//     Map<String, File>? files,
//   }) async {
//     print('rearlsjdfkl ${request}.......${selectedLanguageNotifier.value['key']}');
//     request['lang'] = selectedLanguageNotifier.value['key'];
//
//     Map<String,String> newHeaders = {};
//     newHeaders.addAll(globalHeaders);
//     if(userToken!=null){
//       newHeaders['Authorization'] = 'Bearer $userToken';
//       print('this is user token $userToken');
//     }
//     print('this is user $userToken');
//     try{
//       myCustomLogStatements('the request for $apiUrl with headers $newHeaders (post data)is $request');
//       late http.Response response;
//       if(isGetMethod){
//         String tempGetRequest = '?';
//         request.forEach((key, value) {
//           tempGetRequest +=key+'=' + value.toString() + '&';
//
//         });
//         tempGetRequest = tempGetRequest.substring(0,tempGetRequest.length-1);
//         myCustomPrintStatement('the url issss $apiUrl$tempGetRequest');
//
//         ///
//         response = await http.get(Uri.parse(apiUrl ), headers: newHeaders);
//         // response = await http.get(Uri.parse(apiUrl + tempGetRequest), headers: newHeaders);
//       }else{
//
//         ///
//         response = await http.post(Uri.parse(apiUrl), body: convert.jsonEncode(request), headers: newHeaders);
//       }
//       myCustomLogStatements('the response for $apiUrl with status code ${response.statusCode} is ${response.body}',showLog: false);
//       if (response.statusCode == 200) {
//         Map jsonResponse = convert.jsonDecode(response.body);
//         myCustomLogStatements('the response for $apiUrl is $jsonResponse');
//         var responseModal = ResponseModal.fromJson(jsonResponse);
//         if (jsonResponse['status'] == 1) {
//           if (showSuccessMessage) {
//             showSnackbar(jsonResponse['message']);
//           }
//           return responseModal;
//         } else {
//           if (showErrorMessage) {
//             try{
//               if(responseModal.error.isNotEmpty){
//                 String errorMessage = '';
//                 responseModal.error.forEach((key, value) {
//                   // errorMessage += '$key: ';
//                   (value as List).forEach((element) {
//                     errorMessage += '${element.toString()}\n';
//                   });
//                 });
//                 showSnackbar(errorMessage);
//               }else{
//                 showSnackbar(jsonResponse['message']);
//               }
//             }catch(e){
//               myCustomPrintStatement('Error in catch block 62365 $e');
//               showSnackbar(jsonResponse['message']);
//             }
//
//           }
//         }
//         return responseModal;
//       }else{
//         failedResponseModal.message = 'Internal Server Error ${response.statusCode}';
//         myCustomLogStatements('Api is failed  : ${response.statusCode}...${apiUrl}...${request}');
//         showSnackbar('Api is failed  : ${response.statusCode}...${apiUrl}...${request}');
//       }
//
//     }catch(e){
//       myCustomPrintStatement('Error in catch block post data 3372 $e');
//     }
//     return failedResponseModal;
//   }
//
//
//
//   static Future<List> postList({
//     required String apiUrl,
//     required Map<String, dynamic> request,
//     bool showSuccessMessage  = false,
//     bool isGetMethod = false,
//     bool showErrorMessage = true,
//   })async{
//     try{
//       request['lang'] = selectedLanguageNotifier.value['key'];
//       ResponseModal responseModal = await postData(apiUrl: apiUrl, request: request, showSuccessMessage: showSuccessMessage, isGetMethod: isGetMethod, showErrorMessage: showErrorMessage,);
//       return responseModal.data;
//     }catch(e){
//       myCustomPrintStatement('Error in catch block get list data 3374 $e');
//     }
//     return [];
//   }
//
//
//
//
//   static Future<ResponseModal<dynamic>> postDataWithImageFunction({
//     required Map<String, dynamic> body,
//     required Map<String, dynamic> files,
//     required String apiUrl,
//     bool successAlert = false,
//     bool errorAlert = true,
//   }) async {
//     // body['lang'] = selectedLanguageNotifier.value['key'];
//
//     Map<String, String> newHeaders = {};
//     newHeaders.addAll(globalHeaders);
//     if (userToken != null) {
//       newHeaders['Authorization'] = 'Bearer $userToken';
//     }
//     newHeaders['lang'] = selectedLanguageNotifier.value['key'];
//     myCustomPrintStatement(
//         'the request for url : $apiUrl is $body with headers $newHeaders');
//     myCustomPrintStatement('the file request is $files');
//
//     var url = Uri.parse(apiUrl);
//     //
//     myCustomLogStatements(apiUrl);
//     try {
//       var request = http.MultipartRequest("POST", url);
//       body.forEach((key, value) {
//         request.fields[key] = value;
//         // log(value2);
//       });
//       request.headers.addAll(newHeaders);
//
//       // if (files != null) {
//       //   (files).forEach((key, value) async {
//       //     request.files.add(await http.MultipartFile.fromPath(key, value.path));
//       //   });
//       // }
//       (files).forEach((key, value) async {
//         request.files.add(await http.MultipartFile.fromPath(key, value.path));
//       });
//
//       myCustomLogStatements(request.fields.toString());
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       myCustomLogStatements(response.body);
//       var jsonResponse = convert.jsonDecode(response.body);
//       var responseModal = ResponseModal.fromJson(jsonResponse);
//       if (jsonResponse['status'].toString() == '1') {
//         if (successAlert) {
//           showSnackbar(jsonResponse['message']);
//         }
//       } else {
//         if (errorAlert) {
//           try {
//             if (responseModal.error.isNotEmpty) {
//               String errorMessage = '';
//               responseModal.error.forEach((key, value) {
//                 // errorMessage += '$key: ';
//                 (value as List).forEach((element) {
//                   errorMessage += '${element.toString()}\n';
//                 });
//               });
//               showSnackbar(errorMessage);
//             } else {
//               showSnackbar(jsonResponse['message']);
//             }
//           } catch (e) {
//             myCustomPrintStatement('Error in catch block 62365 $e');
//             showSnackbar(jsonResponse['message']);
//           }
//         }
//       }
//       return responseModal;
//       // return response;
//     } catch (e) {
//       myCustomPrintStatement(e);
//       try {
//         var response = await http.post(url, body: body, headers: newHeaders);
//         if (response.statusCode == 200) {
//           var jsonResponse = convert.jsonDecode(response.body);
//           var responseModal = ResponseModal.fromJson(jsonResponse);
//           return responseModal;
//         }
//       } catch (error) {
//         myCustomPrintStatement('inside double catch block $error');
//         return failedResponseModal;
//       }
//       return failedResponseModal;
//       // return null;
//     }
//   }
//
//   /// Commented by dipanshu
//   // static Future<Map<String, dynamic>> postDataWithImageFunction({
//   //   required Map<String, dynamic> body,
//   //   required Map<String, dynamic> files,
//   //   required BuildContext context,
//   //
//   //   /// endpoint of the api
//   //   required String apiUrl,
//   //   bool successAlert = false,
//   //   bool errorAlert = true,
//   // }) async {
//   //   // body['lang'] = selectedLanguage.value['key'];
//   //   print('the request is $body');
//   //
//   //   var url = Uri.parse(apiUrl);
//   //   //
//   //   log(apiUrl);
//   //   try {
//   //     var request = http.MultipartRequest("POST", url);
//   //     body.forEach((key, value) {
//   //       request.fields[key] = value;
//   //       // log(value2);
//   //     });
//   //
//   //     // if (files != null) {
//   //     //   (files).forEach((key, value) async {
//   //     //     request.files.add(await http.MultipartFile.fromPath(key, value.path));
//   //     //   });
//   //     // }
//   //     (files).forEach((key, value) async {
//   //       request.files.add(await http.MultipartFile.fromPath(key, value.path));
//   //     });
//   //
//   //     log(request.fields.toString());
//   //     final streamedResponse = await request.send();
//   //     final response = await http.Response.fromStream(streamedResponse);
//   //     log(response.body);
//   //     var jsonResponse = convert.jsonDecode(response.body);
//   //
//   //     if (jsonResponse['status'].toString() == '1') {
//   //       if (successAlert) {
//   //         // showSnackbar(jsonResponse['message']);
//   //         await showCommonAlertDailog(MyGlobalKeys.navigatorKey.currentContext!,
//   //             headingText: jsonResponse['message']);
//   //       }
//   //     } else {
//   //       if (errorAlert) {
//   //         // showSnackbar(jsonResponse['message']);
//   //         await showCommonAlertDailog(MyGlobalKeys.navigatorKey.currentContext!,
//   //             headingText: jsonResponse['message'], successIcon: false);
//   //       }
//   //     }
//   //     return jsonResponse;
//   //     // return response;
//   //   } catch (e) {
//   //     print(e);
//   //     try {
//   //       var response = await http.post(url, body: body, headers: globalHeaders);
//   //       if (response.statusCode == 200) {
//   //         var jsonResponse = convert.jsonDecode(response.body);
//   //         return jsonResponse;
//   //       }
//   //     } catch (error) {
//   //       print('inside double catch block $error');
//   //     }
//   //     return {'status': 0, 'message': "fail"};
//   //     // return null;
//   //   }
//   // }
//
//
// }
