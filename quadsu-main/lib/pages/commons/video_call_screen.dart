import 'package:flutter/material.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body:Image.asset(MyImagesUrl.image05,
      fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
      )
    );
  }
}
