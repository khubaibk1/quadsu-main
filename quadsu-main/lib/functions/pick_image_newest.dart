import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/my_colors.dart';

Future<File?> cameraImagePicker(
  BuildContext context, {
  CropStyle? cropStyle,
  CropAspectRatio? aspectRatio,
}) async {
  return showCupertinoModalPopup(
      barrierColor: MyColors.blackColor.withOpacity(0.6),
      context: context,
      builder: (_) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    File? image;
                    image = await pickImage(false,
                        cropStyle: cropStyle, aspectRatio: aspectRatio);
                    print('image--2--$image');
                    if (image != null) {
                      Navigator.pop(context, image);
                    }
                  },
                  child: CustomText.buttonText(
                    'Take a picture',
                    color: MyColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    File? image;
                    image = await pickImage(true,
                        prefferedCameraDevice: CameraDevice.front,
                        cropStyle: cropStyle,
                        aspectRatio: aspectRatio);
                    print('image--4--$image');
                    Navigator.pop(context, image);
                  },
                  child: CustomText.buttonText(
                    'Gallery',
                    color: MyColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
            ],
            cancelButton: CupertinoActionSheetAction(
                onPressed: () => CustomNavigation.pop(context),
                child: CustomText.buttonText(
                  'Close',
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
          ));
}

Future<File?> pickImage(bool isGallery,
    {CameraDevice prefferedCameraDevice = CameraDevice.rear,
    CropStyle? cropStyle,
    CropAspectRatio? aspectRatio}) async {
  final ImagePicker picker = ImagePicker();

  File? image;
  String? imageFile;
  try {
    int imageQualityPercent = 80;
    print('about to pick image with image quality $imageQualityPercent');
    XFile? pickedFile;
    if (isGallery) {
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQualityPercent,
          maxHeight: 600);
    } else {
      pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: imageQualityPercent,
          preferredCameraDevice: prefferedCameraDevice,
          maxHeight: 600);
    }
    print('the error is $pickedFile');
    int length = await pickedFile!.length();
    print('the length is');
    // print('size : ${length}');
    print('size: ${await pickedFile.readAsBytes()}');
    CroppedFile? croppedFile = await ImageCropper().cropImage(
     // cropStyle: cropStyle ?? CropStyle.circle,
      aspectRatio: aspectRatio,
      // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: length > 100000
          ? length > 200000
              ? length > 300000
                  ? length > 400000
                      ? 5
                      : 10
                  : 20
              : 30
          : 50,
      sourcePath: pickedFile.path,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   // CropAspectRatioPreset.ratio3x2,
      //   // CropAspectRatioPreset.original,
      //   // CropAspectRatioPreset.ratio4x3,
      //   // CropAspectRatioPreset.ratio16x9
      // ],
      // androidUiSettings: const AndroidUiSettings(
      //     activeControlsWidgetColor: MyColors.primaryColor,
      //     toolbarTitle: 'Adjust your Post',
      //     toolbarColor: MyColors.primaryColor,
      //     toolbarWidgetColor: MyColors.blackColor,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: true),
      // iosUiSettings: const IOSUiSettings(
      //   minimumAspectRatio: 1.0,
      // )
    );

    imageFile = croppedFile!.path;
    image = File(croppedFile.path);
    print(image);
    return image;
  } catch (e) {
    print("Image picker error $e");
  }
  return null;
}
