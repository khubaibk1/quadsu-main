class PopularProviderModal {
String userName;
String serviceType;
String rating;
String views;
List serviceList;
PopularProviderModal(
    {required this.serviceList,
      required this.userName,
      required this.rating,
      required this.views,
      required this.serviceType,
    });
factory PopularProviderModal.fromJson(Map json) {
return PopularProviderModal(
  userName: json['name'],
  serviceList: json['serviceList'],
  rating: json['rating'],
  views: json['views'],
  serviceType: json['serviceType'],
);
}
}
