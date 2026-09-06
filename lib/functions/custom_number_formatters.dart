import 'package:intl/intl.dart';
class CustomNumberFormatters{

  static String formatNumberInCommasEN(dynamic number){
    return NumberFormat('#,##0.00', 'en_US').format(double.tryParse(number.toString())??0);
    // return NumberFormat('#,##0,00', 'en_US').format(double.tryParse(number)??0);
  }

  static String formatNumberInCommasENWithoutDecimals(dynamic number){
    return NumberFormat('#,##0', 'en_US').format(double.tryParse(number.toString())??0);
    // return NumberFormat('#,##0,00', 'en_US').format(double.tryParse(number)??0);
  }

  static String formatNumberInCommasEnWithCurrency(dynamic number){
    return '${formatNumberInCommasEN(number)} FCFA';
  }

  static String formatNumberInCommasEnWithCurrencyWithoutDecimals(dynamic number){
    return '${formatNumberInCommasENWithoutDecimals(number)} FCFA';
  }
}