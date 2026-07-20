class UpcomingBookingModel {
  String status;
  List<BookingDetails> bookings; // Internal property name kept for consistency

  UpcomingBookingModel({
    required this.status,
    required this.bookings,
  });

  factory UpcomingBookingModel.fromJson(Map<String, dynamic> json) {
    var bookingsList = json['bookings'] as List? ?? [];
    return UpcomingBookingModel(
      status: json['status'] ?? "",
      bookings: bookingsList.map((e) => BookingDetails.fromJson(e)).toList(),
    );
  }
}

class BookingDetails {
  int bookId;
  String studentId;
  String date;
  String startTime;
  String status;
  String? meetingLink;
  String? subject;
  StudentInfo? student;

  BookingDetails({
    required this.bookId,
    required this.studentId,
    required this.date,
    required this.startTime,
    required this.status,
    this.meetingLink,
    this.subject,
    this.student,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      bookId: json['book_id'] ?? 0,
      studentId: json['student_id']?.toString() ?? "",
      date: json['date'] ?? "",
      startTime: json['start_time'] ?? "",
      status: json['status'] ?? "",
      meetingLink: json['meeting_link'],
      subject: json['subject'],
      student: json['student'] != null
          ? StudentInfo.fromJson(json['student'])
          : null,
    );
  }
}

class StudentInfo {
  String email;
  String fullName;
  String userAvatar;

  StudentInfo({
    required this.email,
    required this.fullName,
    required this.userAvatar,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      email: json['email'] ?? "",
      fullName: json['full_name'] ?? "",
      userAvatar: json['user_avatar'] ?? "",
    );
  }
}
