import 'package:quadsu_app/constants/global_data.dart';
// ignore: depend_on_referenced_packages
import 'package:quadsu_app/constants/shared_preference_keys.dart';

class SharedPreferenceServices {
/*  static updateSharePreferenceToLocal(LatLng latLng) {
    sharedPreference.setDouble(SharedPreferenceKeys.latitude, latLng.latitude);
    sharedPreference.setDouble(
        SharedPreferenceKeys.longitude, latLng.longitude);
  }*/

/*  static LatLng getLocation() {
    return LatLng(
        sharedPreference.getDouble(SharedPreferenceKeys.latitude) ?? 0,
        sharedPreference.getDouble(SharedPreferenceKeys.latitude) ?? 0);
  }*/

  static Future<bool> clearSharedPreference() async {
    userDataNotifier.value=null;
    userToken=null;
    sharedPreference.remove(SharedPreferenceKeys.userData);
    sharedPreference.remove(SharedPreferenceKeys.userToken);
   return await sharedPreference.clear();
  }
}
