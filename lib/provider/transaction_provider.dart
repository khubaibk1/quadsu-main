import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/transaction_model.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

class TransactionProvider extends ChangeNotifier {
  bool transactionsRefresh = false;
  int transactionsOffset = 1;
  bool transactionsLoad = false;
  bool isLastData = false;
  List<Transaction> transactions = [];
  TransactionModel? transactionModel;

  Future<void> getTransactions() async {
    transactionsLoad = true;

    if (transactionsOffset == 1 &&
        transactionsRefresh == false) {
      EasyLoading.show();
    }

    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: usertype == UserType.student
          ? ApiUrls.getStudentTransactions
          : ApiUrls.getGuideWallet,

      request: {
        ApiKeys.page: transactionsOffset,
      },

      apiMethod: ApiMethod.get,
    );

    if (jsonResponse.status == 1) {
      print("student guide :::::::::::::${jsonResponse.data}");

      if (transactionsOffset == 1) {
        isLastData = false;
        notifyListeners();
        transactionModel = TransactionModel.fromJson(jsonResponse.data);
        transactions = List.from(transactionModel?.transactions ?? []);
      } else {
        transactionModel = TransactionModel.fromJson(jsonResponse.data);
        if (transactionModel?.transactions.isNotEmpty == true) {
          transactions =
              transactions + List.from(transactionModel?.transactions ?? []);
          isLastData = false;
          notifyListeners();
        } else {
          isLastData = true;
        }
      }
    }

    EasyLoading.dismiss();
    transactionsLoad = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void reset() {
    transactionsRefresh = false;

    transactionsOffset = 1;

    transactionsLoad = false;

    isLastData = false;

    transactions = [];
    transactionModel=null;
  }
}
