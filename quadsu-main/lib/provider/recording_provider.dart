
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/modal/recording_model.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

import '../constants/api_keys.dart';

class RecordingProvider extends ChangeNotifier
{



  Future<String> getRecordingUrl(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getRecordingUrl,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: false,
    );

    print("request Instant Booking :::::::::::::${jsonResponse.status}");
    EasyLoading.dismiss();

    if (jsonResponse.status == 1) {
      return jsonResponse.data['url']!= null ?jsonResponse.data['url'].toString():"";
     // CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
    }
    else
      {
        return "";
      }

  }






  bool recordingRefresh = false;
  int recordingOffset = 1;
  bool recordingLoad = false;
  bool isLastData = false;
  List<Recording> recording = [];
  RecordingModel? recordingModel;




  Future<void> getSessionsRecordings({required int bookingId}) async {
    recordingLoad = true;

    if (recordingOffset == 1 &&
        recordingRefresh == false) {
      EasyLoading.show();
    }

    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getSessionRecordings,

      request: {
        ApiKeys.page: recordingOffset,
        ApiKeys.bookingId: bookingId,
      },

      apiMethod: ApiMethod.post,
    );

    if (jsonResponse.status == 1) {
      print("student guide :::::::::::::${jsonResponse.data}");

      if (recordingOffset == 1) {
        isLastData = false;
        notifyListeners();
        recordingModel = RecordingModel.fromJson(jsonResponse.data);
        recording = List.from(recordingModel?.recordings ?? []);
      } else {
        recordingModel = RecordingModel.fromJson(jsonResponse.data);
        if (recordingModel?.recordings.isNotEmpty == true) {
          recording =
              recording + List.from(recordingModel?.recordings ?? []);
          isLastData = false;
          notifyListeners();
        } else {
          isLastData = true;
        }
      }
    }

    EasyLoading.dismiss();
    recordingLoad = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void reset() {
    recordingRefresh = false;

    recordingOffset = 1;

    recordingLoad = false;

    isLastData = false;

    recording = [];
    recordingModel=null;
  }

}