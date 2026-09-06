import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/services/metting_services/meeting_provider.dart';
import 'package:quadsu_app/services/metting_services/meeting_remote_users_modal.dart';
import 'package:quadsu_app/widget/common_alert_dailog.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MeetingVideoCallScreen extends StatefulWidget {
  final String channelId;
  final String meetingTitle;
  final String meetingUrl;
  final bool isCreate;

  const MeetingVideoCallScreen(
      {super.key,
      required this.channelId,
      required this.meetingTitle,
      required this.isCreate, required this.meetingUrl});

  @override
  State<MeetingVideoCallScreen> createState() => _MeetingVideoCallScreenState();
}

class _MeetingVideoCallScreenState extends State<MeetingVideoCallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      WakelockPlus.enable();

      Provider.of<MeetingProvider>(context, listen: false).bookingId=widget.channelId;
      Provider.of<MeetingProvider>(context, listen: false).url=widget.meetingUrl;
      Provider.of<MeetingProvider>(context, listen: false).initAgora(
          cI: widget.channelId,
          isCreate: widget.isCreate,
          request: widget.isCreate ? {
           ApiKeys.bookingId:widget.channelId
          } : {
            ApiKeys.bookingId:widget.channelId,
            ApiKeys.url:widget.meetingUrl
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("didididiiiidid");
    Provider.of<MeetingProvider>(MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .disposeCall();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return  await showCommonAlertDailog(context,
            headingText: "Are you sure?",
            message: "Do you want to leave from\this meeting",
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: "No",
                    color: MyColors.greyColor,
                    textColor: MyColors.blackColor,
                    width: 100,
                    height: 40,
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  hSizedBox2,
                  CustomButton(
                    text: "Yes",
                    width: 100,
                    height: 40,
                    onTap: () {
                      Navigator.pop(context, true);
                      if(Navigator.canPop(context)) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                  hSizedBox,
                ],
              ),
            ],
            imageUrl: MyImagesUrl.logout);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: widget.meetingTitle,
          isBackIcon: true,
          isNotificationIcon: false,
          onPressed: () async {
            bool? v= await showCommonAlertDailog(context,
                headingText: "Are you sure?",
                message: "Do you want to leave from\nthis meeting",
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "No",
                        color: MyColors.greyColor,
                        textColor: MyColors.blackColor,
                        width: 100,
                        height: 40,
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      hSizedBox2,
                      CustomButton(
                        text: "Yes",
                        width: 100,
                        height: 40,
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      hSizedBox,
                    ],
                  ),
                ],
                imageUrl: MyImagesUrl.logout);
            if(v==true)
              {
                Navigator.pop(context, true);
              }
          },
        ),
        body: Consumer<MeetingProvider>(
          builder: (context, meetingProvider, child) => Column(
            children: [
              Expanded(child: _buildGridView(meetingProvider: meetingProvider)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: meetingProvider.micIsOn ? Icons.mic : Icons.mic_off,
                      onPressed: () {
                        meetingProvider.turnOnOffMic();
                      },
                      iconColor: !meetingProvider.micIsOn
                          ? MyColors.whiteColor
                          : MyColors.blackColor,
                      color: !meetingProvider.micIsOn
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                    ),
                    _buildControlButton(
                      onPressed: () {
                        meetingProvider.turnOnOffCamera();
                        // me
                      },
                      icon: meetingProvider.cameraIsOn
                          ? Icons.videocam
                          : Icons.videocam_off,
                      iconColor: !meetingProvider.cameraIsOn
                          ? MyColors.whiteColor
                          : MyColors.blackColor,
                      color: !meetingProvider.cameraIsOn
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                    ),
                    _buildControlButton(
                      onPressed: () {
                        meetingProvider.switchCameraFrontAndBack();
                      },
                      icon: meetingProvider.frontCameraIsOn
                          ? Icons.cameraswitch_outlined
                          : Icons.cameraswitch_outlined,
                      iconColor: !meetingProvider.frontCameraIsOn
                          ? MyColors.whiteColor
                          : MyColors.blackColor,
                      color: !meetingProvider.frontCameraIsOn
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                    ), _buildControlButton(
                      onPressed: () {
                        meetingProvider.startRecording();
                      },
                      icon: meetingProvider.recordingOn=="2"
                          ? Icons.radio_button_checked
                          : Icons.fiber_manual_record,
                      iconColor:  meetingProvider.recordingOn=="2"
                          ? MyColors.whiteColor
                          : MyColors.blackColor,
                      color:  meetingProvider.recordingOn=="2"
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                    ),
                    // _buildControlButton(
                    //   icon: Icons.chat,
                    //   onPressed: () {
                    //     showSnackbar("Comming Soon......");
                    //   },
                    //   color: Colors.grey.shade200,
                    // ),
                    // _buildControlButton(
                    //   icon: Icons.more_vert,
                    //   color: Colors.grey.shade200,
                    // ),
                    _buildControlButton(
                      icon: Icons.call_end,
                      onPressed: () async {
                        bool? v= await showCommonAlertDailog(context,
                            headingText: "Are you sure?",
                            message: "Do you want to leave from\nthis meeting",
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButton(
                                    text: "No",
                                    color: MyColors.greyColor,
                                    textColor: MyColors.blackColor,
                                    width: 100,
                                    height: 40,
                                    onTap: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  hSizedBox2,
                                  CustomButton(
                                    text: "Yes",
                                    width: 100,
                                    height: 40,
                                    onTap: () {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                  hSizedBox,
                                ],
                              ),
                            ],
                            imageUrl: MyImagesUrl.logout);
                        if(v==true)
                        {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, true);
                        }
                        },
                      color: Colors.redAccent,
                      iconColor: Colors.white,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView({required MeetingProvider meetingProvider}) {
    List<Widget> views = [
      Center(
        child: Stack(
          children: [
            meetingProvider.localUserJoined && meetingProvider.cameraIsOn
                ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: meetingProvider.engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  )
                : meetingProvider.localUserJoined
                    ? const CustomImage(
                        imageUrl: MyImagesUrl.profileImage,
                        fit: BoxFit.fill,
                        height: 200,
                        width: 200,
                        fileType: CustomFileType.asset,
                      )
                    : const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)),
                      child: CustomText.bodyText1(
                        "Me",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: meetingProvider.micIsOn
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      meetingProvider.micIsOn ? Icons.mic : Icons.mic_off,
                      color: meetingProvider.micIsOn
                          ? MyColors.whiteColor
                          : MyColors.blackColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]; // Start with the local user's view

    // Add remote user views
    for (var uid in meetingProvider.remoteUserUid) {
      views.add(
          _remoteVideo(remoteUser: uid, rtcEngine: meetingProvider.engine));
    }

    // Determine the grid layout based on the number of participants
    if (views.length == 1) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: CustomText.headingSmall(
            "You are the only one in the meeting, please wait for other users to join.",
            fontSize: 15,
          ),
        ),
      );
    }
    int count = views.length;
    if (count == 1) {
      return Center(child: views[0]); // Single user - full screen
    } else if (count == 2) {
      return Column(
        children: views.map((view) => Expanded(child: view)).toList(),
      ); // Two users - split screen
    } else if (count == 3) {
      return Column(
        children: [
          Expanded(
              child: Row(
                  children: views
                      .sublist(0, 2)
                      .map((view) => Expanded(child: view))
                      .toList())),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: views[2],
                ),
              ],
            ),
          )
        ],
      ); // Three users - 2 on top, 1 at bottom
    } else if (count == 4) {
      return GridView.count(
        crossAxisCount: 2,
        children: views,
      ); // Four users - 2x2 grid
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Customize as needed
        ),
        itemCount: views.length,
        itemBuilder: (context, index) => views[index],
      ); // More than four users - 3x3 grid or adjust as needed
    }
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    void Function()? onPressed,
    Color iconColor = Colors.black,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo(
      {required MeetingRemoteUsersModal remoteUser,
      required RtcEngine rtcEngine}) {
    return Stack(
      children: [
        remoteUser.cameraOn
            ? Consumer<MeetingProvider>(
              builder: (context, meetingProvider, child){
                return AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: rtcEngine,
                      canvas: VideoCanvas(uid: remoteUser.id),
                      connection:  RtcConnection(channelId: meetingProvider.channelId/*widget.channelId*/),
                    ),
                  );
              }
            )
            : Center(
                child: CustomImage(
                  imageUrl: remoteUser.profileImage.isEmpty
                      ? MyImagesUrl.profileImage
                      : remoteUser.profileImage,
                  fileType: remoteUser.profileImage.isEmpty
                      ? CustomFileType.asset
                      : CustomFileType.network,
                  fit: BoxFit.fill,
                  height: 200,
                  width: 200,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: CustomText.bodyText2(
                    remoteUser.name,
                    fontSize: 12,
                    maxLines: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: remoteUser.micOn
                      ? Colors.pinkAccent
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  remoteUser.micOn ? Icons.mic : Icons.mic_off,
                  color: remoteUser.micOn
                      ? MyColors.whiteColor
                      : MyColors.blackColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
