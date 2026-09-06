import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference adminSettingsCollection =
  FirebaseFirestore.instance.collection('adminSettings');


  static final CollectionReference vehicleTypesCollection =
  FirebaseFirestore.instance.collection('vehicle_types');

  static final DocumentReference<Object?> appSettingsdocument = adminSettingsCollection.doc('appParameters');
  static CollectionReference sessionCollection(String userId) {
    return users.doc(userId).collection('sessions');
  }
  static CollectionReference banksCollection(String userId) {
    return users.doc(userId).collection('banks');
  }

  static final CollectionReference logsCollection =
  FirebaseFirestore.instance.collection('logs');

  static final CollectionReference liveBookings =
  FirebaseFirestore.instance.collection('liveBookings');
  static final CollectionReference cancelledBookings =
  FirebaseFirestore.instance.collection('cancelledBookings');
  static final CollectionReference bookingHistory =
      FirebaseFirestore.instance.collection('bookingHistory');
static final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('rooms');

  static CollectionReference notificationCollection(String userId) {
    return users.doc(userId).collection('notifications');
  }


}
