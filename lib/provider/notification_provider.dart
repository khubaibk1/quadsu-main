import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/firebase_services/firebase_push_notifications.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

import '../modal/notification_model.dart';
import '../pages/guide_module/withdraw_history_screen.dart';
import '../pages/student_module/booking_request_screen.dart';
import '../pages/student_module/session_screen.dart';

  class NotificationProvider extends ChangeNotifier{
  int offset=1;
  bool notificationLoad=false;
  bool isLastNotification=false;
  bool isRefresh=false;
  List<Message> notificationList=[];
  NotificationModel? notification;

  Future<void> getNotification()
  async {
    notificationLoad=true;
    if(offset==1 && isRefresh==false)
    {
      EasyLoading.show();
    }
    notifyListeners();

    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getNotifications,
      request: {ApiKeys.page:offset},
      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");

      if(offset==1)
      {
        isLastNotification=false;
        notifyListeners();
        notification=NotificationModel.fromJson(jsonResponse.data);
        notificationList=List.from(notification?.messages??[]);
      }
      else
      {
        notification=NotificationModel.fromJson(jsonResponse.data);

        if(notification?.messages.isNotEmpty==true)
        {
          notificationList=List.from(notificationList+notification!.messages);
          isLastNotification=false;
          notifyListeners();
        }
        else
        {
          isLastNotification=true;
        }
      }
    }

    EasyLoading.dismiss();
    notificationLoad=false;
    notifyListeners();


  }


  void reset()
  {
    offset=1;
    notificationLoad=false;
    isLastNotification=false;
    isRefresh=false;
    notificationList=[];
    notification=null;
  }

  void reload()
  {
    notifyListeners();
  }


  static void handleNotification({
    required Map data,
    required BuildContext context,
  }) async {
    print('IN Handle Notification Function   $data $context');
    if(data[ApiKeys.screen]==Screens.booking)
      {
        CustomNavigation.push(context: context, screen:  SessionScreen(bokingId: data[ApiKeys.bookingId].toString(),));
      }

    if(data[ApiKeys.screen] == Screens.instant)
      {
        CustomNavigation.push(context: context, screen:  InstantRequestScreen(bookingId: data[ApiKeys.bookingId].toString(),));
      }


    if(data[ApiKeys.screen] == Screens.withdrawal)
      {
        CustomNavigation.push(context: context, screen:  const WithdrawScreenScreen());
      }
  }

}