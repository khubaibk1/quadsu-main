import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/functions/print_function.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/widget/common_alert_dailog.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_confirmation_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../constants/global_data.dart';
import '../../constants/sized_box.dart';
import '../../widget/show_snackbar.dart';
import 'meeting_remote_users_modal.dart';

class MeetingProvider extends ChangeNotifier {
  final String _appId = myAppSettings?.agoraAppid??""; //behlah
  bool localUserJoined = false;
  List<MeetingRemoteUsersModal> remoteUserUid = [];
  String channelId = "";
  String token = "";
  String randomUser = "";
  bool isEndedByGuide=false;
  late RtcEngine engine;
  String bookingId = "";
  String url = "";
  bool micIsOn = true;
  bool cameraIsOn = true;
  bool frontCameraIsOn = true;
  String recordingOn = "";
  Timer? timer;
  String callMessage = '';

  Future<void> initAgora(
      {required String cI,
      required bool isCreate,
      required Map<String, dynamic> request}) async {
    showCustomConfirmationDialog(
      isCancelButton: false,
      headingMessage: "Disclaimer",
      headingMessageColor: MyColors.primaryColor,
      description:
          "This Session May Be Recorded At The Discretion Of The Student Or Guide. All Recordings Are Monitored For Quality Assurance. Failure To Activate The Recording Option On Either Or Both Parties Constitutes The Acknowledgement And Understanding That QuadsU Is Unable To Provide Assistance For Any Action(S) Deemed Inappropriate For An Educational Setting Without A Video Record. Please Press OK To Acknowledge.",
      descriptionMessageFontSize: 14,
      horizontalPadding: 16,
    );

    await createMeeting(isCreate: isCreate, request: request);

    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = createAgoraRtcEngine();
    print("aaaapppppp::::::$_appId");
    await engine.initialize(
      RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

        await engine.setParameters('{"rtc.video.codec":"h264"}'); // Set video codec

    engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        localUserJoined = true;
        notifyListeners();
      }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        remoteUserUid.add(MeetingRemoteUsersModal(
            cameraOn: true,
            id: remoteUid,
            micOn: true,
            name: "",
            // name: "Guest ${remoteUserUid.length + 1}",
            profileImage: ""));
        notifyListeners();
        getUserDetailsAndAddUser(remoteUid);
      }, onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        var index =
            remoteUserUid.firstWhere((element) => element.id == remoteUid);
        if (index.name.isNotEmpty) {
          // showSnackbar("${index.name} has left the meeting.");
        }
        remoteUserUid.removeWhere((element) => element.id == remoteUid);
        notifyListeners();
      }, onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
        debugPrint("remote user camera $remoteUid left channel $state");
        var index =
            remoteUserUid.indexWhere((element) => element.id == remoteUid);
        if (state == RemoteVideoState.remoteVideoStateStopped) {
          if (index != -1) {
            remoteUserUid[index].cameraOn = false;
          }
        } else {
          if (index != -1) {
            remoteUserUid[index].cameraOn = true;
          }
        }
        notifyListeners();
      }, onRemoteAudioStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
        var index =
            remoteUserUid.indexWhere((element) => element.id == remoteUid);
        if (state == RemoteAudioState.remoteAudioStateStopped) {
          if (index != -1) {
            remoteUserUid[index].micOn = false;
          }
        } else {
          if (index != -1) {
            remoteUserUid[index].micOn = true;
          }
        }
        notifyListeners();
      }, onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        debugPrint(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      }, onError: (ee, sdfa) {
        myCustomPrintStatement('video call -----Error $ee......$sdfa');
      }, onFirstRemoteVideoFrame: (l, d, z, x, y) {
        myCustomPrintStatement(
            'video call -----onFirstRemoteVideoFrame...$l...$d,....$z....$x....$y');
      }),
    );


    print("datdatdatdta:::::::::::$channelId");
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.enableLocalVideo(true);
    await engine.startPreview();
    await engine.joinChannel(
      token: token,
      // token:"",
      // token: null,
      channelId: channelId,
      // channelId: channelId,
      uid: usertype==UserType.guide?userDataNotifier.value == null
          ? Random().hashCode
          : userDataNotifier.value!.userId:int.parse(randomUser),
      options: const ChannelMediaOptions(
          // publishCameraTrack: true,
          ),
    );
    notifyListeners();
  }

  Future<void> createMeeting(
      {required Map<String, dynamic> request, required bool isCreate}) async {
    var response = await NewestWebServices.getResponse(
      request: request,
      apiUrl: isCreate ? ApiUrls.createMeeting : ApiUrls.joinMeeting,
    );

    EasyLoading.dismiss();
    myCustomLogStatements("CUSTOM LOG ${response.data}");

    if (response.status == 1) {
      if(usertype==UserType.guide)
        {
          token = response.data['meeting']['token'].toString();
          randomUser = userDataNotifier.value?.userId.toString()??"";
          print("TOKENNNNN:::::$token");
          print("RANDOM USER:::::$randomUser");

        }
      else
        {
           token = response.data['meeting']['token_random_user'].toString();
           // token = response.data['meeting']['token'].toString();
          randomUser = response.data['meeting']['meeting_random_user'].toString();
          print("TOKENNNNN:::::$token");
          print("RANDOM USER:::::$randomUser");
        }

      url = response.data['meeting']['url'].toString();
      channelId = response.data['meeting']['channel'].toString();
      checkEndMeeting();

      timer = Timer.periodic(
        const Duration(seconds: 10),
        (timer) {
          checkEndMeeting();
        },
      );

      notifyListeners();
      // print("datadtdt::${response.data}");
      // if (response.data["pin_code"].toString() == passCode) {
      //   print('"Passcode is matched ');
      //   DateTime dateTime = DateTime.now();
      //   String dateTimeStr = "${response.data["date"].toString()} ${response
      //       .data["time"].toString()}";
      //   DateTime meetingStartDate = DateTime.parse(dateTimeStr);
      //   DateTime meetingEndDateTime = meetingStartDate.add(Duration(
      //       hours: int.parse(response.data["duration_hr"].toString()),
      //       minutes: int.parse(response.data["duration_min"].toString())));
      //
      //   print("Meeting Started Date ${meetingStartDate}");
      //   print("Meeting End Date ${meetingEndDateTime}");
      //   print("Meeting Current Date ${dateTime}");
      //
      //
      //   if(meetingEndDateTime.isAfter(dateTime))
      //     {
      //       print("Meeting is not ended yet${response.data["id"].toString()}");
      //       int differenceInMinutes = meetingStartDate.difference(dateTime).inMinutes;
      //       bool isWithin5MinutesBefore = differenceInMinutes >= 0 && differenceInMinutes <= 5;
      //
      //       if(meetingStartDate.isBefore(dateTime)||isWithin5MinutesBefore)
      //         {
      //           // ignore: use_build_context_synchronously
      //           push(context: context, screen: MeetingVideoCallScreen(channelId:response.data["id"].toString() ,meetingTitle:response.data["title"].toString() ,));
      //           print("Difff is ${differenceInMinutes}");
      //           print("Difff is ${isWithin5MinutesBefore}");
      //           print(" Meeting started  ");
      //         }
      //       else
      //         {
      //           showSnackbar("Meeting will start ${timeAfter(meetingStartDate)} ");
      //         }
      //     }
      //   else
      //     {
      //       showSnackbar("This meeting already ended");
      //     }
      //
      // }
      // else {
      //   showSnackbar("En valid pass code!");
      // }
    }
  }

  Future<void> checkEndMeeting() async {
    var response = await NewestWebServices.getResponse(
      request: {
        ApiKeys.bookingId: bookingId,
        ApiKeys.url: url,
        ApiKeys.randomUser: randomUser,
      },
      apiUrl: ApiUrls.checkEndVideoCall,
    );

    if (response.status == 1) {
      if (response.data['endcall_timeup'] != null) {
        if (response.data['endcall_timeup'].toString() == "1") {
          ///TIME IS OVER
          Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
          if (callMessage.isNotEmpty &&
              callMessage != response.data['call_message']) {
            showSnackbar("${response.data['call_message']}");
          }
          callMessage = response.data['call_message'] ?? "";
        } else {
          if (response.data['call_status'] != null) {
            if (response.data['call_status'].toString() == "1") {
              ///STUDENT LEFT MEETING
              if (callMessage.isNotEmpty &&
                  callMessage != response.data['call_message']) {
                showSnackbar("${response.data['call_message']}");
              }
              callMessage = response.data['call_message'] ?? "";
            }
            else if (response.data['call_status'].toString() == "2") {
              ///END  BY GUIDE  END MEETING
              isEndedByGuide=true;
              print("datadtadta:::::::$callMessage");
              print("datadtadta:::::::${response.data['call_message']}");
              if (callMessage.isNotEmpty &&
                  callMessage != response.data['call_message']) {
                showSnackbar("${response.data['call_message']}");
              }
              callMessage = response.data['call_message'] ?? "";

              Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);

            }
          }
        }
      }
      if(callMessage.isEmpty)
        {
          callMessage="Message";
        }

      if (response.data['recording_status'] != null) {
        if (recordingOn.isNotEmpty) {
          if (recordingOn != response.data['recording_status'].toString()) {
            if (response.data['recording_message'] != null &&
                response.data['recording_message'].toString().isNotEmpty) {
              showSnackbar(response.data['recording_message']);
            }
          }
        }
        recordingOn = response.data['recording_status'].toString();
      }

      myCustomPrintStatement("dadtadtadtadt:::::::::${response.data}");
    }

    notifyListeners();
  }

  Future<void> endMeeting() async {
    var response = await NewestWebServices.getResponse(
      request: {
        ApiKeys.bookingId: bookingId,
        ApiKeys.url: url,
        ApiKeys.randomUser: randomUser,
        ApiKeys.endBy: userDataNotifier.value?.userId,
      },
      apiUrl: ApiUrls.endVideoCall,
    );

    if (response.status == 1) {
      if (response.data['endcall_timeup'] != null) {
        if (response.data['endcall_timeup'].toString() == "1") {
          Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);

          ///TIME OVER END MEETING
        } else {
          if (response.data['call_status'] != null) {
            if (response.data['call_status'].toString() == "1") {
              ///END  BY STUDENT  NOT END MEETING
            } else if (response.data['call_status'].toString() == "2") {
              Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);

              ///END  BY GUIDE  END MEETING
            }
          }
        }
      }
      myCustomPrintStatement("dadtadtadtadt:::::::::${response.data}");
    }
  }

  Future<void> updateRecordingStatus() async {
    var response = await NewestWebServices.getResponse(
      request: {
        ApiKeys.bookingId: bookingId,
        ApiKeys.url: url,
      },
      apiUrl: ApiUrls.updateRecording,
    );

    EasyLoading.dismiss();
    if (response.status == 1) {

    }
  }

  void turnOnOffCamera() {
    engine.muteLocalVideoStream(cameraIsOn);
    cameraIsOn = !cameraIsOn;
    notifyListeners();
  }

  void turnOnOffMic() {
    engine.muteLocalAudioStream(micIsOn);
    micIsOn = !micIsOn;
    notifyListeners();
  }

  void switchCameraFrontAndBack() {
    engine.switchCamera().then((value) {
      frontCameraIsOn = !frontCameraIsOn;
      notifyListeners();
    }, onError: (error) {
      print('Error switching camera: $error');
    });
  }

  Future<void> startRecording() async {
    if (recordingOn == "0" || recordingOn == "3") {
      bool? v = await showCommonAlertDailog(
        MyGlobalKeys.navigatorKey.currentContext!,
        headingText: "Start Recording",
        message: "Are you sure you want to start recording ?",
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: "No",
                color: MyColors.greyColor,
                textColor: MyColors.blackColor,
                width: 100,
                height: 40,
                onTap: () {
                  Navigator.pop(
                      MyGlobalKeys.navigatorKey.currentContext!, false);
                },
              ),
              hSizedBox2,
              CustomButton(
                text: "Yes",
                width: 100,
                height: 40,
                onTap: () {
                  Navigator.pop(
                      MyGlobalKeys.navigatorKey.currentContext!, true);
                },
              ),
              hSizedBox,
            ],
          ),
        ],
      );

      if (v == true) {
        timer?.cancel();
        await     updateRecordingStatus();

       await  checkEndMeeting();

        timer = Timer.periodic(
          const Duration(seconds: 10),
              (timer) {
            checkEndMeeting();
          },
        );

      }
    } else if (recordingOn == "2") {
      {
        bool? v = await showCommonAlertDailog(
          MyGlobalKeys.navigatorKey.currentContext!,
          headingText: "End Recording",
          message: "Are you sure you want to end recording ?",
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "No",
                  color: MyColors.greyColor,
                  textColor: MyColors.blackColor,
                  width: 100,
                  height: 40,
                  onTap: () {
                    Navigator.pop(
                        MyGlobalKeys.navigatorKey.currentContext!, false);
                  },
                ),
                hSizedBox2,
                CustomButton(
                  text: "Yes",
                  width: 100,
                  height: 40,
                  onTap: () {
                    Navigator.pop(
                        MyGlobalKeys.navigatorKey.currentContext!, true);
                  },
                ),
                hSizedBox,
              ],
            ),
          ],
        );

        if (v == true) {
         timer?.cancel();
         await     updateRecordingStatus();

          await  checkEndMeeting();

          timer = Timer.periodic(
            const Duration(seconds: 10),
                (timer) {
              checkEndMeeting();
            },
          );
        }
      }
    }

    notifyListeners();
  }

  Future<void> disposeCall() async {
    WakelockPlus.disable();

    if(isEndedByGuide==false)
      {
        await endMeeting();
      }
    isEndedByGuide=false;
    callMessage = "";
    timer?.cancel();
    timer = null;
    bookingId = "";
    url = "";
    randomUser = "";
    token = "";
    micIsOn = true;
    cameraIsOn = true;
    frontCameraIsOn = true;
    recordingOn = '0';
    remoteUserUid.clear();
    await engine.leaveChannel();
    await engine.release();
  }

  getUserDetailsAndAddUser(int remoteUserId) async {
    var userDetailresponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.getUserDetailsWithId,
      showSuccessMessage: false,
      showErrorMessage: false,
      request: {"id": remoteUserId},
    );
    if (userDetailresponse.status == 1) {
      var index =
          remoteUserUid.indexWhere((element) => element.id == remoteUserId);
      if (index != -1) {
        remoteUserUid[index].name = userDetailresponse.data['name'];
        remoteUserUid[index].profileImage = userDetailresponse.data['image'];
        notifyListeners();
      }
    }
  }
}
