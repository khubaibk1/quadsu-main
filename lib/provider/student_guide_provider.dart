import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/student_guide_model.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

import '../modal/user_modal.dart';

class StudentGuideProvider extends ChangeNotifier {
  bool studentGuideSessionsRefresh = false;
  int studentGuideSessionsOffset = 1;
  bool studentGuideLoad = false;
  bool isLastData = false;
  List<UserModal> studentGuides = [];
  StudentGuideModel? studentGuideModel;

  Future<void> getStudentGuide() async {
    studentGuideLoad = true;

    if (studentGuideSessionsOffset == 1 &&
        studentGuideSessionsRefresh == false) {
      EasyLoading.show();
    }

    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: usertype == UserType.student
          ? ApiUrls.getMyGuides
          : ApiUrls.getMyStudents,
      request: {
        ApiKeys.page: studentGuideSessionsOffset,
      },
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("student guide  :::::::::::::${jsonResponse.data}");

      if (studentGuideSessionsOffset == 1) {
        isLastData = false;
        notifyListeners();
        studentGuideModel = StudentGuideModel.fromJson(jsonResponse.data);
        studentGuides = List.from(studentGuideModel?.studentGuides ?? []);
      } else {
        studentGuideModel = StudentGuideModel.fromJson(jsonResponse.data);
        if (studentGuideModel?.studentGuides.isNotEmpty == true) {
          studentGuides =
              studentGuides + List.from(studentGuideModel?.studentGuides ?? []);
          isLastData = false;
          notifyListeners();
        } else {
          isLastData = true;
        }
      }
    }

    EasyLoading.dismiss();
    studentGuideLoad = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void reset() {
    studentGuideSessionsRefresh = false;

    studentGuideSessionsOffset = 1;

    studentGuideLoad = false;

    isLastData = false;

    studentGuides = [];
    studentGuideModel=null;
  }

}
