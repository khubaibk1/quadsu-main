// import 'package:flutter/material.dart';
// import 'package:quadsu_app/modal/shipment_modal.dart';
//
// import '../my_colors.dart';
//
// class ShipmentStatus{
//   static const int pending = 0;
//   static const int running = 1;
//   static const int rejected = 2;
//   static const int completed = 3;
//   static const int applied = 4;
//
//
//   static String bookingStatusShortName(int status){
//     switch(status){
//       case ShipmentStatus.pending:{
//         return 'Pending';
//       }
//       case ShipmentStatus.running: return 'Accepted';
//       case ShipmentStatus.rejected: return 'Rejected';
//       case ShipmentStatus.completed: return 'Completed';
//       case ShipmentStatus.applied: return 'Applied';
//       default: return 'Pending';
//     }
//   }
//
//
//
//   static String shipmentStatusName(int status,{required int bidStatus}){
//     switch(status){
//       case ShipmentStatus.pending:{
//         switch(bidStatus){
//           case BidStatus.applied: return 'Applied';
//           case BidStatus.accepted: return 'Accepted';
//           case BidStatus.notBidded: return 'Pending';
//           case BidStatus.rejected: return 'Rejected';
//           default: return 'Pending';
//         }
//
//       }
//       case ShipmentStatus.running: return 'Accepted';
//       case ShipmentStatus.rejected: return 'Rejected';
//       case ShipmentStatus.completed: return 'Completed';
//       case ShipmentStatus.applied: return 'Applied';
//       default: return 'Pending';
//     }
//   }
//
//   static Color getStatusColor(int status,{required int bidStatus}){
//     switch(status){
//       case  ShipmentStatus.pending:{
//         switch(bidStatus){
//           case BidStatus.applied: return MyColors.greenColor;
//           case BidStatus.accepted: return MyColors.greenColor;
//           case BidStatus.notBidded: return MyColors.yellowColor;
//           case BidStatus.rejected: return MyColors.redColor;
//           default: return MyColors.yellowColor;
//         }
//
//       };
//       case ShipmentStatus.running: return MyColors.greenColor;
//       case ShipmentStatus.rejected: return MyColors.redColor;
//       case ShipmentStatus.completed: return MyColors.greenColor;
//       case ShipmentStatus.applied: return MyColors.greenColor;
//
//       default: return MyColors.yellowColor;
//     }
//   }
//
//
//   static Color getTextColor(int status,{required int bidStatus}){
//     switch(status){
//       case  ShipmentStatus.pending:{
//         switch(bidStatus){
//           case BidStatus.applied: return MyColors.whiteColor;
//           case BidStatus.accepted: return MyColors.whiteColor;
//           case BidStatus.notBidded: return MyColors.blackColor;
//           case BidStatus.rejected: return MyColors.whiteColor;
//           default: return MyColors.blackColor;
//         }
//       };
//       case ShipmentStatus.running: return MyColors.whiteColor;
//       case ShipmentStatus.rejected: return MyColors.whiteColor;
//       case ShipmentStatus.completed: return MyColors.whiteColor;
//       case ShipmentStatus.applied: return MyColors.whiteColor;
//       default: return MyColors.blackColor;
//     }
//   }
// }