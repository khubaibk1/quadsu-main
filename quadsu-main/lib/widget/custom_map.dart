// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:quadsu_app/constants/sized_box.dart';
// import 'package:quadsu_app/widget/old_custom_text.dart';
// import 'package:quadsu_app/widget/custom_button.dart';
// import 'package:quadsu_app/widget/show_snackbar.dart';
// import 'package:provider/provider.dart';
// import '../constants/my_colors.dart';
// import '../constants/my_image_url.dart';
// import '../functions/print_function.dart';
// import '../modal/shipment_modal.dart';
// import '../modal/shipment_packages.dart';
// import '../provider/location_provider.dart';
// import 'package:custom_info_window/custom_info_window.dart';
//
// class CustomMap extends StatefulWidget {
//   LatLng startDestination;
//   LatLng endDestination;
//   List<LatLng> wayPoints;
//   ShipmentModal shipmentModal;
//   CustomMap({
//     required this.startDestination,
//     required this.endDestination,
//     required this.shipmentModal,
//      this.wayPoints = const[],
//     super.key,
//   });
//
//   @override
//   State<CustomMap> createState() => _CustomMapState();
// }
//
// class _CustomMapState extends State<CustomMap> {
//   CustomInfoWindowController customInfoWindowController =
//   CustomInfoWindowController();
//
//   Set<Marker> getAllMarkers(){
//     List<Marker> markers = [];
//     markers.addAll(List.generate(widget.wayPoints.length, (index){
//       return getMarker(latLng: widget.wayPoints[index], id: 'index_$index', icon: MyImagesUrl.logout, parcelModal: widget.shipmentModal.shipmentPackages[index]);
//     }));
//     markers.add(getMarker(latLng: widget.startDestination, id: '1', icon: MyImagesUrl.logout, isStart: true),);
//     markers.add(getMarker(latLng: widget.endDestination, id: '2', icon: MyImagesUrl.companyMarkerIconList,isStart: false));
//
//     return markers.toSet();
//   }
//
//   Marker getMarker({
//     required LatLng latLng,
//     required String id,
//      ShipmentPackageModal? parcelModal,
//     bool? isStart,
//     List<int>? icon,
//   }) {
//     myCustomPrintStatement('the marker is ${id}...${latLng}');
//     return Marker(
//       markerId: MarkerId('$id'),
//       position: latLng,
//       onTap: (){
//         print('custom info window initializing');
//         customInfoWindowController.addInfoWindow!(
//           Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child:
//                   // parcelModal==null?
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     child: isStart==false?
//                     Column(
//                       children: [
//                         Image.asset(
//                           MyImagesUrl.logout,
//                           height: 35,
//                           width: 30,
//                         ),
//                         // vSizedBox,
//                         SubHeadingText(
//                           'Start Point',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         Row(
//                           children: [
//                             Image.asset(
//                               MyImagesUrl.location,
//                               height: 14,
//                               width: 14,
//                               color: MyColors.primaryColor,
//                             ),
//                             hSizedBox,
//                             Expanded(child: ParagraphText('${widget.shipmentModal.pickup_address}', fontWeight: FontWeight.w300,maxLines: 2,)),
//                           ],
//                         )
//                       ],
//                     ):
//                     Column(
//                       children: [
//                         Image.asset(
//                           MyImagesUrl.logout,
//                           height: 35,
//                           width: 30,
//                         ),
//                         // vSizedBox,
//                         SubHeadingText(
//                           'End Point',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         Row(
//                           children: [
//                             Image.asset(
//                               MyImagesUrl.location,
//                               height: 14,
//                               width: 14,
//                               color: MyColors.primaryColor,
//                             ),
//                             hSizedBox,
//                             Expanded(child: ParagraphText('${widget.shipmentModal.drop_address}', fontWeight: FontWeight.w300,maxLines: 2,)),
//                           ],
//                         )
//                       ],
//                     ))
//                 // : ParcelCard(
//                     // parcelModal: parcelModal,
//                   // ),
//
//                 ),
//               ),
//
//             ],
//           ),
//           latLng,
//         );
//       },
//         // print('custom info window initialized');
//       // infoWindow: InfoWindow(
//       //
//       //   title: '\ndklslsjf'
//       // ),
//       // onTap: (){
//       //
//       // },
//
//       icon:icon==null?BitmapDescriptor.defaultMarker: BitmapDescriptor.fromBytes(Uint8List.fromList(icon))
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyLocationProvider>(
//         builder: (context, myLocationProvider, child) {
//       return FutureBuilder(
//         future: myLocationProvider.getCoordinatesBetweenTwoPoints(
//             widget.startDestination,
//             widget.endDestination, wayPoints: widget.wayPoints),
//         builder: (context, snapshot) {
//           myCustomPrintStatement('the data is ${snapshot.data}');
//           if (!snapshot.hasData) {
//             return Container();
//           }
//           return Container(
//             height: MediaQuery.of(context).size.height-100,
//             child: Stack(
//               children: [
//                 GoogleMap(
//                   gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//                     Factory<OneSequenceGestureRecognizer>(
//                       () => EagerGestureRecognizer(),
//                     ),
//                   },
//                   initialCameraPosition: CameraPosition(
//                     // target: LatLng(
//                     //     myLocationProvider.latitude, myLocationProvider.longitude),
//                     target: widget.startDestination,
//                     zoom: 10,
//                   ),
//                   polylines: {
//                     Polyline(
//                         polylineId: PolylineId('path'),
//                         color: Colors.blue,
//                         width: 5,
//                         points: snapshot.data ?? []),
//                   },
//                   markers: getAllMarkers(),
//                   onTap: (position) {
//                     customInfoWindowController.hideInfoWindow!();
//                   },
//                   onCameraMove: (position) {
//                     customInfoWindowController.onCameraMove!();
//                   },
//                   onMapCreated: (GoogleMapController controller) async {
//                     customInfoWindowController.googleMapController = controller;
//                   },
//                 ),
//                 CustomInfoWindow(
//                   controller: customInfoWindowController,
//                   height: 120,
//                   width: 300,
//                   offset: 50,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   // left: 20,
//                   right: 60,
//                   child: RoundEdgedButton(
//                     text: 'Start',
//                     width: 100,
//                     color: MyColors.greyColor,
//                     textColor: Colors.black26,
//                     onTap: (){
//                       showSnackbar('Coming soon');
//                     },
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
