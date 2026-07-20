class ApiUrls {
  static const baseUrl = 'https://quadsu.com/api/';
  static const baseImageUrl = 'https://quadsu.com/public/';

  static const String signUpGuide = '${baseUrl}signup';

  ///DONE
  static const String signUpGuideStep2 = '${baseUrl}signup-step2';

  ///DONE
  static const String signUpGuideStep3 = '${baseUrl}signup-step3';

  ///DONE
  static const String login = '${baseUrl}signin';

  ///DONE
  static const String resendEmail = '${baseUrl}resend-email';

  ///DONE
  static const String forgetPassword = '${baseUrl}forget-password';

  ///DONE
  static const String updateDeviceToken = '${baseUrl}update-device-token';

  ///DONE
  static const String getUserDetails = '${baseUrl}get-profile';

  ///DONE
  static const String interval = "${baseUrl}interval";

  ///DONE
  static const String getLanguages = "${baseUrl}get-language";

  ///DONE
  static const String getBanner = "${baseUrl}home-page-banner";

  ///DONE
  static const String getSpecialities = "${baseUrl}get-specialities";

  ///DONE
  static const String getAppSettings = "${baseUrl}app-settings";

  ///DONE
  static const String getUniversity = "${baseUrl}get-university";

  ///DONE
  static const String changePassword = '${baseUrl}change-password';

  ///DONE
  static const String uploadImageUrl = '${baseUrl}uploadimage-to-url';

  ///DONE
  static const String editProfileImage = '${baseUrl}update-image-profile';

  ///DONE
  static const String editBasicDetail = '${baseUrl}update-basic-profile-detail';

  ///DONE
  static const String updateSkills = '${baseUrl}update-skills';

  ///DONE
  static const String updatePolicies = '${baseUrl}update-policies';

  ///DONE
  static const String updateAddress = '${baseUrl}update-address';

  ///DONE
  static const String deleteUser = '${baseUrl}delete-account';

  ///DONE
  static const String updateLanguage = '${baseUrl}update-language';

  ///DONE
  static const String updateUniversity = '${baseUrl}update-university';

  ///DONE
  static const String updateEducation = '${baseUrl}update-education';
  static const String updateVideos = '${baseUrl}update-videos';
  static const String deleteVideo = '${baseUrl}delete-video';
  static const String updateSchedule = '${baseUrl}update-schedule';
  static const String getTutorProfile = '${baseUrl}get-tutor-profile';
  static const String updateTutorProfile = '${baseUrl}update-tutor-profile';
  static const getNotifications = '${baseUrl}get-notification';

  ///DONE

  static const String signUpStudent = '${baseUrl}signup';
  static const String editProfileImageStudent =
      '${baseUrl}update-customer-profile';
  static const String editBasicDetailStudent =
      '${baseUrl}update-customer-basic-profile';
  static const String updateAddressStudent =
      '${baseUrl}update-customer-address';

  ///DONE
  static const String homePageStudent = '${baseUrl}home-page-data';

  ///DONE
  static const String homeData = '${baseUrl}home-data';

  ///DONE
  static const String getStudentProfile = '${baseUrl}get-user-detail';

  ///DONE
  static const getGuideProfile = '${baseUrl}guide-profile-data';

  ///DONE
  static const searchGuide = '${baseUrl}search-data';

  ///DONE
  static const getAvailability = '${baseUrl}availability-of-slot';

  static String getGuideAvailability(dynamic guideId) =>
      '${baseUrl}guides/$guideId/availability';

  ///DONE
  static const createBooking = '${baseUrl}booking-completed';

  ///DONE
  static const getSessionsStudent = '${baseUrl}get-all-student-session';

  ///DONE
  static const getSessionsGuide = '${baseUrl}get-all-guide-session';
  static var homePageGuide = '${baseUrl}guide-dashboard';
  static var cancelBooking = '${baseUrl}cancel-booking';
  static var rateBooking = '${baseUrl}session-rating';
  static var instantBookingRequestStudent =
      '${baseUrl}student-instant-booking-list';
  static var instantBookingRequestGuide =
      '${baseUrl}guide-instant-booking-list';
  static var instantBookingRequest = '${baseUrl}request-instant-booking';
  static var instantBookingReject = '${baseUrl}instant-booking-reject';
  static var instantBookingAccept = '${baseUrl}instant-booking-accept';

  static var getMyGuides = '${baseUrl}my-guides';
  static var getMyStudents = '${baseUrl}my-students';

  // --- Guide Schedule & Booking APIs ---
  static const String googleConnect = '${baseUrl}google-connect';
  static const String getMySchedule = '${baseUrl}get-my-schedule';
  static const String saveMySchedule = '${baseUrl}save-my-schedule';
  static const String upcomingSessions = '${baseUrl}upcoming-sessions';
  static const String checkoutDetails = '${baseUrl}bookings/checkout-details';
  static const String verifyPaypal = '${baseUrl}bookings/verify-paypal';

  static const String createMeeting = "${baseUrl}create-meeting";
  static const String joinMeeting = "${baseUrl}join-meeting";
  static const String checkEndVideoCall = "${baseUrl}check-end-video-call";
  static const String endVideoCall = "${baseUrl}end-video-call";
  static const String updateRecording = "${baseUrl}update-recording";

  static var getStudentTransactions = '${baseUrl}student-transactions-history';
  static var getGuideWallet = '${baseUrl}guide-wallet-history';
  static var requestWithdraw = '${baseUrl}request-widthdrawal';
  static var getWithdrawHistory = '${baseUrl}guide-widthdrawal-history';
  static var getSessionRecordings = '${baseUrl}session-recordings';
  static var getRecordingUrl = '${baseUrl}get-recording';

  static const String terms = '${baseUrl}terms';
  static const String privacyPolicy = '${baseUrl}privacy-policy';
  static const String uploadMultipleImageUrl =
      '${baseUrl}upload-multiple-image-to-url';

  static var getUserDetailsWithId = "";

  // --- Laravel Chat Backend Endpoints ---
  static const String verifyAndInitChat = '${baseUrl}chat/verify-and-init';
  static const String getChatToken = '${baseUrl}chat/token';
  static const String sendChatNotification = '${baseUrl}send-notification';
}
