import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/modal/user_modal.dart';

class StudentGuideModel {

  List<UserModal> studentGuides = [];

  StudentGuideModel({this.studentGuides = const []});

  factory StudentGuideModel.fromJson(Map json)
  {
    List<UserModal> data=[];
    if (json['data'] != null) {
      data = <UserModal>[];

      json['data'].forEach((v) {
        data.add(UserModal.fromJson(v));
      });
    }

    return StudentGuideModel(
        studentGuides:data
    );
  }


}

class StudentGuides {
  Guide? guide;
  GuidePrefrence? guidePrefrence;
  Guide? student;
  StudentPrefrence? studentPrefrence;

  StudentGuides(
      {this.guide, this.guidePrefrence, this.student, this.studentPrefrence});

  factory StudentGuides.fromJson(Map<String,dynamic>  json) {
    print("datdatdta:::::$json");
    return StudentGuides(
      guide: usertype == UserType.student ? Guide.fromJson(json['guide_data']) : null,
      guidePrefrence: json['guide_prefrence'] != null
          ? GuidePrefrence.fromJson(json['guide_prefrence'])
          : (json['tutor_preferences'] != null
              ? GuidePrefrence.fromJson(json['tutor_preferences'])
              : (json['guide_preferences'] != null
                  ? GuidePrefrence.fromJson(json['guide_preferences'])
                  : null)),
      student: usertype == UserType.guide ? Guide.fromJson(json['student_data']) : null,
      studentPrefrence: json['student_prefrence'] != null
          ? StudentPrefrence.fromJson(json['student_prefrence'])
          : (json['student_preferences'] != null
              ? StudentPrefrence.fromJson(json['student_preferences'])
              : null),
    );
  }
}
