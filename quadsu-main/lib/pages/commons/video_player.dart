import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:video_player/video_player.dart';

import '../../widget/custom_appbar.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String? title;
  final String? url;

  const CustomVideoPlayer({super.key, this.title, this.url});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  ValueNotifier<Widget> playerWidget = ValueNotifier(
    const Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.url!));
        await videoPlayerController?.initialize();
        final chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: false,
        );
        playerWidget.value = Chewie(controller: chewieController);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: widget.title?? 'Session Recordings',
        isBackIcon: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.15),
        child: ValueListenableBuilder(
          valueListenable: playerWidget,
            builder: (context, value, child) {
            return value;
          },
        ),
      ),
    );
  }
}
