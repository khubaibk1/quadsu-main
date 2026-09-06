import 'package:quadsu_app/functions/print_function.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ResponseModal<T> {
  int status;
  String message;
  Map error;
  T data;
  Map fullData;

  ResponseModal({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
    required this.fullData,
  });

  factory ResponseModal.fromJson(Map jsonResponse) {
    return ResponseModal(
      status: jsonResponse['status'] ?? 0,
      message: jsonResponse['message'] ?? '',
      error: jsonResponse['error'] ??
          jsonResponse['errors'] ??
          {'error': 'static error'},
      data: jsonResponse['data'] ?? jsonResponse,
      fullData: jsonResponse,
    );
  }

  factory ResponseModal.fromHttpResponse(http.Response response) {
    Map jsonResponse = {};
    try {
      jsonResponse = convert.jsonDecode(response.body);
    } catch (e) {
      jsonResponse['message'] = 'Internal Server App';
      jsonResponse['error'] = response.body;
    }

    try {
      if (jsonResponse['message'] == 'Validation failed') {
        jsonResponse['error'] = jsonResponse['error'] ?? jsonResponse['errors'];
        jsonResponse['message'] = '';
        List<String> errors = [];
        (jsonResponse['error'] as Map).forEach((key, value) {
          for (var element in (value as List)) {
            errors.add(element.toString());
            // jsonResponse['message'] +=element.toString() + '\n';
          }
        });
        jsonResponse['message'] = errors.join('\n');
      }
    } catch (e) {
      myCustomPrintStatement('Error in catch block...$e');
    }

    switch (response.statusCode) {
      case 200:
        // print('sdflk klsdf${jsonResponse}');
        return ResponseModal(
          status: int.tryParse(jsonResponse['status'].toString()) ?? 0,
          message: jsonResponse['message'] ?? '',
          error: jsonResponse['error'] ??
              jsonResponse['errors'] ??
              {'error': 'static error'},
          data: jsonResponse['data'] ?? jsonResponse,
          fullData: jsonResponse,
        );
      case 201:
        return ResponseModal(
          status: int.tryParse(jsonResponse['status'].toString()) ?? 0,
          message: jsonResponse['message'] ?? '',
          error: jsonResponse['error'] ??
              jsonResponse['errors'] ??
              {'error': 'static error'},
          data: jsonResponse['data'] ?? jsonResponse,
          fullData: jsonResponse,
        );
      case 400:
        return ResponseModal(
          status: int.tryParse(jsonResponse['status'].toString()) ?? 0,
          message: jsonResponse['message'] ?? 'Bad Request',
          error: jsonResponse['error'] ??
              jsonResponse['errors'] ??
              {'error': 'static error'},
          data: jsonResponse['data'] ?? jsonResponse,
          fullData: jsonResponse,
        );

      case 401:
        {
          // try {
          //   Provider.of<AuthProvider>(MyGlobalKeys.navigatorKey.currentContext!,
          //           listen: false)
          //       .logout(MyGlobalKeys.navigatorKey.currentContext!);
          // } catch (e) {
          //   myCustomPrintStatement('Error in catch block $e');
          // }
          return ResponseModal(
            status: 0,
            message:
                jsonResponse['message'] ?? 'Auth token invalid app end message',
            error: jsonResponse['error'] ?? jsonResponse['errors'] ?? {},
            data: jsonResponse['data'] ?? jsonResponse,
            fullData: jsonResponse,
          );
        }

      case 500:
        {
          try {
            return ResponseModal(
              status: 0,
              message: jsonResponse['message'] ??
                  'Auth token invalid app end message',
              error: jsonResponse['error'] ?? jsonResponse['errors'] ?? {},
              data: jsonResponse['data'] ?? jsonResponse,
              fullData: jsonResponse,
            );
          } catch (e) {
            return ResponseModal(
              status: 0,
              message: jsonResponse.toString(),
              error: jsonResponse['error'] ?? jsonResponse['errors'] ?? {},
              data: jsonResponse['data'] ?? jsonResponse,
              fullData: jsonResponse,
            );
          }
        }

      default:
        return ResponseModal(
          status: 0,
          message: jsonResponse['message'] ??
              'Default message ${response.statusCode}',
          error: jsonResponse['error'] ?? jsonResponse['errors'] ?? {},
          data: jsonResponse['data'] ?? jsonResponse,
          fullData: jsonResponse,
        );
    }
  }
}
