import '../services/api_urls.dart';

class UserModal {
  int userId;
  String firstName;
  String lastName;
  String email;
  int? emailVerified;
  String zipCode;
  String type;
  int status;
  int isDelete;
  int accountStep;
  String? hereAboutUs;
  String? stripeAccountId;
  String stripeVerified;
  String updatedAt;
  String createdAt;
  String  walletAmount;
  String ipAddress;
  String? token; // Added token field
  StudentPrefrence? studentPrefrence;
  GuidePrefrence? guidePrefrence;
  List<GuideSchedule> guideScheduleList = [];
  List<GuideVideos> guideVideoList = [];
  final Map fullData;

  UserModal({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
    required this.zipCode,
    required this.type,
    required this.status,
    required this.isDelete,
    required this.accountStep,
    required this.hereAboutUs,
    required this.stripeAccountId,
    required this.stripeVerified,
    required this.updatedAt,
    required this.createdAt,
    required this.walletAmount,
    required this.ipAddress,
    this.token, // Added token parameter
    required this.guidePrefrence,
    required this.studentPrefrence,
    required this.fullData,
    required this.guideScheduleList,
    required this.guideVideoList,
  });

  factory UserModal.fromJson(
    Map json,
  ) {
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

    return UserModal(
      userId: json['id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      emailVerified: json['email_verified'],
      zipCode: json['zip_code'] ?? "",
      type: json['type'] ?? "",
      status: json['status'] ?? 0,
      isDelete: json['is_delete'] ?? 0,
      accountStep: json['account_step'] ?? 0,
      hereAboutUs: json['here_about_us'] ?? "",
      stripeAccountId: json['stripe_account_id'] ?? "",
      stripeVerified: json['stripe_verified'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      createdAt: json['created_at'] ?? "",
      walletAmount: json['wallet_amount'] != null ? json['wallet_amount'].toString() : "0.0",
      ipAddress: json['ip_address'] ?? "",
      token: json['token'], // Added token from JSON
      guidePrefrence: json['guide_prefrence'] != null
          ? GuidePrefrence.fromJson(json['guide_prefrence'])
          : (json['tutor_preferences'] != null
              ? GuidePrefrence.fromJson(json['tutor_preferences'])
              : (json['guide_preferences'] != null
                  ? GuidePrefrence.fromJson(json['guide_preferences'])
                  : null)),
      studentPrefrence: json['student_prefrence'] != null
          ? StudentPrefrence.fromJson(json['student_prefrence'])
          : (json['student_preferences'] != null
              ? StudentPrefrence.fromJson(json['student_preferences'])
              : null),
      guideScheduleList: schedule,
      guideVideoList: videos,
      fullData: json,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verified'] = emailVerified ?? 0;
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
    return data;
  }
}

class StudentPrefrence {
  int id;
  int userId;
  String profileImage;
  String countryCode;
  String phone;
  String location;
  String country;
  String state;
  String city;
  String zipCode;
  String longitude;
  String latitude;
  String createdAt;
  String updatedAt;
  String firstName;
  String lastName;

  StudentPrefrence(
      {required this.id,
      required this.userId,
      required this.profileImage,
      required this.countryCode,
      required this.phone,
      required this.location,
      required this.country,
      required this.state,
      required this.city,
      required this.zipCode,
      required this.longitude,
      required this.latitude,
      required this.createdAt,
      required this.updatedAt,
      required this.firstName,
      required this.lastName});

  factory StudentPrefrence.fromJson(Map<String, dynamic> json) {
    return StudentPrefrence(
      id: json['id']??0,
      userId: json['user_id']??0,
      profileImage: json['profile_image'] != null
          ? "${ApiUrls.baseImageUrl}${json['profile_image']}"
          : "",
      countryCode: json['country_code'] ?? "",
      phone: json['phone'] ?? "",
      location: json['location'] ?? "",
      country: json['country'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      zipCode: json['zip_code'] ?? "",
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['profile_image'] = profileImage;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['location'] = location;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['zip_code'] = zipCode;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GuidePrefrence {
  int id;
  int userId;
  String hasBeenTeacher;
  String schoolName;
  String tutoringExperience;
  String studentTypes;
  String lessonPreferences;
  String rewardingPreferences;
  String hasCar;
  String interestedInOnlineTutoring;
  String hasWorkedAsGuide;
  String interestedInInPersonTours;
  String hobbies;
  String hoursAvailablePerWeek;
  String lessonCancellation;
  String createdAt;
  String updatedAt;
  String profileHeadline;
  String tagLine;
  String hourlyRate;
  String speciality;
  String countryCode;
  String phone;
  String location;
  String country;
  String state;
  String zipCode;
  String city;
  String longitude;
  String latitude;
  String profileImage;
  String ugCollegeName;
  String ugDegreeType;
  String gCollegeName;
  String gDegreeType;
  String gCollegeName2;
  String gDegreeType2;
  String teachingCertificate;
  String guideLanguage;
  String workingHoursCalculated;
  int instantBookingAvailability;
  String university;
  String hometown;
  String studentsExperienceGuideLikes;
  int campusRepresentative;
  String? graduationYear; // Added graduationYear field

  GuidePrefrence(
      {required this.id,
      required this.userId,
      required this.hasBeenTeacher,
      required this.schoolName,
      required this.tutoringExperience,
      required this.studentTypes,
      required this.lessonPreferences,
      required this.rewardingPreferences,
      required this.hasCar,
      required this.interestedInOnlineTutoring,
      required this.hasWorkedAsGuide,
      required this.interestedInInPersonTours,
      required this.hobbies,
      required this.hoursAvailablePerWeek,
      required this.lessonCancellation,
      required this.createdAt,
      required this.updatedAt,
      required this.profileHeadline,
      required this.tagLine,
      required this.hourlyRate,
      required this.speciality,
      required this.countryCode,
      required this.phone,
      required this.location,
      required this.country,
      required this.state,
      required this.zipCode,
      required this.city,
      required this.longitude,
      required this.latitude,
      required this.profileImage,
      required this.ugCollegeName,
      required this.ugDegreeType,
      required this.gCollegeName,
      required this.gDegreeType,
      required this.gCollegeName2,
      required this.gDegreeType2,
      required this.teachingCertificate,
      required this.guideLanguage,
      required this.workingHoursCalculated,
      required this.instantBookingAvailability,
      required this.university,
      required this.hometown,
      required this.studentsExperienceGuideLikes,
      required this.campusRepresentative,
      this.graduationYear});

  factory GuidePrefrence.fromJson(Map<String, dynamic> json) {
    print('GuidePrefrence JSON: ${json.toString()}');
    return GuidePrefrence(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      hasBeenTeacher: json['has_been_teacher'] ?? "",
      schoolName: json['school_name'] ?? "",
      tutoringExperience: json['tutoring_experience'] ?? "",
      studentTypes: json['student_types'] ?? "",
      lessonPreferences: json['lesson_preferences'] ?? "",
      rewardingPreferences: json['rewarding_preferences'] ?? "",
      hasCar: json['has_car'] ?? "",
      interestedInOnlineTutoring: json['interested_in_online_tutoring'] ?? "",
      hasWorkedAsGuide: json['has_worked_as_guide'] ?? "",
      interestedInInPersonTours: json['interested_in_in_person_tours'] ?? "",
      hobbies: json['hobbies'] ?? "",
      hoursAvailablePerWeek: json['hours_available_per_week'] ?? "",
      lessonCancellation: json['lesson_cancellation'].toString() ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      profileHeadline: json['profile_headline'] ?? "",
      tagLine: json['tag_line'] ?? "",
      hourlyRate: json['hourly_rate'] ?? "",
      speciality: json['speciality'] ?? "",
      countryCode: json['country_code'] ?? "",
      phone: json['phone'] ?? "",
      location: json['location'] ?? "",
      country: json['country'] ?? "",
      state: json['state'] ?? "",
      zipCode: json['zip_code'] ?? "",
      city: json['city'] ?? "",
      longitude: json['longitude'] ?? "",
      latitude: json['latitude'] ?? "",
      profileImage: json['profile_image'] != null
          ? "${ApiUrls.baseImageUrl}${json['profile_image']}"
          : "",
      ugCollegeName: json['ug_college_name'] ?? "",
      ugDegreeType: json['ug_degree_type'] ?? "",
      gCollegeName: json['g_college_name'] ?? "",
      gDegreeType: json['g_degree_type'] ?? "",
      gCollegeName2: json['g_college_name2'] ?? "",
      gDegreeType2: json['g_degree_type2'] ?? "",
      teachingCertificate: json['teaching_certificate'] ?? "",
      guideLanguage: json['guide_language'] ?? "",
      workingHoursCalculated: json['working_hours_calculated'] ?? "",
      instantBookingAvailability: json['instant_booking_availability'] ?? 0,
      university: json['university'] ?? "",
      hometown: json['hometown'] ?? "",
      studentsExperienceGuideLikes:
          json['students_experience_guide_likes'] ?? "",
      campusRepresentative: json['campus_representative'] != null
          ? int.parse(json['campus_representative'].toString())
          : 0,
      graduationYear: json['graduation_year']?.toString(), // Convert to String
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['has_been_teacher'] = hasBeenTeacher ?? "";
    data['school_name'] = schoolName ?? "";
    data['tutoring_experience'] = tutoringExperience ?? "";
    data['student_types'] = studentTypes ?? "";
    data['lesson_preferences'] = lessonPreferences ?? "";
    data['rewarding_preferences'] = rewardingPreferences ?? "";
    data['has_car'] = hasCar ?? "";
    data['interested_in_online_tutoring'] = interestedInOnlineTutoring ?? "";
    data['has_worked_as_guide'] = hasWorkedAsGuide ?? "";
    data['interested_in_in_person_tours'] = interestedInInPersonTours ?? "";
    data['hobbies'] = hobbies ?? "";
    data['hours_available_per_week'] = hoursAvailablePerWeek ?? "";
    data['lesson_cancellation'] = lessonCancellation ?? "";
    data['created_at'] = createdAt ?? "";
    data['updated_at'] = updatedAt ?? "";
    data['profile_headline'] = profileHeadline ?? "";
    data['tag_line'] = tagLine ?? "";
    data['hourly_rate'] = hourlyRate ?? "";
    data['speciality'] = speciality ?? "";
    data['country_code'] = countryCode ?? "";
    data['phone'] = phone ?? "";
    data['location'] = location ?? "";
    data['country'] = country ?? "";
    data['state'] = state ?? "";
    data['zip_code'] = zipCode ?? "";
    data['city'] = city ?? "";
    data['longitude'] = longitude ?? "";
    data['latitude'] = latitude ?? "";
    data['profile_image'] = profileImage ?? "";
    data['ug_college_name'] = ugCollegeName ?? "";
    data['ug_degree_type'] = ugDegreeType ?? "";
    data['g_college_name'] = gCollegeName ?? "";
    data['g_degree_type'] = gDegreeType ?? "";
    data['g_college_name2'] = gCollegeName2 ?? "";
    data['g_degree_type2'] = gDegreeType2 ?? "";
    data['teaching_certificate'] = teachingCertificate ?? "";
    data['guide_language'] = guideLanguage ?? "";
    data['working_hours_calculated'] = workingHoursCalculated ?? "";
    data['instant_booking_availability'] = instantBookingAvailability ?? "";
    data['university'] = university ?? "";
    data['hometown'] = hometown ?? "";
    data['students_experience_guide_likes'] =
        studentsExperienceGuideLikes ?? "";
    data['campus_representative'] = campusRepresentative ?? "";
    data['graduation_year'] = graduationYear ?? ""; // Added graduationYear to JSON
    return data;
  }
}

class GuideSchedule {
  int id;
  int userId;
  String day;
  String startTime;
  String endTime;
  String isOffDay;
  String createdAt;
  String updatedAt;

  GuideSchedule(
      {required this.id,
      required this.userId,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.isOffDay,
      required this.createdAt,
      required this.updatedAt});

  factory GuideSchedule.fromJson(Map<String, dynamic> json) {
    return GuideSchedule(
      id: json['id'],
      userId: json['user_id'],
      day: json['day'] ?? "",
      startTime: json['start_time'] ?? "",
      endTime: json['end_time'] ?? "",
      isOffDay: json['is_off_day'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['day'] = day;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['is_off_day'] = isOffDay;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GuideVideos {
  int id;
  int userId;
  String videoTitle;
  String videoUrl;
  String videoThumbnail;
  String updatedAt;
  String createdAt;
  String description;

  GuideVideos(
      {required this.id,
      required this.userId,
      required this.videoTitle,
      required this.videoThumbnail,
      required this.videoUrl,
      required this.updatedAt,
      required this.createdAt,
      required this.description});

  factory GuideVideos.fromJson(Map<String, dynamic> json) {
    return GuideVideos(
      id: json['id'],
      userId: json['user_id'],
      videoTitle: json['video_title'] ?? "",
      videoThumbnail: json['video_thumbnail'] != null
          ? "${ApiUrls.baseImageUrl}${json['video_thumbnail']}"
          : "",
      videoUrl: json['video_url'] != null
          ? "${ApiUrls.baseImageUrl}${json['video_url']}"
          : "",
      // videoUrl:json['video_url']??"",
      updatedAt: json['updated_at'] ?? "",
      createdAt: json['created_at'] ?? "",
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['video_title'] = videoTitle;
    data['video_url'] = videoUrl;
    data['video_thumbnail'] = videoThumbnail;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['description'] = description;
    return data;
  }
}

class GuideReviews {
  int rating;
  String ratingComment;
  String ratingDt;
  String firstName;
  String lastName;
  String profileImage;

  GuideReviews(
      {required this.rating,
      required this.ratingComment,
      required this.ratingDt,
      required this.firstName,
      required this.lastName,
      required this.profileImage});

  factory GuideReviews.fromJson(Map<String, dynamic> json) {
    return GuideReviews(
      rating: json['rating'] ?? 0,
      ratingComment: json['rating_comment'] ?? "",
      ratingDt: json['rating_dt'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName:
          json['last_name'] != null && json['last_name'].toString().isNotEmpty
              ? json['last_name'].toString()[0].toUpperCase()
              : "",
      profileImage: json['profile_image'] != null
          ? "${ApiUrls.baseImageUrl}${json['profile_image']}"
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['rating_comment'] = ratingComment;
    data['rating_dt'] = ratingDt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_image'] = profileImage;
    return data;
  }
}
