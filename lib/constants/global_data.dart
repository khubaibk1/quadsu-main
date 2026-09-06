import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/modal/vehicle_type_modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/custom_app_setting.dart';

int timezoneOffset=-240 ;
MyAppSettings? myAppSettings;
 ValueNotifier<UserModal?> userDataNotifier = ValueNotifier(null);
String  usertype=UserType.student;
String? userToken;
String bookingId = '';
late SharedPreferences sharedPreference;
void unFocusKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String fontFamily = "Poppins-Regular";
String cur = "\$";

const String defaultCountryCode = "01";

Map<String, String> globalHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

List languagesList = [
  {'key': 'en', 'value': 'English'},
  {'key': 'ar', 'value': 'عربي'},
];

// ValueNotifier<Map<String, dynamic>> selectedLanguageNotifier = ValueNotifier(languagesList[1]);



const double globalHorizontalPadding = 18;



List<VehicleTypeModal> vehicleTypesList = [];
Map<String, VehicleTypeModal> vehicleTypesMap = {};

// class UserType{
//   static int student=0;
//   static int guid=1;
// }
