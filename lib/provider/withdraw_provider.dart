import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

import '../modal/transaction_model.dart';

class WithdrawProvider extends ChangeNotifier
{



  Future<void> requestWithdraw(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.requestWithdraw,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: true,
    );

    print("request Instant Booking :::::::::::::${jsonResponse.status}");

    if (jsonResponse.status == 1) {
      CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
    }

    EasyLoading.dismiss();
  }






  bool withdrawsRefresh = false;
  int withdrawsOffset = 1;
  bool withdrawsLoad = false;
  bool isLastData = false;
  List<Transaction> withdraws = [];
  TransactionModel? withdrawModel;




  Future<void> getWithdrawHistory() async {
    withdrawsLoad = true;

    if (withdrawsOffset == 1 &&
        withdrawsRefresh == false) {
      EasyLoading.show();
    }

    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getWithdrawHistory,

      request: {
        ApiKeys.page: withdrawsOffset,
      },

      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("student guide :::::::::::::${jsonResponse.data}");

      if (withdrawsOffset == 1) {
        isLastData = false;
        notifyListeners();
        withdrawModel = TransactionModel.fromJson(jsonResponse.data);
        withdraws = List.from(withdrawModel?.transactions ?? []);
      } else {
        withdrawModel = TransactionModel.fromJson(jsonResponse.data);
        if (withdrawModel?.transactions.isNotEmpty == true) {
          withdraws =
              withdraws + List.from(withdrawModel?.transactions ?? []);
          isLastData = false;
          notifyListeners();
        } else {
          isLastData = true;
        }
      }
    }

    EasyLoading.dismiss();
    withdrawsLoad = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void reset() {
    withdrawsRefresh = false;

    withdrawsOffset = 1;

    withdrawsLoad = false;

    isLastData = false;

    withdraws = [];
    withdrawModel=null;
  }

}