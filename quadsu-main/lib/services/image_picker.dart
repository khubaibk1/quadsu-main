import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/image_picker.dart';

Future<File?> cameraImagePicker(BuildContext ctx, {bool shouldCrop = true}) async {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () async {
                File? image;
                image = await pickImage(false);
                print('image--2--$image');
                if (image != null) {
                  Navigator.pop(ctx, image);
                }
              },
              child: CustomText.headingSmall(
                'Take a picture',
                color: MyColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          CupertinoActionSheetAction(
              onPressed: () async {
                File? image;
                image = await pickImage(true);
                print('image--4--$image');
                Navigator.pop(ctx, image);
              },
              child: CustomText.headingSmall(
                'Gallery',
                color: MyColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => CustomNavigation.pop(ctx),
            child: CustomText.headingSmall(
              'Close',
              color: MyColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
      ));
}

Future<File?> videoPickerDialog(BuildContext context,
    {bool shouldCrop = true, bool shouldCompress = false}) async {
  return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () async {
                File? video;
                video = await pickVideo(
                    isGallery: false, shouldCompress: shouldCompress);
                print('video--2--$video');
                if (video != null) {
                  Navigator.pop(context, video);
                }
              },
              child: CustomText.headingSmall(
                'Record a Video',
                color: MyColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          CupertinoActionSheetAction(
              onPressed: () async {
                File? video;
                video = await pickVideo(
                    isGallery: true, shouldCompress: shouldCompress);
                print('video--4--$video');
                if (video != null) {
                  Navigator.pop(context, video);
                }
              },
              child: CustomText.headingSmall(
                'Gallery',
                color: MyColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => CustomNavigation.pop(context),
            child: CustomText.headingSmall(
              'Close',
              color: MyColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
      ));
}

Future<File?> pickVideo(
    {bool isGallery = true, bool shouldCompress = false}) async {
  final ImagePicker picker = ImagePicker();
  File? video;

  try {
    XFile? pickedVideo;
    if (isGallery) {
      pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedVideo = await picker.pickVideo(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear);
    }

    if (pickedVideo == null) {
      print('No video selected');
      return null;
    }

    if (shouldCompress) {
      EasyLoading.show(status: 'Compressing video...');

      try {
        // Get original file size
        File originalFile = File(pickedVideo.path);
        int originalFileSize = await originalFile.length();
        print('Before compress video: $originalFileSize bytes');

        // Generate unique video name
        final String videoName = 'compressed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

        // Compress video using light_compressor
        final LightCompressor lightCompressor = LightCompressor();
        final Result response = await lightCompressor.compressVideo(
          path: pickedVideo.path,
          videoQuality: VideoQuality.low,
          isMinBitrateCheckEnabled: false,
          video: Video(videoName: videoName),
          android: AndroidConfig(
            isSharedStorage: false,
          ),
          ios: IOSConfig(
            saveInGallery: false,
          ),
        );

        EasyLoading.dismiss();

        if (response is OnSuccess) {
          video = File(response.destinationPath);
          int compressedFileSize = await video.length();
          print('After compress video: $compressedFileSize bytes');
          print('Compression saved: ${originalFileSize - compressedFileSize} bytes');
          return video;
        } else if (response is OnFailure) {
          print('Compression failed: ${response.message}');
          EasyLoading.showError('Video compression failed');
          return null;
        } else if (response is OnCancelled) {
          print('Compression cancelled');
          return null;
        }
      } catch (compressionError) {
        EasyLoading.dismiss();
        print('Compression error: $compressionError');
        EasyLoading.showError('Failed to compress video');
        return null;
      }
    } else {
      int videoLength = await pickedVideo.length();
      print('The length of the video is: $videoLength bytes');

      // Uncomment if you want to enforce size limits
      // if (videoLength > 10485760) {
      //   showSnackbar(context, 'Video must be less than 10 MB');
      //   return null;
      // }

      video = File(pickedVideo.path);
      return video;
    }
  } catch (e) {
    EasyLoading.dismiss();
    print('Error in picking video: $e');
    return null;
  }

  return null;
}