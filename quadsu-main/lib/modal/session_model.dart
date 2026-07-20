import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';

class SessionModel {
  List<Session> sessions = [];

  SessionModel({required this.sessions});

  factory SessionModel.fromJson(List<dynamic> json) {
    List<Session> data = [];
    data = <Session>[];
    for (var v in json) {
      data.add(Session.fromJson(v));
    }
    return SessionModel(sessions: data);
  }
}

class Session {
  int bookingId;
  Guide? guide;
  GuidePrefrence? guideData;
  StudentPrefrence? student;
  Transaction? transaction;
  ScheduledSessions? scheduledSessions;
  double totalAmount;
  double serviceFee;
  double tax;
  int serviceFeePercentage;
  int taxPercentage;
  int sessionStatus;
  String cancelButtonStatus;
  String meetingUrl;
  String meetingStatus;

  Session({
    required this.bookingId,
    required this.guide,
    required this.guideData,
    required this.transaction,
    required this.totalAmount,
    required this.serviceFee,
    required this.tax,
    required this.student,
    required this.scheduledSessions,
    required this.serviceFeePercentage,
    required this.taxPercentage,
    required this.sessionStatus,
    required this.cancelButtonStatus,
    required this.meetingUrl,
    required this.meetingStatus,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    print("datdtadtadtadt:::::${json['guideData']}");
    return Session(
      bookingId: json['booking_id'] ?? 0,
      guide: json['guide'] != null ? Guide.fromJson(json['guide']) : null,
      guideData: json['guide_data'] != null
          ? GuidePrefrence.fromJson(json['guide_data'])
          : null,
      student: json['student'] != null
          ? StudentPrefrence.fromJson(json['student'])
          : null,
      transaction: json['transaction_data'] != null
          ? Transaction.fromJson(json['transaction_data'])
          : null,
      totalAmount: json['totalAmount'] != null
          ? double.parse(json['totalAmount'].toString())
          : 0.0,
      serviceFee: json['serviceFee'] != null
          ? double.parse(json['serviceFee'].toString())
          : 0.0,
      tax: json['tax'] != null ? double.parse(json['tax'].toString()) : 0.0,
      serviceFeePercentage: json['serviceFeePercentage'] != null
          ? int.parse(json['serviceFeePercentage'].toString())
          : 0,
      taxPercentage: json['taxPercentage'] != null
          ? int.parse(json['taxPercentage'].toString())
          : 0,
      scheduledSessions: json['booking_data'] != null
          ? ScheduledSessions.fromJson(json['booking_data'])
          : null,
      sessionStatus: getStatus(status: json["status"].toString()),
      cancelButtonStatus: json['cancel_button'] != null ? json['cancel_button'].toString() : "",
      meetingUrl: json['meeting_url'] != null ? json['meeting_url'].toString() : "",
      meetingStatus: json['meeting_status'] != null ? json['meeting_status'].toString() : "",
    );
  }

  static int getStatus({required String status}) {
    if (status == 'Completed') {
      return SessionStatus.completed;
    } else if (status == 'Cancelled') {
      return SessionStatus.cancelled;
    } else if (status == 'Not started') {
      return SessionStatus.pending;
    } else {
      return SessionStatus.pending;
    }
  }
}

class Transaction {
  int id;
  int bookingId;
  String trxId;
  String paymentGateway;
  double amount;
  String tutorShare;
  String quadUShare;
  String createdAt;
  String updatedAt;

  Transaction(
      {required this.id,
      required this.bookingId,
      required this.trxId,
      required this.paymentGateway,
      required this.amount,
      required this.tutorShare,
      required this.quadUShare,
      required this.createdAt,
      required this.updatedAt});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['id'] ?? 0,
        bookingId: json['booking_id'] ?? 1234,
        trxId: json['trx_id'] ?? "",
        paymentGateway: json['payment_gateway'] ?? "",
        amount: json['amount'] != null ?double.tryParse(json['amount'].toString())??0.0 :0.0,
        tutorShare: json['tutor_share'] ?? "",
        quadUShare: json['quad_u_share'] ?? "",
        createdAt: json['created_at'] ?? "",
        updatedAt: json['updated_at'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['trx_id'] = trxId;
    data['payment_gateway'] = paymentGateway;
    data['amount'] = amount;
    data['tutor_share'] = tutorShare;
    data['quad_u_share'] = quadUShare;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
