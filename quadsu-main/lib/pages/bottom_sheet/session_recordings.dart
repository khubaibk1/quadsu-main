import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/pages/commons/video_player.dart';
import 'package:quadsu_app/provider/recording_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_button.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';

class SessionRecordings extends StatefulWidget {
  final int bookingId;

  const SessionRecordings({super.key, required this.bookingId});

  @override
  State<SessionRecordings> createState() => _SessionRecordingsState();
}

class _SessionRecordingsState extends State<SessionRecordings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        RecordingProvider recordingProvider =
            Provider.of<RecordingProvider>(context, listen: false);
        recordingProvider.reset();
        recordingProvider.recordingOffset = 1;
        recordingProvider.getSessionsRecordings(bookingId: widget.bookingId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Session Recordings',
        isBackIcon: true,
      ),
      body: Consumer<RecordingProvider>(
          builder: (context, recordingProvider, child) {
        if (recordingProvider.recordingModel != null) {
          if (recordingProvider.recording.isNotEmpty) {
            return CustomPaginatedListView(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: globalHorizontalPadding),
              onRefresh: () async {
                recordingProvider.recordingOffset = 1;
                recordingProvider.isLastData = false;
                recordingProvider.recordingRefresh = true;
                await recordingProvider.getSessionsRecordings(
                    bookingId: widget.bookingId);
                recordingProvider.recordingRefresh = false;
              },
              onLoadMore: () async {
                recordingProvider.recordingOffset =
                    recordingProvider.recordingOffset + 1;
                await recordingProvider.getSessionsRecordings(
                    bookingId: widget.bookingId);
              },
              itemCount: recordingProvider.recording.length,
              itemBuilder: (context, index) {
                final recording = recordingProvider.recording[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.emergency_recording,
                            size: 24,
                            color: MyColors.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.bodyText2(
                                'Recording ${recording.sNo}',
                                increamentFontSize: 1,
                                color: MyColors.primaryColor,
                              ),
                              vSizedBox05,
                              CustomText.bodyText2(
                                'Duration ${recording.duration}',
                                //increamentFontSize: 1,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: " View ",
                          onTap: () async {

                            String url=await recordingProvider.getRecordingUrl(request: {
                              ApiKeys.filename:recording.fileName,
                            });
                            if(url.isNotEmpty)
                              {
                                CustomNavigation.push(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  screen: CustomVideoPlayer(
                                    url: url,
                                    title: 'Recording ${recording.sNo}',
                                  ),
                                );
                              }
                            else
                              {
                                showSnackbar("Something went wrong");
                              }

                          },
                          isFlexible: true,
                          fontWeight: FontWeight.w600,
                          borderRadius: 4,
                          fontSize: 10,
                          verticalMargin: 0,
                          isBorder: true,
                          verticalPadding: 2,
                          color: MyColors.primaryColor,
                          horizontalPadding: 6,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 30,
                      color: Color(0xFFF8F8F8),
                    )
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomText.bodyText1(
                      'No Recordings Found',
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
