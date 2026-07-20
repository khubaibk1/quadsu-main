import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quadsu_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/custom_app_setting.dart';
import 'package:quadsu_app/modal/response_modal.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/pages/auth_module/admin_approve_screen.dart';
import 'package:quadsu_app/pages/auth_module/guide_profile_setup_screen.dart';
import 'package:quadsu_app/pages/auth_module/login_screen.dart';
import 'package:quadsu_app/pages/auth_module/verify_email_screen.dart';
import 'package:quadsu_app/pages/commons/bottom_bar_screen.dart';
import 'package:quadsu_app/pages/guide_module/guide_bottom_bar.dart';
import 'package:quadsu_app/provider/app_language_provider.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/provider/bottom_tabbar_provider.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/provider/instant_booking_provider.dart';
import 'package:quadsu_app/provider/notification_provider.dart';
import 'package:quadsu_app/provider/recording_provider.dart';
import 'package:quadsu_app/provider/search_guide_provider.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';
import 'package:quadsu_app/provider/student_guide_provider.dart';
import 'package:quadsu_app/provider/transaction_provider.dart';
import 'package:quadsu_app/provider/withdraw_provider.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/shared_preference_services/shared_preference_services.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/my_colors.dart';
import '../constants/my_image_url.dart';
import '../constants/shared_preference_keys.dart';
import '../constants/sized_box.dart';
import '../services/firebase_services/firebase_push_notifications.dart';
import '../widget/common_alert_dailog.dart';
import '../widget/custom_button.dart';

class MyAuthProvider extends ChangeNotifier {
  Future<void> splashAuthentication(context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebasePushNotifications.initializeFirebaseNotifications();
    sharedPreference = await SharedPreferences.getInstance();
    try {
      var appLanguageProvider =
          Provider.of<AppLanguageProvider>(context, listen: false);
      appLanguageProvider.initializeLanguage();
    } catch (e) {
      print('🟡 [SPLASH] AppLanguageProvider initialization failed (non-fatal): $e');
    }
    await isLoggedIn();
    userNavigation(context);
    FirebasePushNotifications.handleNotificationsIfAppIsKilled();
  }

  Future<UserModal?> isLoggedIn() async {
    String? userDataString =
        sharedPreference.getString(SharedPreferenceKeys.userData);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      userToken = sharedPreference.getString(SharedPreferenceKeys.userToken);
      userDataNotifier.value = UserModal.fromJson(userData);
      await getUserData();
      return userDataNotifier.value;
    } else {
      return null;
    }
  }

  Future<void> updateUserDataInSharedPreference(
      {required Map userData, String? token}) async {
    String userDataString = jsonEncode(userData);
    userDataNotifier.value = UserModal.fromJson(userData);
    await sharedPreference.setString(
        SharedPreferenceKeys.userData, userDataString);
    if (token != null) {
      userToken = token;
      await sharedPreference.setString(SharedPreferenceKeys.userToken, token);
    }
  }

  Future<void> getUserData() async {
    var jsonResponse = await NewestWebServices.getResponse(
        apiMethod: ApiMethod.get,
        apiUrl: ApiUrls.getUserDetails,
        request: {
          ApiKeys.userId: userDataNotifier.value?.userId,
          ApiKeys.type: userDataNotifier.value?.type,
        },
        showSuccessMessage: false);
    if (jsonResponse.status == 1) {
      updateUserDataInSharedPreference(
        userData: jsonResponse.data['user_info'],
      );
    }
    notifyListeners();
  }

  Future<void> userNavigation(BuildContext context) async {
    print('\n🔄 [USER NAVIGATION] Starting navigation...');
    print('📊 User Type: ${userDataNotifier.value?.type}');
    print('📊 Account Step: ${userDataNotifier.value?.accountStep}');

    if (globalLanguages.isEmpty) {
      getLanguages(context);
    }
    if (globalUniversity.isEmpty) {
      getUniversity(context);
    }
    if (globalSpecialities.isEmpty) {
      getSpecialities(context);
    }

    if (myAppSettings == null) {
      await getAppSettings(context);
    }

    if (bannerTitle.isEmpty) {
      getBanner(context);
    }

    intervalTimer?.cancel();

    if (userDataNotifier.value != null) {
      intervalProviderToCheckBlockStatus();
      
      // Log into Firebase using custom token from backend
      // Backend response: {"status": "success", "firebase_token": "..."}
      try {
        // Check if already signed in
        if (FirebaseAuth.instance.currentUser != null) {
          print('🟢 [FIREBASE AUTH] Already signed in as: ${FirebaseAuth.instance.currentUser!.uid}');
        } else {
          var tokenRes = await NewestWebServices.getResponse(
              apiUrl: ApiUrls.getChatToken,
              request: {},
              apiMethod: ApiMethod.get,
              showErrorMessage: false);

          print('🔵 [FIREBASE AUTH] getChatToken fullData=${tokenRes.fullData}');

          // Backend returns "firebase_token" key with status="success"
          final firebaseToken = tokenRes.fullData['firebase_token'] ??
                                tokenRes.fullData['token'] ??
                                (tokenRes.data is Map ? (tokenRes.data['firebase_token'] ?? tokenRes.data['token']) : null);

          if (firebaseToken != null) {
            await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
            print('🟢 [FIREBASE AUTH] Successfully signed in with custom Firebase token!');
          } else {
            print('🔴 [FIREBASE AUTH] No firebase_token in response. Full response: ${tokenRes.fullData}');
          }
        }
      } catch (e) {
        print('🔴 [FIREBASE AUTH] Error: $e');
      }
      
      try {
        String? token = await FirebasePushNotifications.getToken();
        updateDeviceToken(token: token ?? '');
      } catch (e) {
        print('🔴 Error getting Firebase device token: $e');
      }
    }

    if (userDataNotifier.value == null) {
      print('🔄 [USER NAVIGATION] No user data - going to LoginPage');
      CustomNavigation.pushReplacement(
          // ignore: use_build_context_synchronously
          context: context,
          screen: const LoginPage());
    } else if (userDataNotifier.value!.type == UserType.guide) {
      print(
          '🔄 [USER NAVIGATION] User is GUIDE with account_step: ${userDataNotifier.value?.accountStep}');
      if (userDataNotifier.value?.accountStep == 1) {
        print('🔄 [USER NAVIGATION] Navigating to VerifyEmailScreen');
        CustomNavigation.pushReplacement(
            // ignore: use_build_context_synchronously
            context: context,
            screen: const VerifyEmailScreen());
      } else if (userDataNotifier.value?.accountStep == 2) {
        print('🔄 [USER NAVIGATION] Navigating to GuideProfileSetupScreen');
        CustomNavigation.pushReplacement(
            // ignore: use_build_context_synchronously
            context: context,
            screen: const GuideProfileSetupScreen());
      } else if (userDataNotifier.value?.accountStep == 3 ||
          userDataNotifier.value?.accountStep == 4) {
        print('🔄 [USER NAVIGATION] Navigating to AdminApproveScreen');
        CustomNavigation.pushReplacement(
            // ignore: use_build_context_synchronously
            context: context,
            screen: const AdminApproveScreen());
      } else {
        print('🔄 [USER NAVIGATION] Navigating to GuideBottomBarScreen');
        getUserData();
        usertype = UserType.guide;
        bookingId = "";
        CustomNavigation.pushReplacement(
            context: context, screen: const GuideBottomBarScreen());
      }
    } else {
      print(
          '🔄 [USER NAVIGATION] User is STUDENT with account_step: ${userDataNotifier.value?.accountStep}');
      if (userDataNotifier.value?.accountStep == 1) {
        CustomNavigation.pushReplacement(
            context: context, screen: const VerifyEmailScreen());
      } else if (userDataNotifier.value?.accountStep == 2) {
        getUserData();
        DashBoardProvider dashBoardProvider =
            Provider.of<DashBoardProvider>(context, listen: false);
        usertype = UserType.student;
        dashBoardProvider.getStudentDashBoard();
        CustomNavigation.pushReplacement(
            context: context, screen: const BottomBarScreen());
      }
    }
  }

  List globalLanguages = [];
  String bannerTitle = "";
  String bannerSubtitle = "";
  List globalSpecialities = [];
  List globalUniversity = [];
  List globalDegreeTypes = [
    {"key": 'EdD'},
    {"key": 'Enrolled'},
    {"key": 'Graduate Coursework'},
    {"key": 'J.D.'},
    {"key": 'Master\'s'},
    {"key": 'MBA'},
    {"key": 'MD'},
    {"key": 'MEd'},
    {"key": 'PhD'},
    {"key": 'Other'},
  ];
  List globalCertificate = [
    {"key": 'Not Certified'},
    {"key": 'Planned'},
    {"key": 'Certified'},
    {"key": 'Certification Expired'},
  ];

  Future<void> getLanguages(
    BuildContext context,
  ) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getLanguages,
      request: {},
      apiMethod: ApiMethod.get,
    );
    if (jsonResponse.status == 1) {
      globalLanguages = jsonResponse.data;

      globalLanguages.sort((a, b) {
        if (a['language'].toString().trim().toLowerCase() == 'english')
          return -1;
        if (b['language'].toString().trim().toLowerCase() == 'english')
          return 1;
        return a['language'].compareTo(b['language']);
      });
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> getBanner(
    BuildContext context,
  ) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getBanner,
      request: {},
      apiMethod: ApiMethod.get,
    );
    if (jsonResponse.status == 1) {
      bannerTitle = jsonResponse.data[ApiKeys.title];
      bannerSubtitle = jsonResponse.data[ApiKeys.subtitle];
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> getSpecialities(
    BuildContext context,
  ) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getSpecialities,
      request: {},
      apiMethod: ApiMethod.get,
    );
    if (jsonResponse.status == 1) {
      globalSpecialities = jsonResponse.data;

      globalSpecialities.sort((a, b) => a['title'].compareTo(b['title']));
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> getAppSettings(
    BuildContext context,
  ) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.getAppSettings,
        request: {},
        apiMethod: ApiMethod.get,
        customHeaders: {
          "x-api-key": "YTJM5675MM6e5656SDGDF5ra1214er14wer64346rf"
        });
    print("app setting response :::::::${jsonResponse.data}");
    if (jsonResponse.status == 1) {
      myAppSettings = MyAppSettings.fromJson(jsonResponse.data);
      print("hjdshjhj${myAppSettings?.toJson()}");
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> getUniversity(
    BuildContext context,
  ) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getUniversity,
      request: {},
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      globalUniversity = jsonResponse.data;
      globalUniversity
          .sort((a, b) => a['university_name'].compareTo(b['university_name']));

      print("globalSpecialities::::::::$globalUniversity");
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> login(BuildContext context,
      {required String email,
      String? phoneWithCode,
      required String password}) async {
    EasyLoading.show();
    var request = {'password': password};
    if (phoneWithCode == null) {
      request[ApiKeys.email] = email;
    } else {
      request[ApiKeys.phone_with_code] = phoneWithCode;
    }

    var jsonResponse = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.login, request: request);
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(
          userData: jsonResponse.data[SharedPreferenceKeys.userData],
          token: jsonResponse.data[SharedPreferenceKeys.userToken]);
      UserModal userModal =
          UserModal.fromJson(jsonResponse.data[SharedPreferenceKeys.userData]);
      userDataNotifier.value = userModal;
      userToken = jsonResponse.data[SharedPreferenceKeys.userToken];
      // ignore: use_build_context_synchronously
      userNavigation(context);
    }
    EasyLoading.dismiss();
  }

  Future<void> signUp(BuildContext context,
      {required Map<String, dynamic> request, required String userType}) async {
    EasyLoading.show();

    // Check if email was pre-verified via OTP
    bool emailPreVerified = request['email_verified'] == true;

    ResponseModal response;
    if (userType == UserType.guide) {
      response = await NewestWebServices.getResponse(
          apiUrl: ApiUrls.signUpGuide,
          request: request,
          showSuccessMessage: !emailPreVerified);
    } else {
      response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.signUpStudent,
        request: request,
        showSuccessMessage: !emailPreVerified,
      );
    }

    if (response.status == 1) {
      Map<String, dynamic> userData =
          Map.from(response.data[SharedPreferenceKeys.userData]);

      // If email was verified via OTP, skip email verification screen for both guide and student
      if (emailPreVerified && userData['account_step'] == 1) {
        userData['account_step'] = userType == UserType.guide ? 2 : 2;
        print(
            '🔧 [SIGNUP] Email pre-verified via OTP - skipping verification screen');
      }

      await updateUserDataInSharedPreference(
          userData: userData,
          token: response.data[SharedPreferenceKeys.userToken]);
      UserModal userModal = UserModal.fromJson(userData);
      userDataNotifier.value = userModal;
      userToken = response.data[SharedPreferenceKeys.userToken];
      // ignore: use_build_context_synchronously
      userNavigation(context);
    }
    EasyLoading.dismiss();
  }

  Future<void> signUpStep2(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    print('\n🔵 [AUTH PROVIDER] signUpStep2 called');
    EasyLoading.show();
    ResponseModal response;

    print('📡 [API CALL] Sending request to: ${ApiUrls.signUpGuideStep2}');
    response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.signUpGuideStep2,
        request: request,
        showSuccessMessage: false);

    print('\n========================================');
    print('📥 BACKEND RESPONSE');
    print('========================================');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Data: ${response.data}');
    print('========================================\n');

    if (response.status == 1) {
      print('✅ API call successful');
      if (response.data is Map && response.data.containsKey('user_info')) {
        print('✅ Response contains user_info');
        print('📝 Updating user data in shared preferences...');
        await updateUserDataInSharedPreference(
            userData: response.data['user_info']);
        UserModal userModal = UserModal.fromJson(response.data['user_info']);
        userDataNotifier.value = userModal;
        print('✅ User data updated. Account step: ${userModal.accountStep}');
        showSnackbar("Profile updated successfully!");
        print('🔄 Navigating user...');
        userNavigation(context);
      } else {
        print('❌ Invalid response format - user_info not found');
        showSnackbar("Invalid response format from server");
      }
    } else {
      print('❌ API call failed with status: ${response.status}');
      showSnackbar(response.message ?? "Failed to update profile");
    }
    EasyLoading.dismiss();
    print('🔵 [AUTH PROVIDER] signUpStep2 completed\n');
  }

  Future<void> signUpStep3(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    ResponseModal response;
    response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.signUpGuideStep3,
        request: request,
        showSuccessMessage: false);
    if (response.status == 1) {
      print('Datadatatdat::::::${response.data}');
      await updateUserDataInSharedPreference(
          userData: response.data[SharedPreferenceKeys.userData],
          token: response.data[SharedPreferenceKeys.userToken]);
      UserModal userModal =
          UserModal.fromJson(response.data[SharedPreferenceKeys.userData]);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      userNavigation(context);
    }
    EasyLoading.dismiss();
  }

  Future<void> forgetPassword(BuildContext context,
      {required String email}) async {
    EasyLoading.show();
    var request = {
      'email': email,
    };
    var jsonResponse = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.forgetPassword,
        request: request,
        apiMethod: ApiMethod.post,
        showSuccessMessage: true);
    if (jsonResponse.status == 1) {
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    EasyLoading.dismiss();
  }

  Future<void> updateDeviceToken({required String token}) async {
    EasyLoading.show();
    var request = {
      ApiKeys.deviceToken: token,
    };
    var jsonResponse = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.updateDeviceToken,
        request: request,
        apiMethod: ApiMethod.post,
        showErrorMessage: false);

    EasyLoading.dismiss();
  }

  Future<void> resendEmail(BuildContext context,
      {required String email}) async {
    EasyLoading.show();
    var request = {
      'email': email,
    };

    var jsonResponse = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.resendEmail,
        request: request,
        apiMethod: ApiMethod.get,
        showSuccessMessage: true);
    if (jsonResponse.status == 1) {}
    EasyLoading.dismiss();
  }

  Timer? intervalTimer;
  ValueNotifier<int> unreadMessageCount = ValueNotifier(0);
  ValueNotifier<int> unreadNotificationsCount = ValueNotifier(0);

  Future<void> intervalFunction() async {
    try {
      NewestWebServices.getResponse(
              apiUrl: ApiUrls.interval,
              request: {},
              apiMethod: ApiMethod.get,
              showErrorMessage: false,
              showSuccessMessage: false)
          .then((jsonResponse) async {
        print("Datdatdatdatdat::::::::${jsonResponse.status}");
        print("Datdatdatdatdat::::::::${jsonResponse.data}");
        if (jsonResponse.status == 1) {
          if (jsonResponse.data[ApiKeys.accountStep] != null &&
              jsonResponse.data[ApiKeys.accountStep] !=
                  userDataNotifier.value?.accountStep) {
            userDataNotifier.value?.accountStep =
                jsonResponse.data[ApiKeys.accountStep];
            await updateUserDataInSharedPreference(
                userData: userDataNotifier.value?.toJson() ?? {});
            userNavigation(MyGlobalKeys.navigatorKey.currentContext!);
          }

          if (jsonResponse.data[ApiKeys.userDeleteStatus] == 1) {
            intervalTimer?.cancel();
            showSnackbar(
                "Your profile has been deleted by the admin. For more information, please contact our support team.");
            logout(MyGlobalKeys.navigatorKey.currentContext!);
            return;
          }

          if (jsonResponse.data[ApiKeys.userStatus] == 1) {
            unreadMessageCount.value = int.tryParse(jsonResponse
                    .data[ApiKeys.unreadMessagesCount]
                    .toString()) ??
                0;
            unreadNotificationsCount.value = int.tryParse(jsonResponse
                    .data[ApiKeys.unreadNotificationsCount]
                    .toString()) ??
                0;
            notifyListeners();
            print("NOTIFICATION COUNT ISISISIISISIS${jsonResponse.data}");
            print(
                "NOTIFICATION COUNT ISISISIISISIS${jsonResponse.data[ApiKeys.unreadNotificationsCount]}");
            print(
                "NOTIFICATION COUNT ISISISIISISIS${int.tryParse(jsonResponse.data[ApiKeys.unreadNotificationsCount].toString())}");
            print(
                "NOTIFICATION COUNT ISISISIISISIS${unreadNotificationsCount.value}");
            print("MESSAGE COUNT ISISISIISISIS${unreadMessageCount.value}");
          } else {
            intervalTimer?.cancel();
            showSnackbar(
                "Your profile is temporarily blocked by the admin. For more information, please contact our support team.");
            logout(MyGlobalKeys.navigatorKey.currentContext!);
          }
        }
      });
    } catch (e) {
      intervalTimer?.cancel();
      showSnackbar("Session expired");
      //showSnackbar("Your profile has been deleted by the admin. For more information, please contact our support team.");
      logout(MyGlobalKeys.navigatorKey.currentContext!);
    }
  }

  Future<void> intervalProviderToCheckBlockStatus() async {
    intervalFunction();
    intervalTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      intervalFunction();
    });
  }

  Future<void> changePassword(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.changePassword,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (response.status == 1) {
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    EasyLoading.dismiss();
  }

  Future<void> editProfileImage(BuildContext context,
      {required Map<String, dynamic> request, required String userType}) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: userType == UserType.guide
          ? ApiUrls.editProfileImage
          : ApiUrls.editProfileImageStudent,
      request: request,
      apiMethod: userType == UserType.guide ? ApiMethod.get : ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(
        userData: jsonResponse.data,
      );
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editBasicDetail(BuildContext context,
      {required Map<String, dynamic> request, required String userType}) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: userType == UserType.guide
          ? ApiUrls.editBasicDetail
          : ApiUrls.editBasicDetailStudent,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editSkillsDetail(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateSkills,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editPolicy(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updatePolicies,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editAddress(
    BuildContext context, {
    required Map<String, dynamic> request,
    required String userType,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: userType == UserType.guide
          ? ApiUrls.updateAddress
          : ApiUrls.updateAddressStudent,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editLanguage(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateLanguage,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editUniversity(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateUniversity,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editEducation(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateEducation,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editVideo(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateVideos,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> deleteVideo(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.deleteVideo,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await getUserData();
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> editSchedule(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateSchedule,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await updateUserDataInSharedPreference(userData: jsonResponse.data);
      UserModal userModal = UserModal.fromJson(jsonResponse.data);
      userDataNotifier.value = userModal;
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<Map<String, dynamic>?> getTutorProfile() async {
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getTutorProfile,
      request: {},
      apiMethod: ApiMethod.get,
      showErrorMessage: false,
    );
    if (jsonResponse.status == 1) {
      return jsonResponse.data;
    }
    return null;
  }

  Future<void> updateTutorProfile(
    BuildContext context, {
    required Map<String, dynamic> request,
  }) async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.updateTutorProfile,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await getUserData();
      // ignore: use_build_context_synchronously
      CustomNavigation.pop(context);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> deleteUser() async {
    EasyLoading.show();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.deleteUser,
      request: {},
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );
    if (jsonResponse.status == 1) {
      await logout(MyGlobalKeys.navigatorKey.currentContext!);
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<void> logoutPopup(context) async {
    await showCommonAlertDailog(
      context,
      imageUrl: MyImagesUrl.logout,
      headingText: 'Are you sure?',
      message: 'You want to Logout',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Cancel",
              isSolid: false,
              width: 100,
              onTap: () {
                CustomNavigation.pop(context);
              },
            ),
            hSizedBox2,
            CustomButton(
                text: 'Logout',
                width: 100,
                onTap: () async {
                  logout(context);
                }),
            hSizedBox,
          ],
        ),
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    EasyLoading.show();
    CustomNavigation.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context: context,
        screen: const LoginPage());
    unreadMessageCount.value = 0;
    unreadNotificationsCount.value = 0;
    intervalTimer?.cancel();

    BottomTabBarProvider bottomTabBarProvider =
        Provider.of<BottomTabBarProvider>(context, listen: false);
    bottomTabBarProvider.changeIndex(index: 0);

    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.reset();

    SearchGuideProvider searchGuideProvider =
        Provider.of<SearchGuideProvider>(context, listen: false);
    searchGuideProvider.resetAllValues();

    BookGuideProvider bookGuideProvider =
        Provider.of<BookGuideProvider>(context, listen: false);
    bookGuideProvider.reset();

    DashBoardProvider dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
    dashBoardProvider.reset();

    SessionsProvider sessionsProvider =
        Provider.of<SessionsProvider>(context, listen: false);
    sessionsProvider.reset();

    InstantBookingProvider instantBookingProvider =
        Provider.of<InstantBookingProvider>(context, listen: false);
    instantBookingProvider.reset();

    StudentGuideProvider studentGuideProvider =
        Provider.of<StudentGuideProvider>(context, listen: false);
    studentGuideProvider.reset();

    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.reset();

    WithdrawProvider withdrawProvider =
        Provider.of<WithdrawProvider>(context, listen: false);
    withdrawProvider.reset();

    RecordingProvider recordingProvider =
        Provider.of<RecordingProvider>(context, listen: false);
    recordingProvider.reset();

    if (userDataNotifier.value != null) {
      await updateDeviceToken(
        token: '',
      );
    }

    userDataNotifier.value = null;
    await SharedPreferenceServices.clearSharedPreference();
    // ignore: use_build_context_synchronously
    EasyLoading.dismiss();
  }

  Future<void> deletePopup(context) async {
    await showCommonAlertDailog(
      context,
      imageUrl: MyImagesUrl.delete,
      imageColor: MyColors.redColor,
      // icon: const Icon(
      //   Icons.delete,
      //   color: MyColors.redColor,
      // ),
      headingText: 'Are you sure?',
      message: 'You want to delete this account.',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Cancel",
              isSolid: false,
              width: 100,
              onTap: () {
                CustomNavigation.pop(context);
              },
            ),
            hSizedBox2,
            CustomButton(
                text: 'Delete',
                width: 100,
                onTap: () async {
                  deleteUser();
                }),
            hSizedBox,
          ],
        ),
      ],
    );
  }

  void reload() {
    notifyListeners();
  }

  Future<void> shareApp(BuildContext context) async {
    // String link = Platform.isIOS
    //     ? "https://apps.apple.com/us/app/quadsu/id6737334148"
    //     : "https://play.google.com/store/apps/details?id=com.quadsu.app";

    const String appStoreLink =
        "https://apps.apple.com/us/app/quadsu/id6737334148";
    const String playStoreLink =
        "https://play.google.com/store/apps/details?id=com.quadsu.app";

    String message = """
  Download the Quadsu app:
  - For iOS (App Store): $appStoreLink
  - For Android (Play Store): $playStoreLink
  """;
    await Share.share(message);
  }
}
// import 'dart:async';
// import 'package:provider/provider.dart';
// import 'package:quadsu_app/provider/app_language_provider.dart';
// import 'package:quadsu_app/services/firebase_services/firebase_push_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/global_data.dart';
// import '../constants/my_colors.dart';
// import '../constants/my_image_url.dart';
// import '../constants/shared_preference_keys.dart';
// import '../constants/sized_box.dart';
// import '../constants/types/user_type.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert' as convert;
// import '../functions/print_function.dart';
// import '../modal/user_modal.dart';
// import '../services/api_urls.dart';
// import '../services/custom_navigation_services.dart';
// import '../services/firebase_push_notifications.dart';
// import '../widget/common_alert_dailog.dart';
// import '../widget/show_snackbar.dart';
// import 'bottom_tabbar_provider.dart';
//
// class AuthProvider extends ChangeNotifier {
//   bool load = false;
//   // ValueNotifier<int> selectedLanguage = ValueNotifier(0);
//
//   void showLoading() {
//     load = true;
//     notifyListeners();
//   }
//
//   void hideLoading() {
//     load = false;
//     notifyListeners();
//   }
//
//   void userNavigationAfterLogin(BuildContext context) {
//     FirebasePushNotifications.updateDeviceToken();
//     // if(userDataNotifier.value?.firstName==null || userDataNotifier.value?.userType==null){
//     //  // CustomNavigation.pushAndRemoveUntil(context: context, screen: SignupScreen(userType: UserType.driver));
//     //   // CustomNavigation.pushAndRemoveUntil(context: context, screen: PreSignUpScreen());
//     // }else
//     // if(userDataNotifier.value?.userType==UserType.driver && userDataNotifier.value?.verification_status==0){
//     //   CustomNavigation.pushAndRemoveUntil(context: context, screen: PendingVerificationScreen());
//     // }
//     // else{
//     //   CustomNavigation.pushAndRemoveUntil(context: context, screen: const BottomBarScreen());
//     // }
//   }
//
//   Future<void> splashAuthentication(context) async {
//     // await Firebase.initializeApp(
//     //   options: DefaultFirebaseOptions.currentPlatform,
//     // );
//     await FirebasePushNotifications.initializeFirebaseNotifications();
//     //var adminSettingsProvider =
//     //    Provider.of<AdminSettingsProvider>(context, listen: false);
//     //await AdminSettingsProvider.updateDefaultAppSettingsToFirebase();
//     //await adminSettingsProvider.getDefaultAppSettings();
//
//     sharedPreference = await SharedPreferences.getInstance();
//     var appLanguageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
//     appLanguageProvider.initializeLanguage();
//    UserModal? result = await isLoggedIn();
//
//     if (result != null) {
//
//
//       userNavigationAfterLogin(context);
//     } else {
//       //CustomNavigation.pushAndRemoveUntil(context: context, screen: const IntroScreen());
//     }
//     // showSnackbar('hello world pushed');
//     FirebasePushNotifications.handleNotificationsIfAppIsKilled();
//   }
//
//   Future<UserModal?> isLoggedIn() async {
//     String? userDataString =
//     sharedPreference.getString(SharedPreferenceKeys.userData);
//     if (userDataString != null) {
//       Map<String, dynamic> userData = convert.jsonDecode(userDataString);
//       userToken = sharedPreference.getString(SharedPreferenceKeys.userToken);
//       userDataNotifier.value = UserModal.fromJson(userData);
//       await updateUserData();
//       return userDataNotifier.value;
//     } else {
//       return null;
//     }
//   }
//
//   Future<void> updateUserDataInSharedPreference(
//       {required Map userData, String? token}) async {
//     String userDataString = convert.jsonEncode(userData);
//     userDataNotifier.value = UserModal.fromJson(userData);
//     await sharedPreference.setString(
//         SharedPreferenceKeys.userData, userDataString);
//     if (token != null) {
//       userToken = token;
//       await sharedPreference.setString(SharedPreferenceKeys.userToken, token);
//     }
//   }
//
//   Future<void> updateUserData() async {
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiMethod: ApiMethod.get,
//         apiUrl: ApiUrls.getUserDetails,
//         request: {},
//         showSuccessMessage: false);
//     if (jsonResponse.status == 1) {
//       updateUserDataInSharedPreference(
//         userData: jsonResponse.data['user_info'],
//       );
//     }
//   }
//
//   Future<void> login(BuildContext context,
//       {required String email, String? phoneWithCode, required String password}) async {
//     showLoading();
//     var request = {'password': password};
//
//     if(phoneWithCode==null){
//       request[ApiKeys.email] = email;
//     }else{
//       request[ApiKeys.phone_with_code] = phoneWithCode;
//     }
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.login, request: request);
//     if (jsonResponse.status == 1) {
//       await updateUserDataInSharedPreference(
//           userData: jsonResponse.data[ApiKeys.user_info],
//           token: jsonResponse.data['token']);
//       // ignore: use_build_context_synchronously
//       userNavigationAfterLogin(context);
//     }
//     hideLoading();
//   }
//
//   Future<void> signup(BuildContext context,
//       {required Map<String, dynamic> request}) async {
//     showLoading();
//
//     var response = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.getOtp, request: request, load: true);
//
//     if (response.status == 1) {
//       hideLoading();
//       bool? result = await CustomNavigation.push(
//           context: context,
//           screen: VerifyScreen(
//             correctOtp: response.data['otp'].toString(),
//             phone: request[ApiKeys.phone],
//             phoneCode: request[ApiKeys.phoneCode],
//           ));
//
//       if(result==true){
//         showLoading();
//         var jsonResponse = await NewestWebServices.getResponse(
//             apiUrl: ApiUrls.signup, request: request);
//         if (jsonResponse.status == 1) {
//           await updateUserDataInSharedPreference(
//               userData: jsonResponse.data[ApiKeys.user_info],
//               token: jsonResponse.data['token']);
//
//           // showSuccesfulRegistration();
//           // ignore: use_build_context_synchronously
//           userNavigationAfterLogin(context);
//         }
//       }else{
//
//       }
//     }
//
//     hideLoading();
//   }
//
//   Future showSuccesfulRegistration()async{
//     return  showSuccessPopup(
//       context: MyGlobalKeys.navigatorKey.currentContext!,
//       heading: "Congratulations!!",
//       subtitle:
//       "Your Registration has been completed Successfully. Admin will check your documents and will get back to you in 3-4 business days",
//       bottomWidget: Center(
//         child: RoundEdgedButton(
//           text: "OK",
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           height: 50,
//           width: 90,
//           borderRadius: 10,
//           onTap: () {
//             // userType = UserTypeData.Driver;
//             // pushAndRemoveUntil(
//             //     context: MyGlobalKeys.navigatorKey.currentContext!,
//             //     screen: const BottomBarScreen());
//           },
//         ),
//       ),
//     );
//   }
//
//
//
//   Future<bool> checkUniqueness(BuildContext context,
//       {required String email, required String phoneNumberWithCode}) async {
//     showLoading();
//     var request = {ApiKeys.email: email, ApiKeys.phone_with_code: phoneNumberWithCode};
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.checkPhoneEmailUniqueness, request: request);
//     if (jsonResponse.status == 1) {
//       hideLoading();
//       return true;
//     }
//     hideLoading();
//     return false;
//
//   }
//
//
//
//
//   getCategoriesAndSubCategories()async{
//     var response =await NewestWebServices.getResponse(apiUrl: ApiUrls.getVehicleTypeList, request: {}, apiMethod: ApiMethod.get);
//     if(response.status==1){
//       globalCategoriesList = response.data[ApiKeys.data];
//     }
//
//     var subresponse =await NewestWebServices.getResponse(apiUrl: ApiUrls.getVehicleModelList, request: {}, apiMethod: ApiMethod.get);
//     if(subresponse.status==1){
//       globalSubCategoriesList = subresponse.data[ApiKeys.data];
//     }
//     notifyListeners();
//     // globalCategoriesList =
//   }
//
//
//   getPackageType()async{
//     var response =await NewestWebServices.getResponse(apiUrl: ApiUrls.getPackageTypeList, request: {}, apiMethod: ApiMethod.get);
//     if(response.status==1){
//       globalPackageTypeList = response.data[ApiKeys.data];
//     }
//
//     notifyListeners();
//     // globalCategoriesList =
//   }
//
//
//   Future<void> forgetPassword(BuildContext context,
//       {required String email}) async {
//     showLoading();
//     var request = {
//       'email': email,
//     };
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.forgetPassword,
//         request: request,
//         apiMethod: ApiMethod.post,
//         load: true);
//     if (jsonResponse.status == 1) {
//       // ignore: use_build_context_synchronously
//       popPage(context: context);
//       showSnackbar(jsonResponse.message);
//     }
//     hideLoading();
//   }
//
//   Timer? intervalTimer;
//
//
//
//   ValueNotifier<int> unreadMessageCount = ValueNotifier(0);
//   ValueNotifier<int> unreadNotificationsCount = ValueNotifier(0);
//
//
//
//   intervalFunction()async{
//     var locationProvider = Provider.of<MyLocationProvider>(MyGlobalKeys.navigatorKey.currentContext!, listen: false);
//     try{
//       Map<String, dynamic> request = {
//
//       };
//       if(locationProvider.latitude!=0){
//         request['latitude'] = locationProvider.latitude;
//         request['longitude'] = locationProvider.longitude;
//         request[ApiKeys.userType] = userDataNotifier.value?.userType;
//       }
//       try{
//         var shipmentProvider = Provider.of<ShipmentProvider>(MyGlobalKeys.navigatorKey.currentContext!, listen: false);
//         if(shipmentProvider.runningShipment!=null){
//           request[ApiKeys.shipment_id] = shipmentProvider.runningShipment!.id;
//
//           // try{
//           //   runningshipmentprovider.updateShipmentDataAndDriverPolyLine();
//           //
//           // }catch(e){
//           //   print('sfdsdaf');
//           // }
//         }
//       }catch(e){
//         print('Error in catch block... there is some error in running shipment 3456 $e');
//       }
//       NewestWebServices.getResponse(showLogs: false,apiUrl: ApiUrls.interval, request: request, apiMethod: ApiMethod.put).then((value){
//         if(value.status==1){
//           // var bookingProvider =
//           // Provider.of<BookingProvider>(MyGlobalKeys.navigatorKey.currentContext!,
//           //     listen: false);
//           Map? bookingMap =value.data['latest_bookings'];
//           if(bookingMap!=null){
//             //   myCustomPrintStatement('The user has a new booking ... ${bookingProvider.hasNoBooking.value}  .... ${bookingProvider.isBookingDialogOpen}: ${bookingMap}');
//             //   bookingProvider.hasNoBooking.value = false;
//             //   if(bookingProvider.isBookingDialogOpen == false){
//             //     // bookingProvider.isBookingDialogOpen = true;
//             //     print('opening booking dialog');
//             //     BookingModal bookingModal = BookingModal.fromJson(bookingMap);
//             //     bookingProvider.showBookingPopup(bookingModal);
//             //   }
//           }else{
//             myCustomPrintStatement('The user has no booking');
//             // bookingProvider.hasNoBooking.value = true;
//             // bookingProvider.isBookingDialogOpen = false;
//           }
//           if(value.data['user_status']==1){
//             // unreadMessageCount.value = value.data['unread_message_count'];
//             unreadNotificationsCount.value = value.data['unread_notification_count'];
//
//           }
//           if(value.data['user_status']==2){
//             showSnackbar(value.message);
//             intervalTimer?.cancel();
//             logout(MyGlobalKeys.navigatorKey.currentContext!);
//           }
//
//         }else
//         if(value.data['user_status']==2){
//           showSnackbar(value.message);
//           intervalTimer?.cancel();
//           logout(MyGlobalKeys.navigatorKey.currentContext!);
//         }
//       });
//
//     }catch(e){
//
//     }
//   }
//   intervalProviderToCheckBlockStatus()async{
//
//
//
//     intervalFunction();
//     intervalTimer?.cancel();
//     intervalTimer = Timer.periodic(Duration(seconds: 15), (timer) {
//       intervalFunction();
//     });
//
//   }
//   // Future<void> intervalProviderToCheckBlockStatus() async {
//   //   intervalTimer?.cancel();
//   //   intervalTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//   //     NewestWebServices.getResponse(
//   //             apiUrl: ApiUrls.interval, request: {}, apiMethod: ApiMethod.put)
//   //         .then((value) {
//   //       if (value.data['status'] != 1) {
//   //         showSnackbar(value.message);
//   //         intervalTimer?.cancel();
//   //         logout(MyGlobalKeys.navigatorKey.currentContext!);
//   //       }
//   //     });
//   //   });
//   // }
//
//
//   /// commented to check 21/5/24 uncomment in the end
//   // Future<void> clickOnProfileMenu(
//   //     {required int index, required BuildContext context}) async {
//   //   if (userDataNotifier.value!.userType == UserType.company) {
//   //     if (index == 0) {
//   //       if (userDataNotifier.value!.userType == UserType.user) {
//   //         push(context: context, screen: const UserProfileScreen());
//   //       } else if (userDataNotifier.value!.userType == UserType.driver) {
//   //         push(context: context, screen: const DriverProfileScreen());
//   //       } else {
//   //         push(context: context, screen: const UserProfileScreen());
//   //       }
//   //     } else if (index == 1) {
//   //       push(context: context, screen: const ChangePassScreen());
//   //     } else if (index == 2) {
//   //       await languageBottomsheet(context: context);
//   //     } else if (index == 3) {
//   //       push(context: context, screen: const ContactUsScreen());
//   //     } else if (index == 4) {
//   //       push(context: context, screen: const TermsAndConditionsPage());
//   //     } else if (index == 5) {
//   //       push(context: context, screen: const PrivacyNewPage());
//   //     } else if (index == 6) {
//   //       logoutPopup(context);
//   //     }
//   //   } else {
//   //     if (index == 0) {
//   //       if (userDataNotifier.value!.userType == UserType.user) {
//   //         push(context: context, screen: const UserProfileScreen());
//   //       } else if (userDataNotifier.value!.userType ==UserType.driver) {
//   //         push(context: context, screen: const DriverProfileScreen());
//   //       } else {
//   //         push(context: context, screen: const UserProfileScreen());
//   //       }
//   //     } else if (index == 1) {
//   //       push(context: context, screen: const ChangePassScreen());
//   //     } else if (index == 2) {
//   //       push(context: context, screen: const PaymentMethodScreen());
//   //     } else if (index == 3) {
//   //       await languageBottomsheet(context: context);
//   //     } else if (index == 4) {
//   //       push(context: context, screen: const ContactUsScreen());
//   //     } else if (index == 5) {
//   //       push(context: context, screen: const TermsAndConditionsPage());
//   //     } else if (index == 6) {
//   //       push(context: context, screen: const PrivacyNewPage());
//   //     } else if (index == 7) {
//   //       logoutPopup(context);
//   //     }
//   //   }
//   // }
//
//   Future<bool> editProfileFunction({
//     required BuildContext context,
//     required Map<String, dynamic> request,
//     Map<String, dynamic>? files,
//   }) async {
//     showLoading();
//     ResponseModal response;
//
//     if (files == null) {
//       response = await NewestWebServices.getResponse(
//           apiUrl: ApiUrls.editProfile,
//           request: request,
//           apiMethod: ApiMethod.put,
//           showSuccessMessage: true);
//     } else {
//       print('the files are ${files}');
//       for(int i = 0;i<files.keys.length;i++){
//         // print('the files is ${files.keys.toList()[i]}');
//
//         request[files.keys.toList()[i]] = await NewestWebServices.uploadImageAndGetUrl(files[files.keys.toList()[i]].path);
//       }
//       // dead;
//       response = await NewestWebServices.getResponse(
//           apiUrl: ApiUrls.editProfile,
//           request: request,
//           apiMethod: ApiMethod.put,
//           showSuccessMessage: true);
//       // response = await NewestWebServices.postDataWithImageFunction(
//       //     apiUrl: ApiUrls.editProfile,
//       //     body: request,
//       //     files: files,
//       //     apiMethod: ApiMethod.post,
//       //     showSuccessMessage: true);
//     }
//
//     if (response.status == 1) {
//       FirebasePushNotifications.updateDeviceToken();
//       updateUserDataInSharedPreference(
//           userData: response.data[ApiKeys.user_info]);
//       // ignore: use_build_context_synchronously
//       popPage(context: context);
//       hideLoading();
//       return true;
//     }
//
//     hideLoading();
//     return false;
//   }
//
//   Future<void> changePassword(
//       BuildContext context, {
//         required Map<String, dynamic> request,
//       }) async {
//     showLoading();
//     var response = await NewestWebServices.getResponse(
//       apiUrl: ApiUrls.changePassword,
//       request: request,
//       apiMethod: ApiMethod.patch,
//       showSuccessMessage: true,
//     );
//     if (response.status == 1) {
//       // ignore: use_build_context_synchronously
//       popPage(context: context);
//     }
//     hideLoading();
//   }
//
//   Future<void> languageBottomsheet({required BuildContext context}) async {
//     await customBottomSheet(
//       context,
//       child: Consumer<AppLanguageProvider>(
//           builder: (context, appLanguageProvider, child) {
//             return SizedBox(
//               width: double.infinity,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   vSizedBox,
//                   for(int i = 0;i<languagesList.length;i++)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: CustomGestureDetector(
//                           onTap: () {
//                             appLanguageProvider.changeAppLanguage(languagesList[i]);
//                           },
//                           borderRadiusDouble: 15,
//                           child: commonContainer(
//                               selected: selectedLanguageNotifier==languagesList[i], value: languagesList[i]['value'])),
//                     ),
//                   // vSizedBox,
//                   // CustomGestureDetector(
//                   //   onTap: () {
//                   //     selectedLanguage.value = 1;
//                   //   },
//                   //   borderRadius: 15,
//                   //   child: commonContainer(
//                   //       selected: selectedValue == 1, value: "Arabic"),
//                   // ),
//                   // vSizedBox,
//                   RoundEdgedButton(
//                     text: "Update",
//                     onTap: () {
//                       popPage(context: context);
//                     },
//                     verticalMargin: 10,
//                     fontSize: 18,
//                     borderRadius: 15,
//                     fontWeight: FontWeight.w700,
//                     color: MyColors.primaryColor,
//                   ),
//                 ],
//               ),
//             );
//           }),
//       isHorizontalPadding: false,
//     );
//   }
//
//   Widget commonContainer({required bool selected, required String value}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: globalHorizontalPadding, vertical: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: MyColors.blackColor50,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           MainHeadingText(
//             value,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//           if (selected)
//             const Icon(
//               Icons.check_circle_sharp,
//               color: MyColors.primaryColor,
//             )
//           else
//             Container(
//               height: 18,
//               width: 18,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1, color: MyColors.blackColor50)),
//             )
//         ],
//       ),
//     );
//   }
//
//   Future<void> contactUs(
//       BuildContext context, {
//         required Map<String, dynamic> request,
//       }) async {
//     showLoading();
//     var jsonResponse = await NewestWebServices.getResponse(
//       apiUrl: ApiUrls.contactUs,
//       request: request,
//       showSuccessMessage: true,
//     );
//     if (jsonResponse.status == 1) {
//       // ignore: use_build_context_synchronously
//       popPage(context: context);
//     }
//     hideLoading();
//   }
//
//   Future<void> logoutPopup(context) async {
//     await showCommonAlertDailog(
//       context,
//       imageUrl: MyImagesUrl.logoutIcon,
//       headingText: 'Are you sure?',
//       message: 'You want to Logout',
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             RoundEdgedButton(
//               text: "Cancel",
//               color: MyColors.primaryColor,
//               isSolid: false,
//               width: 100,
//               height: 40,
//               onTap: () {
//                 popPage(context: context);
//               },
//             ),
//             hSizedBox2,
//             RoundEdgedButton(
//                 text: 'Logout',
//                 width: 100,
//                 height: 40,
//                 onTap: () async {
//                   logout(context);
//                 }),
//             hSizedBox,
//           ],
//         ),
//       ],
//     );
//   }
//
//   Future<void> logout(BuildContext context) async {
//     sharedPreference.clear();
//     intervalTimer?.cancel();
//     Provider.of<BottomTabBarProvider>(context, listen: false)
//         .changeIndex(index: 0);
//     Provider.of<ShipmentProvider>(context, listen: false)
//         .cancelShipmentsUpdateTimer();
//     userDataNotifier.value = null;
//     pushAndRemoveUntil(context: context, screen: const IntroScreen());
//   }
// }
