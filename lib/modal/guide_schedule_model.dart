class GuideScheduleModel {
  String status;
  bool isGoogleConnected;
  String timezone;
  List<ScheduleDay> schedule;

  GuideScheduleModel({
    required this.status,
    required this.isGoogleConnected,
    required this.timezone,
    required this.schedule,
  });

  factory GuideScheduleModel.fromJson(Map<String, dynamic> json) {
    var scheduleList = json['schedule'] as List? ?? [];
    return GuideScheduleModel(
      status: json['status'] ?? "",
      isGoogleConnected: json['is_google_connected'] ?? false,
      timezone: json['timezone'] ?? "UTC",
      schedule: scheduleList.map((e) => ScheduleDay.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule': schedule.map((e) => e.toJsonForSave()).toList(),
    };
  }
}

class ScheduleDay {
  int? id;
  int? userId;
  String day;
  String? startTime;
  String? endTime;
  bool isOffDay;

  ScheduleDay({
    this.id,
    this.userId,
    required this.day,
    this.startTime,
    this.endTime,
    required this.isOffDay,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    return ScheduleDay(
      id: json['id'],
      userId: json['user_id'],
      day: json['day'] ?? "",
      startTime: json['start_time'],
      endTime: json['end_time'],
      isOffDay: json['is_off_day'] == "1" ||
          json['is_off_day'] == 1 ||
          json['is_off_day'] == true,
    );
  }

  Map<String, dynamic> toJsonForSave() {
    return {
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'is_off_day': isOffDay,
    };
  }
}
