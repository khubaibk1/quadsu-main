import 'package:quadsu_app/modal/session_model.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';
import 'package:quadsu_app/services/api_urls.dart';

class StudentDashboard {
  List<ScheduledSessions> scheduledSessions;
  List<Guide> guide;
  List<Category> category;
  Map<String, dynamic> categoryCount = {};

  StudentDashboard(
      {required this.scheduledSessions,
      required this.guide,
      required this.category,
      required this.categoryCount});

  factory StudentDashboard.fromJson(Map<String, dynamic> json) {
    List<ScheduledSessions> scheduledSessions = [];
    List<Guide> guide = [];
    List<Category> category = [];

    if (json['scheduled_sessions'] != null) {
      scheduledSessions = <ScheduledSessions>[];
      json['scheduled_sessions'].forEach((v) {
        scheduledSessions.add(ScheduledSessions.fromJson(v));
      });
    }
    if (json['guide'] != null) {
      guide = <Guide>[];
      json['guide'].forEach((v) {
        guide.add(Guide.fromJson(v));
      });
    }

    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category.add(Category.fromJson(v, json['categoryCount'] ?? {}));
      });
    }

    return StudentDashboard(
      category: category,
      guide: guide,
      scheduledSessions: scheduledSessions,
      categoryCount: json['categoryCount'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheduled_sessions'] =
        scheduledSessions.map((v) => v.toJson()).toList();

    data['guide'] = guide.map((v) => v.toJson()).toList();
    data['category'] = category.map((v) => v.toJson()).toList();
    return data;
  }
}

class MeetingStatus
{
  static const String joinCall="Join Call";
  static const String startCall="Start Call";
}

class ScheduledSessions {
  int? bookingId;
  int? bookId;
  int? guideId;
  String? date;
  String? startTime;
  String? endTime;
  String? comment;
  String? studentId;
  double? totalHours;
  double? totalHoursCost;
  double? perHoursCost;
  double? serviceFee;
  double? tax;
  double? totalPaidAmount;
  double ? rating;
  String? ratingComment;
  String? ratingDt;
  int? cancel;
  String? cancelReason;
  String? cancelDt;
  String? createdAt;
  String? updatedAt;
  int? notStarted;
  int? popup5minsBefore;
  Guide? guideData;
  Guide? studentData;
  GuidePrefrence? guidePrefrence;
  StudentPrefrence? studentPrefrence;
  Transaction? transaction;
  int? sessionStatus;
  int? cancelButtonStatus;
  String meetingStatus="";
  String meetingUrl="";

  ScheduledSessions(
      {this.bookingId,
      this.bookId,
      this.guideId,
      this.date,
      this.startTime,
      this.endTime,
      this.comment,
      this.studentId,
      this.totalHours,
      this.totalHoursCost,
      this.perHoursCost,
      this.serviceFee,
      this.tax,
      this.totalPaidAmount,
      this.rating,
      this.ratingComment,
      this.ratingDt,
      this.cancel,
      this.cancelReason,
      this.cancelDt,
      this.createdAt,
      this.updatedAt,
      this.notStarted,
      this.popup5minsBefore,
      this.guideData,
      this.guidePrefrence,
      this.studentData,
      this.sessionStatus,
      this.cancelButtonStatus,
      this.meetingStatus="",
      this.meetingUrl=""});

  ScheduledSessions.fromJson(Map<String, dynamic> json) {
    int status = 0;

    if (json["not_started"].toString() == "0") {
      status = SessionStatus.pending;
    }

    if (json["cancel"].toString() == "1") {
      status = SessionStatus.cancelled;
    }

    print("date::::${json['date']}");
    print("date::::${json['start_time']}");
    print("date::::${json['end_time']}");

    bookingId = json['booking_id'];
    bookId = json['book_id'];
    guideId = json['guide_id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    comment = json['comment'];
    sessionStatus = status;

    studentId = json['student_id'];
    totalHours = json['total_hours'] != null
        ? double.parse(json['total_hours'].toString())
        : null;
    totalHoursCost = json['total_hours_cost'] != null
        ? double.parse(json['total_hours_cost'].toString())
        : null;
    perHoursCost = json['per_hours_cost'] != null
        ? double.parse(json['per_hours_cost'].toString())
        : null;
    serviceFee = json['service_fee'] != null
        ? double.parse(json['service_fee'].toString())
        : null;
    tax = json['tax'] != null ? double.parse(json['tax'].toString()) : null;
    totalPaidAmount = json['total_paid_amount'] != null
        ? double.parse(json['total_paid_amount'].toString())
        : null;
    rating = json['rating']!= null?double.tryParse(json['rating'].toString())??0.0:0.0;
    ratingComment = json['rating_comment'];
    ratingDt = json['rating_dt'];
    cancel = json['cancel'];
    cancelReason = json['cancel_reason'];
    cancelDt = json['cancel_dt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    notStarted = json['not_started'];
    popup5minsBefore = json['popup_5mins_before'];
    guideData =
        json['guide_data'] != null ? Guide.fromJson(json['guide_data']) : null;
    studentData = json['student_data'] != null
        ? Guide.fromJson(json['student_data'])
        : null;

    transaction = json['transaction_data'] != null
        ? Transaction.fromJson(json['transaction_data'])
        : null;

    guidePrefrence = json['guide_prefrence'] != null
        ? GuidePrefrence.fromJson(json['guide_prefrence'])
        : (json['tutor_preferences'] != null
            ? GuidePrefrence.fromJson(json['tutor_preferences'])
            : (json['guide_preferences'] != null
                ? GuidePrefrence.fromJson(json['guide_preferences'])
                : null));
    studentPrefrence = json['student_prefrence'] != null
        ? StudentPrefrence.fromJson(json['student_prefrence'])
        : (json['student_preferences'] != null
            ? StudentPrefrence.fromJson(json['student_preferences'])
            : null);

    cancelButtonStatus = json['cancel_button'] != null
        ? int.parse(json['cancel_button'].toString())
        : 0;
    meetingUrl= json['meeting_url'] != null ? json['meeting_url'].toString() : "";
    meetingStatus= json['meeting_status'] != null ? json['meeting_status'].toString() : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['book_id'] = bookId;
    data['guide_id'] = guideId;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['comment'] = comment;
    data['student_id'] = studentId;
    data['total_hours'] = totalHours;
    data['total_hours_cost'] = totalHoursCost;
    data['per_hours_cost'] = perHoursCost;
    data['service_fee'] = serviceFee;
    data['tax'] = tax;
    data['total_paid_amount'] = totalPaidAmount;
    data['rating'] = rating;
    data['rating_comment'] = ratingComment;
    data['rating_dt'] = ratingDt;
    data['cancel'] = cancel;
    data['cancel_reason'] = cancelReason;
    data['cancel_dt'] = cancelDt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['not_started'] = notStarted;
    data['popup_5mins_before'] = popup5minsBefore;
    if (guideData != null) {
      data['guide_data'] = guideData!.toJson();
    }
    if (guidePrefrence != null) {
      data['guide_prefrence'] = guidePrefrence!.toJson();
    }
    return data;
  }
}

class Guide {
  int? id;
  String firstName = '';
  String lastName = '';
  String? email;
  int? emailVerified;
  String? zipCode;
  String? type;
  int? status;
  int? isDelete;
  int? accountStep;
  String? hereAboutUs;
  String? stripeAccountId;
  String? stripeVerified;
  String? updatedAt;
  String? createdAt;
  String? walletAmount;
  String? ipAddress;
  double avgRatting = 0.0;
  GuidePrefrence? guidePrefrence;
  StudentPrefrence? studentPrefrence;
  List<GuideReviews> guideReviews = [];
  List<GuideVideos> guideVideos = [];
  List<GuideSchedule> guideSchedule = [];

  Guide(
      {this.id,
      this.firstName = '',
      this.lastName = '',
      this.email,
      this.emailVerified,
      this.zipCode,
      this.type,
      this.status,
      this.isDelete,
      this.accountStep,
      this.hereAboutUs,
      this.stripeAccountId,
      this.stripeVerified,
      this.updatedAt,
      this.createdAt,
      this.walletAmount,
      this.ipAddress,
      required this.guideReviews,
      required this.guideVideos,
      required this.guideSchedule,
      this.guidePrefrence,
      this.studentPrefrence,
      required this.avgRatting});

  Guide.fromJson(Map<String, dynamic> json) {
    double avg = 0.0;
    List<GuideSchedule> schedule = [];
    if (json['guide_schedule'] != null) {
      schedule = <GuideSchedule>[];
      json['guide_schedule'].forEach((v) {
        schedule.add(GuideSchedule.fromJson(v));
      });
    }

    List<GuideVideos> videos = [];
    if (json['guide_videos'] != null) {
      videos = <GuideVideos>[];

      json['guide_videos'].forEach((v) {
        videos.add(GuideVideos.fromJson(v));
      });
    }

    List<GuideReviews> reviews = [];
    if (json['guide_reviews'] != null) {
      reviews = <GuideReviews>[];

      json['guide_reviews'].forEach((v) {
        avg = avg + (v["rating"] ?? 0.0);

        reviews.add(GuideReviews.fromJson(v));
      });
    }

    avg = avg / reviews.length;

    id = json['id'];
    firstName = json['first_name']??'';
    lastName =
        json['last_name'] != null && json['last_name'].toString().isNotEmpty
            ? json['last_name'].toString()[0].toUpperCase()
            : "";
    email = json['email'];
    emailVerified = json['email_verified'];
    zipCode = json['zip_code'];
    type = json['type'];
    status = json['status'];
    isDelete = json['is_delete']!= null ?int.parse(json["is_delete"].toString()) :0;
    accountStep = json['account_step'];
    hereAboutUs = json['here_about_us'];
    stripeAccountId = json['stripe_account_id'];
    stripeVerified = json['stripe_verified'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    walletAmount = json['wallet_amount'] != null? json['wallet_amount'].toString() :"0.0";
    ipAddress = json['ip_address'];
    guidePrefrence = json['guide_prefrence'] != null
        ? GuidePrefrence.fromJson(json['guide_prefrence'])
        : (json['tutor_preferences'] != null
            ? GuidePrefrence.fromJson(json['tutor_preferences'])
            : (json['guide_preferences'] != null
                ? GuidePrefrence.fromJson(json['guide_preferences'])
                : null));

    studentPrefrence = json['student_preferences'] != null
        ? StudentPrefrence.fromJson(json['student_preferences'])
        : (json['student_prefrence'] != null
            ? StudentPrefrence.fromJson(json['student_prefrence'])
            : null);
    guideReviews = reviews;
    guideSchedule = schedule;
    guideVideos = videos;
    avgRatting = avg;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verified'] = emailVerified;
    data['zip_code'] = zipCode;
    data['type'] = type;
    data['status'] = status;
    data['is_delete'] = isDelete;
    data['account_step'] = accountStep;
    data['here_about_us'] = hereAboutUs;
    data['stripe_account_id'] = stripeAccountId;
    data['stripe_verified'] = stripeVerified;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['wallet_amount'] = walletAmount;
    data['ip_address'] = ipAddress;
    if (guidePrefrence != null) {
      data['guide_prefrence'] = guidePrefrence!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? title;
  int? count;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.title,
      this.image,
      this.description,
      this.count,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> categoryCount) {
    id = json['id'];
    title = json['title'];
    image = json['image'] != null
        ? "${ApiUrls.baseImageUrl}${json['image']}"
        : "";
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    count = categoryCount[json['title']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
