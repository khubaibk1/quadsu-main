// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quadsu_app/services/firebase_services/firebase_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/global_error_constants.dart';
import '../../functions/print_function.dart';
import '../../widget/show_snackbar.dart';

class FirebaseService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static const String firestoreBaseUrl =
      'https://firebasestorage.googleapis.com/v0/b/sidelick-app-403e4.appspot.com/o/';
  static const String endingUrl = '?alt=media';

  static getImageUrl(String name) {
    if (name.contains(firestoreBaseUrl)) {
      return name;
    }
    return '${firestoreBaseUrl}${name}${endingUrl}';
  }

  static Future<String> loginService(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showSnackbar('Invalid credentials.');
      } else {
        if (e.message != null) {
          showSnackbar(e.message!);
        }
      }
      return "";
    }
  }

  static Future<String> signupService(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      print("--------------------firebase exception------------------------");
      if (e.code == 'weak-password') {
        showSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(GlobalErrorConstants.accountAlreadyExist);
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  static addData({
    required String collectionName,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firebaseFirestore.collection('user').doc(userId).set(data);
  }

  static uploadImageAndGetUrl(String imagePath) async {
    String? url;
    var imageFile = File(imagePath);
    Reference ref = storage
        .ref()
        .child("Image-${DateTime.now().millisecondsSinceEpoch}.png");
    UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    });
    return url;
  }

  static Future<List<String>> uploadMultipleImages(List<XFile> images,
      {bool showloader = true}) async {
    List<String> imageURLs = [];
    if (showloader == true) {
      await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
    }
    for (XFile image in images) {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('Image -$fileName')
            .putFile(file);
        String downloadURL = await snapshot.ref.getDownloadURL();
        imageURLs.add(downloadURL);
      } catch (e) {
        myCustomPrintStatement('Error uploading image: $e');
      }
    }
    if (showloader == true) {
      await EasyLoading.dismiss();
    }
    return imageURLs;
  }

  UploadTask uploadImageAndGetSnapshotStream(String imagePath) {
    var url;
    var imageFile = File(imagePath);
    Reference ref = storage
        .ref()
        .child("Image-${DateTime.now().millisecondsSinceEpoch}.png");
    UploadTask uploadTask = ref.putFile(imageFile);

    return uploadTask;
  }

  Reference getFileReference({required String path}) {
    int random = Random().nextInt(103240);
    Reference ref = storage.ref().child(
        "${random}-${DateTime.now().millisecondsSinceEpoch}.${getFileExtension(path)}");
    return ref;
  }

  String getFileExtension(String filePath) {
    int lastIndex = filePath.lastIndexOf('.');

    return filePath.substring(lastIndex + 1);
  }

  Reference getAudioReference() {
    int random = Random().nextInt(103240);
    Reference ref = storage
        .ref()
        .child("${random}-${DateTime.now().millisecondsSinceEpoch}.m4a");
    return ref;
  }

  static Future<void> deleteUploadedImage(String imageUrl,
      {bool showLoader = true}) async {
    if (showLoader) {
      await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
    }
    try {
      myCustomPrintStatement(imageUrl);
      // Parse the image URL to extract the path or filename
      // For example, if your image URL is gs://your-bucket-name/path/to/image.jpg
      // You need to extract "path/to/image.jpg"
      // You may need to customize this parsing based on your specific URL structure
      final Uri uri = Uri.parse(imageUrl);
      final String imagePath = uri.path;
      final decodedImagePath = Uri.decodeComponent(imagePath);
      myCustomPrintStatement(
          "image delete path is that ${decodedImagePath.split("sidelick-app-403e4.appspot.com/o").last}");
      // Delete the image file from Firebase Storage
      final Reference storageRef = FirebaseStorage.instance.ref().child(
          decodedImagePath.split("sidelick-app-403e4.appspot.com/o").last);
      await storageRef.delete();

      // Image deletion successful
      myCustomPrintStatement('Image deleted successfully');
    } catch (error) {
      // Handle errors
      myCustomPrintStatement('Error deleting image: $error');
    }

    if (showLoader) {
      await EasyLoading.dismiss();
    }
  }

  static Future<bool> sendPasswordResetLink(email) async {
    await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      EasyLoading.dismiss();
      showSnackbar("Password reset link has been sent to your email");
      return true;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      print(e);
      if (e.code == "user-not-found") {
        showSnackbar("Email not found");
      } else if (e.code == "invalid-email") {
        showSnackbar("Invalid email");
      }

      return false;
    }
  }

  static Future saveLogs(Map request) async {
    FirebaseCollections.logsCollection.add(request);
  }

  // static Future<bool> changePassword(String oldpassword,String newpassword) async {
  //   // String email = userData!['email'];
  //
  //   // String password = "password";
  //   // String newPassword = "password";
  //
  //   await EasyLoading.show(
  //       status: null,
  //       maskType: EasyLoadingMaskType.black);
  //
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password:oldpassword,
  //     );
  //
  //
  //     return userCredential.user!.updatePassword(newpassword).then((_){
  //       print("Successfully changed password");
  //
  //       EasyLoading.dismiss();
  //       print('snackbaropen');
  //       showSnackBar(
  //           'Password changed successfully.');
  //       print('before returning true');
  //       return true;
  //
  //     }).catchError((error){
  //       EasyLoading.dismiss();
  //       // if(error=='')
  //       if(error.code.toString()=="weak-password"){
  //         showSnackBar('Password should be atlease 6 character');
  //
  //       }
  //       print("Password can't be changed" + error.code.toString());
  //       return false;
  //       //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
  //     });
  //
  //   } on FirebaseAuthException catch (e) {
  //
  //     EasyLoading.dismiss();
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       showSnackBar('Your password is incorrect.');
  //     }
  //     return false;
  //   }
  //
  //
  //
  // }
}
