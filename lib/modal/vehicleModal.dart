
import '../constants/api_keys.dart';
import '../functions/print_function.dart';

class VehicleModal {
  String? vehicleRegistrationImage;
  String vehicle_no;
  String license_number;
  String insurance_number;
  String vehicle_type;
  String? vehicle_model;
  String? driving_license_image;
  String userId;

  VehicleModal({
    required this.insurance_number,
    required this.vehicleRegistrationImage,
    required this.vehicle_type,
    required this.license_number,
    required this.vehicle_no,
    required this.vehicle_model,
    required this.driving_license_image,
    required this.userId,
  });

  factory VehicleModal.fromJson(Map json, String userId) {
    return VehicleModal(
      vehicle_no: json[ApiKeys.vehicle_no] ?? 'false',
      license_number: json[ApiKeys.license_number] ?? 'false',
      vehicle_model: json[ApiKeys.vehicle_model],
      driving_license_image: json[ApiKeys.driving_license_image] ,
      insurance_number: json[ApiKeys.insurance_number] ?? 'false',
      vehicle_type: json[ApiKeys.vehicle_type] ?? 'false',
      vehicleRegistrationImage: json[ApiKeys.vehicleRegistrationImage],
      userId: userId,
    );
  }

  static tryParse(Map json, String userId){
    try{
      return VehicleModal.fromJson(json, userId);
    }catch(e){
      myCustomLogStatements('Error in catch block of 3w534 :$userId $json $e');
      return null;
    }
  }
}
