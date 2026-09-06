import 'package:quadsu_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import '../../constants/my_colors.dart';
import '../../modal/chat_modal.dart';

class ConversationMessageCard extends StatelessWidget {
  final ChatModal chatMessage;
  final Alignment messageAlignment;
  final Color messagesBgColor;
  final TextStyle messagesTextStyle;
  const ConversationMessageCard({
    super.key,
    required this.messageAlignment,
    // required this.messages,
    required this.chatMessage,
    required this.messagesBgColor,
    required this.messagesTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Align(
            alignment: messageAlignment,
            child: Container(
              // height: 100,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 245,
              decoration: BoxDecoration(
                color: messagesBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  bottomRight: Radius.circular(
                      MyColors.whiteColor == messagesBgColor ? 15 : 0),
                  bottomLeft: Radius.circular(
                      MyColors.whiteColor != messagesBgColor ? 15 : 0),
                  topRight: const Radius.circular(15),
                ),
              ),
              child: Text(
                chatMessage.message,
                style: messagesTextStyle,
              ),
            ),
          ),
          Align(
            alignment: messagesBgColor == MyColors.whiteColor
                ? Alignment.topLeft
                : Alignment.topRight,
            child: SizedBox(
              // height: 100,
              // width: messagesBgColor == MyColors.primaryColor ? 150 : 50,
              child: CustomText.bodyText2(
                chatMessage.createdAt,
                fontSize: 8,
                fontWeight: FontWeight.w600,
                // style: ThemeStyle.fontSize10LightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
