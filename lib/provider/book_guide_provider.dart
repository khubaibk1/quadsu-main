import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/functions/print_function.dart';
import 'package:quadsu_app/modal/response_modal.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/modal/user_modal.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import '../functions/custom_time_functions.dart';
import '../constants/global_data.dart';
import 'package:quadsu_app/modal/custom_app_setting.dart';

class BookGuideProvider extends ChangeNotifier {
  Guide? selectedGuide;
  double totalHours = 0.0;
  double totalCost = 0.0;
  double serviceFee = 0.0;
  double servicePer = 0.0;
  double tax = 0.0;
  double taxPer = 0.0;
  double grandTotal = 0.0;
  double discount = 0.0;
  String? promoMessage;
  DateTime? selectedDate;
  String? selectedSlot;

  List<dynamic> availableSlots = [];
  bool isLoadingSlots = false;
  bool isCheckoutLoading = false;

  void reload() {
    notifyListeners();
  }

  void reset() {
    selectedGuide = null;
    selectedDate = null;
    selectedSlot = null;
    totalHours = 0.0;
    totalCost = 0.0;
    serviceFee = 0.0;
    servicePer = 0.0;
    tax = 0.0;
    taxPer = 0.0;
    grandTotal = 0.0;
    discount = 0.0;
    promoMessage = null;
    availableSlots = [];
    isLoadingSlots = false;
    isCheckoutLoading = false;
  }

  Future<void> fetchCheckoutDetails(int guideId, {String? promoCode}) async {
    isCheckoutLoading = true;
    notifyListeners();

    print("DEBUG: Fetching Checkout Details for Guide $guideId, Promo: $promoCode");

    Map<String, dynamic> request = {'guide_id': guideId};
    if (promoCode != null && promoCode.isNotEmpty) {
      request['promo_code'] = promoCode;
    }

    try {
      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.checkoutDetails,
        request: request,
        apiMethod: ApiMethod.get,
        showErrorMessage: true,
        showSuccessMessage: promoCode != null,
      );

      print("DEBUG: Checkout Response Status: ${response.status}");
      print("DEBUG: Checkout Response Data: ${response.data}");

      if (response.status == 1) {
        var data = response.data;
        double backendBasePrice = double.tryParse(data['base_price'].toString()) ?? 0.0;
        double localSessionPrice = double.tryParse(myAppSettings?.sessionPrice ?? "0") ?? 0.0;
        
        // Prioritize local session price over backend base price if backend failed to pass `.env` variable
        totalCost = (localSessionPrice > 0) ? localSessionPrice : backendBasePrice;
        
        discount = double.tryParse(data['discount']?.toString() ?? "0") ?? 0.0;
        promoMessage = data['promo_message']?.toString();
        
        if (backendBasePrice == 0 && localSessionPrice > 0) {
           taxPer = 5.0; 
           tax = (totalCost * taxPer) / 100.0;
           grandTotal = totalCost + tax - discount;
        } else {
           tax = double.tryParse(data['tax_amount'].toString()) ?? 0.0;
           grandTotal = double.tryParse(data['grand_total'].toString()) ?? 0.0;
        }
        
        serviceFee = 0.0;
        servicePer = 0.0;
      }
    } finally {
      isCheckoutLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGuideAvailability(int guideId, String date) async {
    isLoadingSlots = true;
    availableSlots = [];
    notifyListeners();

    final url = ApiUrls.getGuideAvailability(guideId);
    print("DEBUG: Fetching Guide Availability");
    print("DEBUG: URL: $url");
    print("DEBUG: Param: date=$date");

    var response = await NewestWebServices.getResponse(
      apiUrl: url,
      request: {'date': date},
      apiMethod: ApiMethod.get,
      showErrorMessage: false,
    );

    print("DEBUG: Response Status: ${response.status}");
    print("DEBUG: Response Data: ${response.data}");

    if (response.status == 1 || response.data['status'] == 'success') {
      availableSlots = response.data['available_slots'] ?? [];
      
      // Provide fallback support for session_price right from the Slot API
      if (response.data['session_price'] != null) {
        myAppSettings ??= MyAppSettings();
        myAppSettings!.sessionPrice = response.data['session_price'].toString();
      } else if (response.data['SESSION_PRICE'] != null) {
        myAppSettings ??= MyAppSettings();
        myAppSettings!.sessionPrice = response.data['SESSION_PRICE'].toString();
      }
    } else {
      availableSlots = [];
    }

    print("DEBUG: Slots found: ${availableSlots.length}");
    isLoadingSlots = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> verifyPaypalPayment(
      {required String orderId}) async {
    print("DEBUG: Verifying PayPal Payment - OrderID: $orderId");

    if (selectedSlot == null || selectedDate == null || selectedGuide == null) {
      print("DEBUG: Verification failed - Missing session details");
      return null;
    }

    try {
      // 1. Parse selected slot time (e.g., "09:00 AM")
      final timeParts = selectedSlot!.split(' '); // ["09:00", "AM"]
      final hourMin = timeParts[0].split(':'); // ["09", "00"]
      int hour = int.parse(hourMin[0]);
      int minute = int.parse(hourMin[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      // 2. Create Start and End DateTime
      final startDate = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        hour,
        minute,
      );
      final endDate = startDate.add(const Duration(hours: 1));

      // 3. Format for API: YYYY-MM-DD HH:MM:SS
      final startStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
      final endStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

      final payload = {
        'orderID': orderId,
        'guide_id': selectedGuide!.id,
        'start_time': startStr,
        'end_time': endStr,
        'total_amount': grandTotal,
      };

      print("DEBUG: Verification Payload: $payload");

      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.verifyPaypal,
        request: payload,
        apiMethod: ApiMethod.post,
        showErrorMessage: false,
      );

      print("DEBUG: Verification Response: ${response.data}");

      // Both Laravel status == 1 AND PayPal status being APPROVED/COMPLETED
      // are considered valid for proceeding to booking creation.
      bool isSuccess = false;
      if (response.status == 1) {
        isSuccess = true;
      } else if (response.data is Map) {
        final paypalStatus = (response.data['status'] as String? ?? '').toUpperCase();
        if (paypalStatus == 'APPROVED' || paypalStatus == 'COMPLETED') {
          print("DEBUG: PayPal order $paypalStatus — treating as success.");
          isSuccess = true;
        }
      }

      if (isSuccess) {
        return {
          'success': true,
          'data': response.data,
        };
      }
    } catch (e) {
      print("DEBUG: Error in verifyPaypalPayment: $e");
    }

    return null;
  }

  List<String> generateTimeIntervals(
      GuideSchedule schedule, DateTime selectedDate) {
    if (schedule.isOffDay == 'true') {
      // Return empty list for off days
      return [];
    }

    TimeOfDay startTime =
        CustomTimeFunctions.parseTimeOfDay(schedule.startTime);
    TimeOfDay endTime = CustomTimeFunctions.parseTimeOfDay(schedule.endTime);

    print("staratarataatt:::::::$startTime");
    print("staratarataatt:::::::$endTime");
    // Get current time
    TimeOfDay now = TimeOfDay.now();

    // Check if selected date is today
    bool isToday = DateTime.now().day == selectedDate.day &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().year == selectedDate.year;

    // If it's today, adjust the start time to be after the current time
    if (isToday &&
        (startTime.hour < now.hour ||
            (startTime.hour == now.hour && startTime.minute <= now.minute))) {
      startTime = TimeOfDay(hour: now.hour + 1, minute: 0);
    }

    List<String> timeIntervals = [];
    while (startTime.hour < endTime.hour ||
        (startTime.hour == endTime.hour && startTime.minute < endTime.minute)) {
      // Format TimeOfDay to AM/PM string
      String formattedTime = CustomTimeFunctions.formatTimeOfDay(startTime);
      timeIntervals.add(formattedTime);

      // Increment the time by 1 hour
      startTime = TimeOfDay(hour: startTime.hour + 1, minute: 0);
    }
    if (timeIntervals.length > 1) {
      return timeIntervals;
    } else {
      return [];
    }
  }

  void calculateTotal() {
    if (selectedGuide == null) return;

    double hourlyRate =
        double.tryParse(myAppSettings?.sessionPrice ?? "0") ?? 0.0;
    totalHours = 1.0; // Currently 1 hour per slot
    totalCost = hourlyRate * totalHours;

    // Example fee logic: 10% service fee + 5% tax
    servicePer = 10.0;
    serviceFee = (totalCost * servicePer) / 100.0;

    taxPer = 5.0;
    tax = (totalCost * taxPer) / 100.0;

    grandTotal = totalCost + serviceFee + tax;
    notifyListeners();
  }

  Future<bool> checkAvailability(
      {required Map<String, dynamic> request}) async {
    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getAvailability,
      request: request,
      apiMethod: ApiMethod.post,
      showSuccessMessage: false,
    );

    print("checkAvailability:::::::::::::${jsonResponse.status}");

    if (jsonResponse.status == 1) {
      EasyLoading.dismiss();
      notifyListeners();
      return true;
    } else {
      EasyLoading.dismiss();
      // Error message is already shown by NewestWebServices
      notifyListeners();
      return false;
    }
  }

  Future<ResponseModal?> createBooking(
      {required Map<String, dynamic> request}) async {
    myCustomPrintStatement("addatdatL:::::$request");

    EasyLoading.show();
    notifyListeners();
    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.createBooking,
      request: request,
      apiMethod: ApiMethod.post,
    );

    print("createBooking:::::::::::::${jsonResponse.data}");

    if (jsonResponse.status == 1) {
      EasyLoading.dismiss();
      notifyListeners();
      return jsonResponse;
    } else {
      EasyLoading.dismiss();
      notifyListeners();
      return null;
    }
  }
}
