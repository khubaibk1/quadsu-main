import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';

import '../services/api_urls.dart';
import '../services/newest_webservices.dart';

class DashBoardProvider extends ChangeNotifier{
  bool                      homePageLoading=false;
  StudentDashboard?        studentDashboard;
  List<ScheduledSessions>      scheduledSessions=[];
  List<Guide>               guide=[];
  List<Category>           category=[];
  Map<String,dynamic>            categoryCount={};

  Future<void> getStudentDashBoard({bool showLoader=true}) async {
    homePageLoading=true;
    if(showLoader)
      {
        EasyLoading.show();
      }
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: userDataNotifier.value != null?usertype==UserType.guide?ApiUrls.homePageGuide:ApiUrls.homePageStudent:ApiUrls.homeData,
      request: {},
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");
      studentDashboard=StudentDashboard.fromJson(jsonResponse.data);
      scheduledSessions=studentDashboard?.scheduledSessions??[];
      guide=studentDashboard?.guide??[];
      category=studentDashboard?.category??[];
      categoryCount=studentDashboard?.categoryCount??{};
      print("datdadtadatadtadtadtadtadtadta:::::::::::::$categoryCount");
    }

    EasyLoading.dismiss();
    homePageLoading=false;
    notifyListeners();
  }

  bool guideLoading=false;


  Future<Guide?> getGuideProfile({required int guideId}) async {
    guideLoading=true;
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: '${ApiUrls.getGuideProfile}/$guideId',
      request: {},
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {

      EasyLoading.dismiss();
      guideLoading=false;
      notifyListeners();
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");
      return Guide.fromJson(jsonResponse.data['guide_data']);

    }
    else
    {EasyLoading.dismiss();
    guideLoading=false;
    notifyListeners();
    return null;
    }


  }



  bool studentLoading=false;


  Future<Guide?> getStudentProfile({required int studentId}) async {
    studentLoading=true;
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getStudentProfile,
      request: {
        ApiKeys.user_id:studentId
      },
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      EasyLoading.dismiss();
      studentLoading=false;
      notifyListeners();
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");
      return Guide.fromJson(jsonResponse.data);

    }
    else
    {

      EasyLoading.dismiss();
    studentLoading=false;
    notifyListeners();
    return null;
    }
  }


  void reset()
  {
    studentLoading=false;
    guideLoading=false;
    homePageLoading=false;
    studentDashboard=null;
    scheduledSessions=[];
    guide=[];
    category=[];
    categoryCount={};
  }



}