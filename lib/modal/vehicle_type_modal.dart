import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/widget/custom_image.dart';

class VehicleTypeModal {
  String id;
  String title;
  String image;
  CustomFileType fileType;
  double vehicleBasePrice;
  double waitingChargePerMinute;
  double perKmPrice;
  double perMinCharge;
  Map fullData;

  VehicleTypeModal({
    required this.id,
    required this.title,
    required this.image,
    required this.fileType,
    required this.vehicleBasePrice,
    required this.waitingChargePerMinute,
    required this.perKmPrice,
    required this.perMinCharge,
    required this.fullData,
  });

  factory VehicleTypeModal.fromJson(Map json) {
    return VehicleTypeModal(
      id: json[ApiKeys.id],
      title: json[ApiKeys.title],
      image: json[ApiKeys.image],
      fileType: json[ApiKeys.fileType] == 'asset'
          ? CustomFileType.asset
          : CustomFileType.network,
      vehicleBasePrice:
          double.tryParse(json[ApiKeys.vehicleBasePrice].toString()) ?? 0,
      waitingChargePerMinute:
          double.tryParse(json[ApiKeys.waitingChargePerMinute].toString()) ?? 0,
      perKmPrice: double.tryParse(json[ApiKeys.perKmPrice].toString()) ?? 0,
      perMinCharge: double.tryParse(json[ApiKeys.perMinCharge].toString()) ?? 0,
      fullData: json,
    );
  }

  toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.image: image,
      ApiKeys.fileType: fileType == CustomFileType.asset ? 'asset' : 'network',
      ApiKeys.vehicleBasePrice: vehicleBasePrice,
      ApiKeys.waitingChargePerMinute: waitingChargePerMinute,
      ApiKeys.perKmPrice: perKmPrice,
      ApiKeys.perMinCharge: perMinCharge,
    };
  }
}
