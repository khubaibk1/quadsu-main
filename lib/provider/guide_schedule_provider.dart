import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/modal/guide_schedule_model.dart';
import 'package:quadsu_app/modal/upcoming_booking_model.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';

class GuideScheduleProvider extends ChangeNotifier {
  GuideScheduleModel? scheduleModel;
  UpcomingBookingModel? upcomingBookingModel;
  bool isScheduleLoading = false;
  bool isUpcomingLoading = false;

  Future<void> getGoogleConnectUrl() async {
    EasyLoading.show(status: 'Getting authorized URL...');
    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.googleConnect,
      request: {},
      apiMethod: ApiMethod.get,
      showErrorMessage: false,
    );
    EasyLoading.dismiss();

    print(
        'Google Connect Response: Status=${response.status}, Message=${response.message}, Data=${response.data}');

    // The backend returns status: "success" inside data, but response.status might be 0 because it's a string
    if (response.status == 1 || response.data['status'] == 'success') {
      String url = response.data['connect_url'] ?? response.data['url'] ?? "";
      if (url.isNotEmpty) {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          showSnackbar("Could not launch Google connect URL");
        }
      }
    } else {
      if (response.message != 'static message') {
        showSnackbar(response.message);
      }
    }
  }

  Future<void> fetchSchedule() async {
    isScheduleLoading = true;
    notifyListeners();

    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getMySchedule,
      request: {},
      apiMethod: ApiMethod.get,
      showErrorMessage: false,
    );

    if (response.status == 1 || response.data['status'] == 'success') {
      scheduleModel = GuideScheduleModel.fromJson(
          response.fullData as Map<String, dynamic>);
    }

    isScheduleLoading = false;
    notifyListeners();
  }

  Future<void> saveSchedule(List<ScheduleDay> updatedSchedule) async {
    EasyLoading.show(status: 'Saving schedule...');

    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.saveMySchedule,
      request: {
        'schedule': updatedSchedule.map((e) => e.toJsonForSave()).toList(),
      },
      apiMethod: ApiMethod.post,
    );

    EasyLoading.dismiss();
    if (response.status == 1 || response.data['status'] == 'success') {
      showSnackbar("Schedule saved successfully");
      await fetchSchedule(); // Refresh local data
    } else {
      showSnackbar(response.message);
    }
  }

  Future<void> fetchUpcomingBookings() async {
    isUpcomingLoading = true;
    notifyListeners();

    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.upcomingSessions,
      request: {},
      apiMethod: ApiMethod.get,
      showErrorMessage: false,
    );

    if (response.status == 1 || response.data['status'] == 'success') {
      upcomingBookingModel = UpcomingBookingModel.fromJson(
          response.fullData as Map<String, dynamic>);
    }

    isUpcomingLoading = false;
    notifyListeners();
  }
}
