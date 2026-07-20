
enum CustomAssetType { asset, network }

class NotificationModal {
  dynamic id;
  String title;
  String message;
  // DateTime time;
  String? iconUrl;
  CustomAssetType assetType;
  DateTime createdAt;
  Map otherData;
  Map fullData;

  NotificationModal({
    required this.id,
    required this.title,
    required this.message,
    // required this.time,
    required this.iconUrl,
    required this.otherData,
    required this.createdAt,
    required this.fullData,
    this.assetType = CustomAssetType.network,
  });

  factory NotificationModal.fromJson(Map data) {
    return NotificationModal(
      id: data['id'],
      title: data['title'],
      message: data['body'],
      createdAt: DateTime.parse(data['created_at']??DateTime.now().toString()),
      // time: data['time'],
      iconUrl: data['icon'],
      fullData: data,
      otherData: data['other']??data['data'],

      // assetType: data['assetType'],
    );
  }
}

// List<NotificationModal> sampleNotifications = [
//   NotificationModal(
//     id: 1,
//     heading: 'Booking',
//     message: 'Manish has approved your booking request. View Booking.',
//     time: DateTime.now().subtract(Duration(days: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
//   NotificationModal(
//     id: 2,
//     heading: 'Booking',
//     message: 'Manish has declined your booking request. View Booking.',
//     time: DateTime.now().subtract(Duration(hours: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
//   NotificationModal(
//     id: 3,
//     heading: 'Booking',
//     message: 'Rajesh has updated the booking details. View Booking.',
//     time: DateTime.now().subtract(Duration(minutes: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
//   NotificationModal(
//     id: 4,
//     heading: 'Booking',
//     message: 'Rajesh has updated the booking details. View Booking.',
//     time: DateTime.now().subtract(Duration(minutes: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
//   NotificationModal(
//     id: 5,
//     heading: 'Booking',
//     message: 'Rajesh has updated the booking details. View Booking.',
//     time: DateTime.now().subtract(Duration(minutes: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
//   NotificationModal(
//     id: 6,
//     heading: 'Booking',
//     message: 'Rajesh has updated the booking details. View Booking.',
//     time: DateTime.now().subtract(Duration(minutes: 2)),
//     iconUrl: MyImagesUrl.becomeASitter,
//   ),
// ];
