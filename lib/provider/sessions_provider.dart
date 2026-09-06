import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/functions/print_function.dart';
import 'package:quadsu_app/modal/session_model.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/pay_pal_service.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';

import '../constants/my_colors.dart';

class SessionsProvider extends ChangeNotifier {
  bool allSessionsRefresh = false;
  bool runningSessionsRefresh = false;
  bool completedSessionsRefresh = false;
  bool cancelledSessionsRefresh = false;

  int allSessionsOffset = 1;
  int runningSessionsOffset = 1;
  int completedSessionsOffset = 1;
  int cancelledSessionsOffset = 1;

  bool allSessionsLoad = false;
  bool runningSessionsLoad = false;
  bool completedSessionsLoad = false;
  bool cancelledSessionsLoad = false;

  bool isLastAllSessions = false;
  bool isLastRunningSessions = false;
  bool isLastCompletedSessions = false;
  bool isLastCanceledSessions = false;

  List<Session> allSessions = [];
  List<Session> runningSessions = [];
  List<Session> completedSessions = [];
  List<Session> canceledSessions = [];

  SessionModel? allSessionsModel;
  SessionModel? runningSessionsModel;
  SessionModel? completedSessionsModel;
  SessionModel? cancelledSessionsModel;

  void reset() {
    allSessionsRefresh = false;
    runningSessionsRefresh = false;
    completedSessionsRefresh = false;
    cancelledSessionsRefresh = false;

    allSessionsOffset = 1;
    runningSessionsOffset = 1;
    completedSessionsOffset = 1;
    cancelledSessionsOffset = 1;

    allSessionsLoad = false;
    runningSessionsLoad = false;
    completedSessionsLoad = false;
    cancelledSessionsLoad = false;

    isLastAllSessions = false;
    isLastRunningSessions = false;
    isLastCompletedSessions = false;
    isLastCanceledSessions = false;

    allSessions = [];
    runningSessions = [];
    completedSessions = [];
    canceledSessions = [];

    allSessionsModel = null;
    runningSessionsModel = null;
    completedSessionsModel = null;
    cancelledSessionsModel = null;
  }

  getSession({required int sessionStatus}) async {
    startGettingSessions(sessionStatus: sessionStatus);
    notifyListeners();

    // Debug logging
    String apiUrl = usertype == UserType.student
        ? ApiUrls.getSessionsStudent
        : ApiUrls.getSessionsGuide;
    print("DEBUG: Fetching sessions from: $apiUrl");
    print("DEBUG: User token: ${userToken != null ? 'Present' : 'Missing'}");
    print("DEBUG: Session status: $sessionStatus");
    print("DEBUG: Page offset: ${getOffset(sessionStatus: sessionStatus)}");

    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: apiUrl,
      request: {
        ApiKeys.page: getOffset(sessionStatus: sessionStatus),
        ApiKeys.sessionStatus: sessionStatus
      },
      apiMethod: ApiMethod.get,
    );

    print("DEBUG: API Response Status: ${jsonResponse.status}");
    print("DEBUG: API Response Message: ${jsonResponse.message}");
    print("DEBUG: API Response Data: ${jsonResponse.data}");

    if (jsonResponse.status == 1) {
      print("SUCCESS: Session data received: ${jsonResponse.data}");

      if (getOffset(sessionStatus: sessionStatus) == 1) {
        changeSessionIsLast(sessionStatus: sessionStatus);
        notifyListeners();
        SessionModel? sessionModel = SessionModel.fromJson(jsonResponse.data);
        assignModel(sessionStatus: sessionStatus, sessionModel: sessionModel);
        insertSessions(
            sessionStatus: sessionStatus, data: sessionModel.sessions);
        print("DEBUG: Inserted ${sessionModel.sessions.length} sessions");
      } else {
        SessionModel? sessionModel = SessionModel.fromJson(jsonResponse.data);
        assignModel(sessionStatus: sessionStatus, sessionModel: sessionModel);
        if (sessionModel.sessions.isNotEmpty == true) {
          addSessions(
              sessionStatus: sessionStatus, data: sessionModel.sessions);
          changeSessionIsLast(sessionStatus: sessionStatus);
          notifyListeners();
          print("DEBUG: Added ${sessionModel.sessions.length} more sessions");
        } else {
          changeSessionIsLast(sessionStatus: sessionStatus, value: true);
          print("DEBUG: No more sessions to load");
        }
      }
    } else {
      print("ERROR: Failed to fetch sessions - ${jsonResponse.message}");
      print("ERROR Details: ${jsonResponse.error}");
        }

    EasyLoading.dismiss();
    changeSessionLoad(sessionStatus: sessionStatus);
    notifyListeners();
  }

  cancelSession(
      {required Map<String, dynamic> request,
      required String trxId,
      required double amount}) async {
    EasyLoading.show();
    notifyListeners();
    String? accessToken = await generatePaypalAccessToken();
    print("datdtadtaTOKEN   ::::$accessToken");
    print("datdtadtaTRXID   ::::$trxId");

    if (accessToken != null && trxId.isNotEmpty) {
      final transactionDetails =
          await getCaptureIdFromPayment(accessToken, trxId);
      myCustomLogStatements("transection $transactionDetails");

      if (transactionDetails != null) {
        print("datdtadtaCAPTUREID   ::::$transactionDetails");
        print("datdtadtaCAPTUREID   ::::$amount");
        final refundResponse = await refundPayment(
            accessToken,
            transactionDetails,
            amount,
            request['booking_id'],
            request['cancel_reason']);

        print("datdtadtaRefund   ::::$refundResponse");

        if (refundResponse != null && refundResponse['status'] == 'COMPLETED') {
          final refundId = refundResponse['id'];

          if (refundId != null) {
            request['refund_id']=refundId;
            var jsonResponse = await NewestWebServices.getResponse(
                apiUrl: ApiUrls.cancelBooking,
                request: request,
                apiMethod: ApiMethod.post,
                showSuccessMessage: true);

            if (jsonResponse.status == 1) {
              print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");
            }
          } else {
            showSnackbar('Refund failed');
          }
          print('Refund successful! Refund ID: $refundId');
        } else {
          showSnackbar('Refund failed');
        }
      } else {
        showSnackbar('Transaction not found');
      }
    } else {
      showSnackbar('Something wen wrong');
    }

    EasyLoading.dismiss();
    notifyListeners();
  }


  void rateSession({required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();

    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.rateBooking,
      request: request,
      apiMethod: ApiMethod.post,
    );

    if (jsonResponse.status == 1) {
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");
      CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
      resetOffset(sessionType: SessionStatus.all);
      getSession(sessionStatus: SessionStatus.all);
      resetOffset(sessionType: SessionStatus.completed);
      getSession(sessionStatus: SessionStatus.completed);
    }

    EasyLoading.dismiss();
    notifyListeners();
  }

  void startGettingSessions({required int sessionStatus}) {
    if (sessionStatus == SessionStatus.all) {
      allSessionsLoad = true;
      if (allSessionsOffset == 1 && allSessionsRefresh == false) {
        EasyLoading.show();
      }
    } else if (sessionStatus == SessionStatus.running) {
      runningSessionsLoad = true;
      if (runningSessionsOffset == 1 && runningSessionsRefresh == false) {
        EasyLoading.show();
      }
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessionsLoad = true;
      if (completedSessionsOffset == 1 && completedSessionsRefresh == false) {
        EasyLoading.show();
      }
    } else {
      cancelledSessionsLoad = true;
      if (cancelledSessionsOffset == 1 && cancelledSessionsRefresh == false) {
        EasyLoading.show();
      }
    }
  }

  int getOffset({required int sessionStatus}) {
    if (sessionStatus == SessionStatus.all) {
      return allSessionsOffset;
    } else if (sessionStatus == SessionStatus.running) {
      return runningSessionsOffset;
    } else if (sessionStatus == SessionStatus.completed) {
      return completedSessionsOffset;
    } else {
      return cancelledSessionsOffset;
    }
  }

  void assignModel(
      {required int sessionStatus, required SessionModel? sessionModel}) {
    if (sessionStatus == SessionStatus.all) {
      allSessionsModel = sessionModel;
    } else if (sessionStatus == SessionStatus.running) {
      runningSessionsModel = sessionModel;
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessionsModel = sessionModel;
    } else {
      cancelledSessionsModel = sessionModel;
    }
  }

  void insertSessions(
      {required int sessionStatus, required List<Session> data}) {
    if (sessionStatus == SessionStatus.all) {
      allSessions = List.from(data);
    } else if (sessionStatus == SessionStatus.running) {
      runningSessions = List.from(data);
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessions = List.from(data);
    } else {
      canceledSessions = List.from(data);
    }
  }

  void addSessions({required int sessionStatus, required List<Session> data}) {
    if (sessionStatus == SessionStatus.all) {
      allSessions = List.from(allSessions + data);
    } else if (sessionStatus == SessionStatus.running) {
      runningSessions = List.from(runningSessions + data);
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessions = List.from(completedSessions + data);
    } else {
      canceledSessions = List.from(canceledSessions + data);
    }
  }

  void changeSessionLoad({required int sessionStatus}) {
    if (sessionStatus == SessionStatus.all) {
      allSessionsLoad = false;
    } else if (sessionStatus == SessionStatus.running) {
      runningSessionsLoad = false;
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessionsLoad = false;
    } else {
      cancelledSessionsLoad = false;
    }
  }

  void changeSessionIsLast({required int sessionStatus, bool value = false}) {
    if (sessionStatus == SessionStatus.all) {
      isLastAllSessions = value;
    } else if (sessionStatus == SessionStatus.running) {
      isLastRunningSessions = value;
    } else if (sessionStatus == SessionStatus.completed) {
      isLastCompletedSessions = value;
    } else {
      isLastCanceledSessions = value;
    }
  }

  void changeSessionIsRefresh({required int sessionStatus, bool value = true}) {
    if (sessionStatus == SessionStatus.all) {
      allSessionsRefresh = value;
    } else if (sessionStatus == SessionStatus.running) {
      runningSessionsRefresh = value;
    } else if (sessionStatus == SessionStatus.completed) {
      completedSessionsRefresh = value;
    } else {
      cancelledSessionsRefresh = value;
    }
  }

  int getListLength({required int sessionType}) {
    if (sessionType == SessionStatus.all) {
      return allSessions.length;
    } else if (sessionType == SessionStatus.running) {
      return runningSessions.length;
    } else if (sessionType == SessionStatus.completed) {
      return completedSessions.length;
    } else {
      return canceledSessions.length;
    }
  }

  void resetOffset({required int sessionType}) {
    if (sessionType == SessionStatus.all) {
      allSessionsOffset = 1;
    } else if (sessionType == SessionStatus.running) {
      runningSessionsOffset = 1;
    } else if (sessionType == SessionStatus.completed) {
      completedSessionsOffset = 1;
    } else {
      cancelledSessionsOffset = 1;
    }
  }

  void setOffset({required int sessionType}) {
    if (sessionType == SessionStatus.all) {
      allSessionsOffset = allSessionsOffset + 1;
    } else if (sessionType == SessionStatus.running) {
      runningSessionsOffset = runningSessionsOffset + 1;
    } else if (sessionType == SessionStatus.completed) {
      completedSessionsOffset = completedSessionsOffset + 1;
    } else {
      cancelledSessionsOffset = cancelledSessionsOffset + 1;
    }
  }
}

class SessionStatus {
  static const int all = 0;
  static const int running = 1;
  static const int completed = 2;
  static const int cancelled = 3;

  static const int pending = 4;
  static const int accepted = 5;
  static const int rejected = 6;
  static const int booked = 7;

  static String getName(int status, {int? secsLeft}) {
    switch (status) {
      case SessionStatus.pending:
        return 'Not started';
      case SessionStatus.cancelled:
        return 'Canceled';
      case SessionStatus.completed:
        return 'Completed';
      default:
        return 'Not started';
    }
  }

  static Color getColor(int status, {int? secsLeft}) {
    switch (status) {
      case SessionStatus.pending:
        return MyColors.primaryColor;
      case SessionStatus.accepted:
        return MyColors.greenColor;
      case SessionStatus.rejected:
        return MyColors.redColor;
      case SessionStatus.cancelled:
        return MyColors.redColor;
      case SessionStatus.completed:
        return MyColors.greenColor;
      default:
        return MyColors.yellowColor;
    }
  }

  static getBgColor(int status) {
    return getColor(status).computeLuminance() > 0.5
        ? MyColors.blackColor
        : MyColors.whiteColor;
  }
}
