import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quadsu_app/functions/print_function.dart';


var apiGoogleAutoComplete =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json';
var apiGooglePlaceDetails =
    'https://maps.googleapis.com/maps/api/place/details/json';
 var keyPlaceId = "place_id";
 var keyKey = "key";
 var keyInput = "input";
var  googleApiKey="AIzaSyBZ-2VSmvUZxkm4eIL6Vbm41RPPbJUS2zo";

Future<GetLocation?> getGoogleAutoCompleteApi({required String value}) async {


     final Uri uri = Uri.parse(
      '$apiGoogleAutoComplete?$keyInput=$value&$keyKey=$googleApiKey',
    );

     print("urlrlrlrlrl:::::::$uri");
  final response = await http.get(uri);
   if(response.statusCode==200)
     {
       print("dodododododododod${response.body}");
       GetLocation? getLocation;
       getLocation = GetLocation.fromJson(jsonDecode(response.body));

       return getLocation;
     }
   else
     {
       return null ;
     }
}

Future<AddressModal> getPlaceDetails(String placeId) async {
  final Uri uri = Uri.parse(
    '$apiGooglePlaceDetails?$keyPlaceId=$placeId&$keyKey=$googleApiKey',
  );

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    myCustomPrintStatement("my address response is that $data");
    final location = data['result']['geometry']['location'];

    var addressData = {
      "cityName": extractData(data, "administrative_area_level_3").isEmpty
          ? extractData(data, "administrative_area_level_2")
          : extractData(data, "administrative_area_level_3"),
      "stateName": extractData(data, "administrative_area_level_1"),
      "countryName": extractData(data, "country"),
      "pincode": extractData(data, "postal_code"),
      "lat": location['lat'],
      "lng": location['lng'],
    };
    return AddressModal.formJson(addressData);
  } else {
    throw Exception('Failed to load place details');
  }
}

String extractData(Map<String, dynamic> data, String componentType) {
  final List<dynamic> results = data['result']['address_components'] ?? [];
  for (final component in results) {
    final List<dynamic> types = component['types'] ?? [];
    if (types.contains(componentType)) {
      return component['long_name'];
    }
  }
  return '';
}


class AddressModal {
  String city;
  String country;
  String state;
  String pincode;
  String lat;
  String lng;

  AddressModal({
    required this.city,
    required this.country,
    required this.pincode,
    required this.state,
    required this.lng,
    required this.lat,
  });

  factory AddressModal.formJson(data) {
    return AddressModal(
      city: data['cityName'],
      country: data['countryName'],
      pincode: data['pincode'],
      state: data['stateName'],
      lat: data['lat'].toString(),
      lng: data['lng'].toString(),
    );
  }

  toJson() {
    return {
      'cityName': city,
      'countryName': country,
      'pincode': pincode,
      'stateName': state,
      "lat": lat,
      "lng": lng
    };
  }
}

class GetLocation {
  List<Predictions>? predictions;
  String? status;

  GetLocation({this.predictions, this.status});

  GetLocation.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Predictions {
  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Predictions(
      {this.description,
        this.matchedSubstrings,
        this.placeId,
        this.reference,
        this.structuredFormatting,
        this.terms,
        this.types});

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = <MatchedSubstrings>[];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings!.add(MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) {
        terms!.add(Terms.fromJson(v));
      });
    }
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    if (matchedSubstrings != null) {
      data['matched_substrings'] =
          matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    data['types'] = types;
    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];

    secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_text'] = mainText;

    data['secondary_text'] = secondaryText;
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}
