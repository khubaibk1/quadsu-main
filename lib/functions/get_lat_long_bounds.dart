// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// LatLngBounds? getLatLongBounds(List<List<double>> latLongList) {
//   if (latLongList.isEmpty) {
//     return null;
//   }
//   double minLat = latLongList[0][0];
//   double maxLat = latLongList[0][0];
//   double minLong = latLongList[0][1];
//   double maxLong = latLongList[0][1];
//   for (var latLong in latLongList) {
//     double lat = latLong[0];
//     double long = latLong[1];
//     minLat = (lat < minLat) ? lat : minLat;
//     maxLat = (lat > maxLat) ? lat : maxLat;
//     minLong = (long < minLong) ? long : minLong;
//     maxLong = (long > maxLong) ? long : maxLong;
//   }
//   return LatLngBounds(minLat, maxLat, minLong, maxLong);
// }