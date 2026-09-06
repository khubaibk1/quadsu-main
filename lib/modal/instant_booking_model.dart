import 'package:quadsu_app/constants/types/instant_booking_status.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/modal/user_modal.dart';

class InstantBookingModel{
  List<InstantBooking> instantBookings=[];
  InstantBookingModel({this.instantBookings=const[]});

  factory InstantBookingModel.fromJson(dynamic json)
  {
  //  Map<String,dynamic>  data={'data':json};

    List<InstantBooking> bookings=[];
    if (json['data'] != null) {
      bookings = <InstantBooking>[];

      json['data'].forEach((v) {
        bookings.add(InstantBooking.fromJson(v));
      });
    }

    return InstantBookingModel(instantBookings:bookings );
  }


}


class InstantBooking {
  int id;
  int studentId;
  int guideId;
  String description;
  int status;
  String date;
  String startTime;
  String endTime;
  String statusRemark;
  String bookingId;
  String createdAt;
  String updatedAt;
  String hourlyRate;
  Guide? guideData;
  GuidePrefrence? guidePreference;
  Guide? student;
  StudentPrefrence? studentPrefrence;
  String sessionDatetime;
  String statusText;
  String remark;
  int payBtn;

  InstantBooking({
    required this.id,
    required this.studentId,
    required this.guideId,
    required this.description,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.statusRemark,
    required this.bookingId,
    required this.createdAt,
    required this.updatedAt,
    required this.hourlyRate,
    this.guideData,
    this.guidePreference,this.student,
    this.studentPrefrence,
    required this.sessionDatetime,
    required this.statusText,
    required this.remark,
    required this.payBtn,
  });

  factory InstantBooking.fromJson(Map<String, dynamic> json) {
    int v;
    if(json['status_text'].toString()=="Cancelled")
      {
        v=InstantBookingStatus.canceled;
      }
    else
      {
        v=json['status'] ?? 0;
      }
    return InstantBooking(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      guideId: json['guide_id'] ?? 0,
      description: json['description'] ?? "",
      status: v,
      date: json['date'] ?? "",
      startTime: json['start_time'] ?? "",
      endTime: json['end_time'] ?? "",
      statusRemark: json['status_remark'] ?? "",
      bookingId: json['booking_id'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      hourlyRate: json['hourly_rate'] ?? "",
      guideData: json['guide_data'] != null ? Guide.fromJson(json['guide_data']) : null,
      guidePreference: json['guide_preference'] != null ? GuidePrefrence.fromJson(json['guide_preference']) : null,
      student: json['student_data'] != null ? Guide.fromJson(json['student_data']) : null,
      studentPrefrence: json['student_preference'] != null ? StudentPrefrence.fromJson(json['student_preference']) : null,
      sessionDatetime: json['session_datetime'] ?? "",
      statusText: json['status_text'] ?? "",
      remark: json['remark'] ?? "",
      payBtn: json['pay_btn'] ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['guide_id'] = guideId;
    data['description'] = description;
    data['status'] = status;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status_remark'] = statusRemark;
    data['booking_id'] = bookingId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['hourly_rate'] = hourlyRate;
    if (guideData != null) {
      data['guide_data'] = guideData!.toJson();
    }
    if (guidePreference != null) {
      data['guide_preference'] = guidePreference!.toJson();
    }
    data['session_datetime'] = sessionDatetime;
    data['status_text'] = statusText;
    data['remark'] = remark;
    data['pay_btn'] = payBtn;
    return data;
  }
}