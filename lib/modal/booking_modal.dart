import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingModal {
  String id;
  LatLng startDestinationLatLng;
  LatLng endDestinationLatLng;
  String startDestination;
  Map startGeoPoint;
  Map endGeoPoint;
  String endDestination;
  String requestedBy;
  double totalBookingAmount;
  double commissionPercent;
  double commissionPrice;
  String? appliedCoupon;
  double appliedCouponDiscountAmount;
  String vehicle_type;
  int bookingStatus;
  Timestamp createdAt;
  Timestamp updatedAt;
  int rideType;
  bool isScheduled;
  Timestamp scheduledTime;
  String paymentMode;
  List rejectedBy;
  String? acceptedBy;
  String? bookingOtp;

  BookingModal({
    required this.id,
    required this.startDestinationLatLng,
    required this.endDestinationLatLng,
    required this.startGeoPoint,
    required this.endGeoPoint,
    required this.startDestination,
    required this.endDestination,
    required this.requestedBy,
    required this.totalBookingAmount,
    required this.commissionPercent,
    required this.commissionPrice,
    required this.appliedCoupon,
    required this.appliedCouponDiscountAmount,
    required this.vehicle_type,
    required this.bookingStatus,
    required this.rideType,
    required this.isScheduled,
    required this.scheduledTime,
    required this.createdAt,
    required this.updatedAt,
    required this.rejectedBy,
    required this.paymentMode,
    required this.acceptedBy,
    required this.bookingOtp,
  });

  factory BookingModal.fromJson(Map json, String id) {
    var start = (json[ApiKeys.startDestinationLatLng] as GeoPoint);
    var end = (json[ApiKeys.endDestinationLatLng] as GeoPoint);

    return BookingModal(
      id: id,
      // id: json[ApiKeys.id],
      // startDestinationLatLng: LatLng(
      //     double.tryParse(json[ApiKeys.startDestinationLatitude].toString()) ??
      //         0,
      //     double.tryParse(json[ApiKeys.startDestinationLongitude].toString()) ??
      //         0),
      // endDestinationLatLng: LatLng(
      //     double.tryParse(json[ApiKeys.endDestinationLatitude].toString()) ?? 0,
      //     double.tryParse(json[ApiKeys.endDestinationLongitude].toString()) ??
      //         0),

      startGeoPoint: json[ApiKeys.startGeoPoint],
      endGeoPoint: json[ApiKeys.endGeoPoint],
      startDestinationLatLng: LatLng(start.latitude, start.longitude),
      endDestinationLatLng: LatLng(end.latitude, end.longitude),
      startDestination: json[ApiKeys.startDestination],
      endDestination: json[ApiKeys.endDestination],
      requestedBy: json[ApiKeys.requestedBy],
      totalBookingAmount:
          double.tryParse(json[ApiKeys.totalBookingAmount].toString()) ?? 0,
      commissionPercent:
          double.tryParse(json[ApiKeys.commissionPercent].toString()) ?? 0,
      commissionPrice:
          double.tryParse(json[ApiKeys.commissionPrice].toString()) ?? 0,
      appliedCoupon: json[ApiKeys.appliedCoupon],
      appliedCouponDiscountAmount: double.tryParse(
              json[ApiKeys.appliedCouponDiscountAmount].toString()) ??
          0,
      vehicle_type: json[ApiKeys.vehicle_type],
      bookingStatus: json[ApiKeys.bookingStatus],
      rideType: json[ApiKeys.rideType],
      scheduledTime: json[ApiKeys.scheduledTime],
      rejectedBy: json[ApiKeys.rejectedBy] ?? [],
      isScheduled: json[ApiKeys.isScheduled],
      createdAt: json[ApiKeys.createdAt],
      updatedAt: json[ApiKeys.updatedAt] ?? json[ApiKeys.createdAt],
      paymentMode: json[ApiKeys.paymentMode],
      acceptedBy: json[ApiKeys.acceptedBy],
      bookingOtp: json[ApiKeys.bookingOtp].toString(),
    );
  }

  Map<String, dynamic> addBookingRequestJson() {
    return {
      // ApiKeys.startDestinationLatitude: startDestinationLatLng.latitude,
      // ApiKeys.startDestinationLongitude: startDestinationLatLng.longitude,
      // ApiKeys.endDestinationLatitude: endDestinationLatLng.latitude,
      // ApiKeys.endDestinationLongitude: endDestinationLatLng.longitude,
      ApiKeys.startGeoPoint: startGeoPoint,
      ApiKeys.endGeoPoint: endGeoPoint,
      ApiKeys.startDestinationLatLng: GeoPoint(
          startDestinationLatLng.latitude, startDestinationLatLng.longitude),
      ApiKeys.endDestinationLatLng: GeoPoint(
          endDestinationLatLng.latitude, endDestinationLatLng.longitude),
      ApiKeys.startDestination: startDestination,
      ApiKeys.endDestination: endDestination,
      ApiKeys.requestedBy: requestedBy,
      ApiKeys.totalBookingAmount: totalBookingAmount,
      ApiKeys.commissionPercent: commissionPercent,
      ApiKeys.commissionPrice: commissionPrice,
      ApiKeys.appliedCoupon: appliedCoupon,
      ApiKeys.appliedCouponDiscountAmount: appliedCouponDiscountAmount,
      ApiKeys.vehicle_type: vehicle_type,
      ApiKeys.bookingStatus: bookingStatus,
      ApiKeys.rejectedBy: rejectedBy,
      ApiKeys.createdAt: createdAt,
      ApiKeys.updatedAt: updatedAt,
      ApiKeys.rideType: rideType,
      ApiKeys.scheduledTime: scheduledTime,
      ApiKeys.isScheduled: isScheduled,

      ApiKeys.paymentMode: paymentMode,
    };
  }

  Map<String, dynamic> toJson() {
    var request = addBookingRequestJson();
    request.addAll({ApiKeys.id: id});
    return request;
  }
}
// class BookingModal {
//   String id;
//   LatLng startDestinationLatLng;
//   LatLng endDestinationLatLng;
//   String startDestination;
//   String endDestination;
//   String requestedBy;
//   double totalBookingAmount;
//   double commissionPercent;
//   double commissionPrice;
//   String? appliedCoupon;
//   double appliedCouponDiscountAmount;
//   String vehicle_type;
//   int bookingStatus;
//   Timestamp createdAt;
//   Timestamp updatedAt;
//   int rideType;
//   bool isScheduled;
//   Timestamp scheduledTime;
//   String paymentMode;
//   List rejectedBy;
//   String? acceptedBy;
//   String? bookingOtp;
//
//   BookingModal({
//     required this.id,
//     required this.startDestinationLatLng,
//     required this.endDestinationLatLng,
//     required this.startDestination,
//     required this.endDestination,
//     required this.requestedBy,
//     required this.totalBookingAmount,
//     required this.commissionPercent,
//     required this.commissionPrice,
//     required this.appliedCoupon,
//     required this.appliedCouponDiscountAmount,
//     required this.vehicle_type,
//     required this.bookingStatus,
//     required this.rideType,
//     required this.isScheduled,
//     required this.scheduledTime,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.rejectedBy,
//     required this.acceptedBy,
//     required this.bookingOtp,
//     required this.paymentMode,
//   });
//
//   factory BookingModal.fromJson(Map json, String id) {
//     return BookingModal(
//       id: id,
//       // id: json[ApiKeys.id],
//       startDestinationLatLng: LatLng(
//           double.tryParse(json[ApiKeys.startDestinationLatitude].toString()) ??
//               0,
//           double.tryParse(json[ApiKeys.startDestinationLongitude].toString()) ??
//               0),
//       endDestinationLatLng: LatLng(
//           double.tryParse(json[ApiKeys.endDestinationLatitude].toString()) ?? 0,
//           double.tryParse(json[ApiKeys.endDestinationLongitude].toString()) ??
//               0),
//       startDestination: json[ApiKeys.startDestination],
//       endDestination: json[ApiKeys.endDestination],
//       requestedBy: json[ApiKeys.requestedBy],
//       totalBookingAmount:
//           double.tryParse(json[ApiKeys.totalBookingAmount].toString()) ?? 0,
//       commissionPercent:
//           double.tryParse(json[ApiKeys.commissionPercent].toString()) ?? 0,
//       commissionPrice:
//           double.tryParse(json[ApiKeys.commissionPrice].toString()) ?? 0,
//       appliedCoupon: json[ApiKeys.appliedCoupon],
//       appliedCouponDiscountAmount: double.tryParse(
//               json[ApiKeys.appliedCouponDiscountAmount].toString()) ??
//           0,
//       vehicle_type: json[ApiKeys.vehicle_type],
//       bookingStatus: json[ApiKeys.bookingStatus],
//       rideType: json[ApiKeys.rideType],
//       scheduledTime: json[ApiKeys.scheduledTime],
//       isScheduled: json[ApiKeys.isScheduled],
//       createdAt: json[ApiKeys.createdAt],
//       updatedAt: json[ApiKeys.updatedAt]??json[ApiKeys.createdAt],
//       paymentMode: json[ApiKeys.paymentMode],
//       rejectedBy: json[ApiKeys.rejectedBy]??[],
//       acceptedBy: json[ApiKeys.acceptedBy],
//       bookingOtp: json[ApiKeys.bookingOtp],
//     );
//   }
//
//   Map<String, dynamic> addBookingRequestJson() {
//     return {
//       ApiKeys.startDestinationLatitude: startDestinationLatLng.latitude,
//       ApiKeys.startDestinationLongitude: startDestinationLatLng.longitude,
//       ApiKeys.endDestinationLatitude: endDestinationLatLng.latitude,
//       ApiKeys.endDestinationLongitude: endDestinationLatLng.longitude,
//       ApiKeys.startDestination: startDestination,
//       ApiKeys.endDestination: endDestination,
//       ApiKeys.requestedBy: requestedBy,
//       ApiKeys.totalBookingAmount: totalBookingAmount,
//       ApiKeys.commissionPercent: commissionPercent,
//       ApiKeys.commissionPrice: commissionPrice,
//       ApiKeys.appliedCoupon: appliedCoupon,
//       ApiKeys.appliedCouponDiscountAmount: appliedCouponDiscountAmount,
//       ApiKeys.vehicle_type: vehicle_type,
//       ApiKeys.bookingStatus: bookingStatus,
//       ApiKeys.createdAt: createdAt,
//       ApiKeys.rideType: rideType,
//       ApiKeys.scheduledTime: scheduledTime,
//       ApiKeys.isScheduled: isScheduled,
//       ApiKeys.paymentMode: paymentMode,
//       ApiKeys.updatedAt: updatedAt,
//       ApiKeys.rejectedBy: rejectedBy,
//     };
//   }
//
//   Map<String, dynamic> toJson() {
//     var request = addBookingRequestJson();
//     request.addAll({ApiKeys.id: id});
//     return request;
//   }
// }
