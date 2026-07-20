
import 'custom_time_functions.dart';

class ValidationFunction {
  static requiredValidation(val, {String? msg}) {
    if (val == null || val.toString().trim().isEmpty) {
      return msg ?? "Required*";
    } else {
      return null;
    }
  }

  static requiredValidationForEndAvailability(val, {String? startTime}) {
    if (startTime == null || startTime.toString().isEmpty == true) {
      return "Select start time";
    } else if (val == null || val.toString().trim().isEmpty) {
      return "Required*";
    } else {


      String start = CustomTimeFunctions.convertTo24HourFormat(startTime);
      String end = CustomTimeFunctions.convertTo24HourFormat(val);

      print("STARATRATARATARATARA:::::::::::::::::::$startTime  $start   $val    $end   ${isEndTimeAfterStartTime(start,end)} ");
      if(isEndTimeAfterStartTime(start,end)==false)
        {
          return "Invalid End Time";


        }
      else
        {
          return  null;
        }

    }
  }

 static  bool isEndTimeAfterStartTime(String startTimeStr, String endTimeStr) {
    // Helper function to convert time string to total minutes
    int timeToMinutes(String timeStr) {
      List<String> timeParts = timeStr.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      return hour * 60 + minute;
    }

    int startTimeInMinutes = timeToMinutes(startTimeStr);
    int endTimeInMinutes = timeToMinutes(endTimeStr);

    return endTimeInMinutes > startTimeInMinutes;
  }

  static mobileNumberValidation(val) {
    if (val.toString().trim().isEmpty) {
      return "Required*";
    } else if (val.toString().trim().length < 10) {
      return "Enter 10 digit mobile number";
    } else {
      return null;
    }
    // return null;
  }

  static passwordValidation(String? val) {
    if (val.toString().trim().isEmpty) {
      return "Required*";
    } else if (val.toString().trim().length < 6) {
      return "Enter at least 6 character password";
    } else {
      return null;
    }
  }

  static confirmPasswordValidation(
      String? confirmNewPassword, String password) {
    if (confirmNewPassword == null || confirmNewPassword.trim().isEmpty) {
      return "Required*";
    } else if (confirmNewPassword.trim().length < 6) {
      return "Enter at least 6 character password";
    } else if (confirmNewPassword.trim() != password.trim()) {
      return "Confirm password &  password not match";
    } else {
      return null;
    }
    // return null;
  }

  static nameValidation(String val) {
    RegExp nameRegex =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    if (val.isEmpty) {
      return "Required*";
    } else if (!nameRegex.hasMatch(val)) {
      return "Enter correct name";
    } else {
      return null;
    }
  }

  static emailValidation(val) {
    RegExp emailAddress = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (val.toString().trim().isEmpty) {
      return "Please enter your email id*";
    } else if (!emailAddress.hasMatch(val.toString().trim())) {
      return "Enter correct email address";
    } else {
      return null;
    }
  }

  // static requiredNumberValidation(val) {
  //   RegExp numberValidation = RegExp(r'^-?\d+$');
  //   if (val.toString().trim().isEmpty) {
  //     return "Required Field*";
  //   } else if (!numberValidation.hasMatch(val.toString().trim())) {
  //     return "This number should be an integer";
  //   } else {
  //     return null;
  //   }
  // }

  static requiredNumberValidation(val,
      {double? maximumNumber, double? minimumNumber}) {
    RegExp numberValidation = RegExp(r'^-?\d+$');
    if (val.toString().trim().isEmpty) {
      return "Required Field*";
    } else if (!numberValidation.hasMatch(val.toString().trim())) {
      return "This number should be an integer";
    }

    if (maximumNumber != null) {
      try {
        double number = double.parse(val);
        if (number > maximumNumber) {
          return "The number cannot be more than ${maximumNumber.toStringAsFixed(0)}";
        }
      } catch (e) {
        return 'Invalid Number';
      }
    }
    if (minimumNumber != null) {
      try {
        double number = double.parse(val);
        if (val < minimumNumber) {
          return "The number cannot be less than ${minimumNumber.toStringAsFixed(0)}";
        }
      } catch (e) {
        return 'Invalid Number';
      }
    }

    return null;
  }
}
