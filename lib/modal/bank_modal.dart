import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadsu_app/constants/api_keys.dart';

class BankModal {
  String? id;
  String user_id;
  String bank_name;
  String bicCode;
  String ibanAccountNumber;
  String account_name;
  Timestamp created_at;

  BankModal({
    required this.id,
    required this.user_id,
    required this.bank_name,
    required this.bicCode,
    required this.ibanAccountNumber,
    required this.account_name,
    required this.created_at,
    // required this.updated_at,
  });

  factory BankModal.fromJson(Map json, String id) {
    return BankModal(
      id: id,
      // id: json[ApiKeys.id]??0,
      user_id: json[ApiKeys.userId],
      bank_name: json[ApiKeys.bankName] ?? '',
      bicCode: json[ApiKeys.bicCode] ?? json[ApiKeys.ifsc] ?? '',
      ibanAccountNumber:
          json[ApiKeys.ibanAccountNumber] ?? json[ApiKeys.accountNo] ?? '',
      account_name: json[ApiKeys.accountName] ?? '',
      created_at: json[ApiKeys.createdAt],
      // updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.userId: user_id,
      ApiKeys.bankName: bank_name,
      ApiKeys.bicCode: bicCode,
      ApiKeys.ibanAccountNumber: ibanAccountNumber,
      ApiKeys.accountName: account_name,
      ApiKeys.createdAt: created_at,
      // 'updated_at':updated_at,
    };
  }
}
