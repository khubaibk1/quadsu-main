import 'package:flutter/material.dart';
import 'package:quadsu_app/constants/my_colors.dart';

class TransactionModel {
  List<Transaction> transactions = [];

  TransactionModel({this.transactions = const []});

  factory TransactionModel.fromJson(dynamic json) {
    List<Transaction> data = [];
    if (json['data'] != null) {
      data = <Transaction>[];

      json['data'].forEach((v) {
        data.add(Transaction.fromJson(v));
      });
    }

    return TransactionModel(transactions: data);
  }
}

class Transaction {
  int id;
  int userId;
  int transactionType;
  int bookingId;
  int withdrawStatus;
  String withdrawMethod;
  String payPalEmail;
  String venmoUserName;
  String rejectReason;
  String trxId;
  String paymentGateway;
  double amount;
  String tutorShare;
  String message;
  String transactionId;
  double quadUShare;
  String createdAt;
  String updatedAt;
  String bookingDatetime;

  Transaction({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.bookingId,
    required this.trxId,
    required this.paymentGateway,
    required this.amount,
    required this.tutorShare,
    required this.message,
    required this.transactionId,
    required this.quadUShare,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingDatetime,
    required this.withdrawStatus,
    required this.withdrawMethod,
    required this.payPalEmail,
    required this.venmoUserName,
    required this.rejectReason,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString()) ?? 0
          : 0,
      transactionType: json['transaction_type'] == "Dr"
          ? TransactionType.debit
          : TransactionType.credit,
      bookingId: json['booking_id'] != null
          ? int.tryParse(json['booking_id'].toString()) ?? 0
          : 0,
      trxId: json['trx_id'] ?? "",
      paymentGateway: json['payment_gateway'] ?? "",
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString()) ?? 0.0
          : 0.0,
      tutorShare: json['tutor_share'] ?? "",
      message: json['message'] ?? "",
      transactionId: json['transaction_id'] ?? "",
      quadUShare: json['quad_u_share'] != null
          ? double.tryParse(json['quad_u_share'].toString()) ?? 0.0
          : 0.0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      bookingDatetime: json['booking_datetime'] ?? "",
      withdrawStatus: json['status']!= null?int.tryParse(json['status'].toString()) ?? 0: 0,
      withdrawMethod: json['widthdrawal_using'] ?? "",
      payPalEmail: json['paypal_email'] ?? "",
      venmoUserName: json['venmo_username'] ?? "",
      rejectReason: json['reject_reason'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['transaction_type'] = transactionType;
    data['booking_id'] = bookingId;
    data['trx_id'] = trxId;
    data['payment_gateway'] = paymentGateway;
    data['amount'] = amount;
    data['tutor_share'] = tutorShare;
    data['message'] = message;
    data['transaction_id'] = transactionId;
    data['quad_u_share'] = quadUShare;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['booking_datetime'] = bookingDatetime;
    return data;
  }
}

class TransactionType {
  static const int credit = 0;
  static const int debit = 1;

  static Color getColor({required int transactionType}) {
    if (transactionType == TransactionType.credit) {
      return MyColors.greenColor;
    } else {
      return MyColors.redColor;
    }
  }
}


class WithdrawStatus {
  static const int pending = 0;
  static const int accept = 1;
  static const int reject = 2;

  static Color getColor({required int withdrawStatus}) {
    if (withdrawStatus == WithdrawStatus.pending) {
      return MyColors.yellowColor;
    } else if (withdrawStatus == WithdrawStatus.accept) {
      return MyColors.greenColor;
    }else {
      return MyColors.redColor;
    }
  }

  static getName({required int withdrawStatus}) {
    if (withdrawStatus == WithdrawStatus.pending) {
      return "Pending";
    } else if (withdrawStatus == WithdrawStatus.accept) {
      return "Accept";
    }else {
      return "Reject";
    }
  }
}

