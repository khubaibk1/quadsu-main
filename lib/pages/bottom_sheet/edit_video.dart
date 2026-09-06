import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/functions/validation_functions.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/image_picker.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import 'package:path_provider/path_provider.dart';

class EditVideos extends StatefulWidget {
  const EditVideos({super.key});

  @override
  State<EditVideos> createState() => _EditVideosState();
}

class _EditVideosState extends State<EditVideos> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> reload = ValueNotifier(false);

  final titleController = TextEditingController();
  File? videoFile;
  File? videoThumbnailFile;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child) {
            return Consumer<MyAuthProvider>(
                builder: (context, myAuthProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox3,
                  CustomText.headingSmall(
                    'Videos',
                    fontWeight: FontWeight.w600,
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: titleController,
                    headingText: 'Video Title',
                    hintText: "Write here..",
                    hintTextFontSize: 14,
                    fontSize: 14,
                    contentPaddingVertical: 11,
                    validator: (val) {
                      return ValidationFunction.requiredValidation(val);
                    },
                    keyboardType: TextInputType.text,
                  ),
                  vSizedBox2,
                  CustomText.textFieldHeading(
                    "Upload Video",
                    color: MyColors.blackColor,
                  ),
                  vSizedBox,
                  if (videoThumbnailFile == null)
                    InkWell(
                      onTap: () async {
                        var temp = await videoPickerDialog(
                            MyGlobalKeys.navigatorKey.currentContext!,
                            shouldCompress: true);
                        if (temp != null) {
                          try {
                            videoFile = temp;
                            EasyLoading.show();
                            Uint8List? uint8list = await VideoThumbnail.thumbnailData(
                              video: temp.path,
                              imageFormat: ImageFormat.JPEG,
                              maxWidth: 400,
                              // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                              maxHeight: 400,
                              quality: 50,
                            );
                            final tempDir = await getTemporaryDirectory();
                            File? thumbnail = await File(
                                    '${tempDir.path}/${Timestamp.now().millisecondsSinceEpoch}.png')
                                .create();
                            thumbnail.writeAsBytesSync(uint8list!.toList());
                            videoThumbnailFile = thumbnail;
                            reload.value = !reload.value;
                            EasyLoading.dismiss();
                          } catch (e) {
                            showSnackbar("Something went wrong");
                            EasyLoading.dismiss();
                          }
                        }
                        reload.value = !reload.value;
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColors.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.file_upload_outlined,
                          color: MyColors.primaryColor,
                          size: 24,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 130,
                      width: 139,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                videoThumbnailFile!,
                                height: 100,
                                width: 130,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                           Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  videoFile=null;
                                  videoThumbnailFile=null;
                                  reload.value=!reload.value;
                                },
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(
                                    color:  MyColors.redColor,
                                  )),
                                  child:  const Icon(
                                    Icons.close,
                                    color: MyColors.redColor,
                                    size: 20,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  vSizedBox2,
                  CustomButton(
                    height: 50,
                    borderRadius: 4,
                    text: 'Save',
                    fontWeight: FontWeight.w600,
                    onTap: () async {
                      print('dtadtadta::::::::$videoFile');
                      print('dtadtadta::::::::$videoThumbnailFile');
                      if (formKey.currentState!.validate()) {
                        if (videoFile == null) {
                          showSnackbar('Please select video');
                          return;
                        }
                        EasyLoading.show();
                        String? videoUrl =
                            await NewestWebServices.uploadImageAndGetUrl(
                                videoFile!.path,
                                isVideo: true);
                        String? videoThumbnailUrl =
                            await NewestWebServices.uploadImageAndGetUrl(
                                videoThumbnailFile!.path);

                        Map<String, dynamic> request = {
                          ApiKeys.videoTitle: titleController.text.trim(),
                          ApiKeys.videoUrl: videoUrl,
                          ApiKeys.videoThumbnailUrl: videoThumbnailUrl,
                        };
                        // ignore: use_build_context_synchronously
                        myAuthProvider.editVideo(context, request: request);
                      }
                    },
                  )
                ],
              );
            });
          }),
    );
  }
}
