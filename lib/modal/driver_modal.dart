// import 'package:quadsu_app/constants/api_keys.dart';
//
//
// class DriverDetails {
//   int user_id;
//   String id_proof;
//   String driving_license;
//   int vehicle_type;
//   String vehicle_no;
//   String vehicle_year;
//   String vehicle_make;
//   int vehicle_model;
//   String created_at;
//   String updated_at;
//
//   DriverDetails({
//     required this.user_id,
//     required this.id_proof,
//     required this.driving_license,
//     required this.vehicle_type,
//     required this.vehicle_no,
//     required this.vehicle_year,
//     required this.vehicle_make,
//     required this.vehicle_model,
//     required this.created_at,
//     required this.updated_at,
//   });
//
//   factory DriverDetails.fromJson(Map json) {
//     return DriverDetails(
//       user_id: json[ApiKeys.user_id],
//       id_proof: json[ApiKeys.id_proof],
//       driving_license: json[ApiKeys.driving_license_image],
//       vehicle_type: json[ApiKeys.vehicle_type],
//       vehicle_no: json[ApiKeys.vehicle_no],
//       vehicle_year: json[ApiKeys.vehicle_year],
//       vehicle_make: json[ApiKeys.vehicle_make],
//       vehicle_model: json[ApiKeys.vehicle_model],
//       created_at: json[ApiKeys.created_at],
//       updated_at: json[ApiKeys.updated_at],
//     );
//   }
//
//
//   static  DriverDetails? tryParse(Map? json){
//
//     try{
//       return DriverDetails.fromJson(json!);
//     }catch(e){
//
//       print('Error in catch block in json $e');
//       // return DriverDetails.fromJson(json!);
//       return null;
//     }
//
//     // return UserModal.fromJson(json);
//   }
// }
