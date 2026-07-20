import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/modal/session_model.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_rating.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class RatingSheet extends StatelessWidget {
  RatingSheet({
    super.key,
    required this.session,
  });

  final TextEditingController reviewController = TextEditingController();
  final Session session;
  final ValueNotifier<double> rating =ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [

            CustomImage(
              imageUrl: session.guideData?.profileImage ?? '',
              staticBlurImage: MyImagesUrl.profileImage,
              height: 65,
              width: 65,
              isShowStackImage: true,
              fileType: CustomFileType.network,
            ),
            hSizedBox2,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.headingSmall(
                        '${session.guide?.firstName} ${session.guide?.lastName}',
                        fontWeight: FontWeight.w600,
                      ),
                      vSizedBox02,
                      if (session.guideData?.speciality.isNotEmpty ==
                          true)
                      CustomText.smallText(
                        session.guideData?.speciality??"",
                        fontSize: 10,
                        color: MyColors.blackColor40,
                      ),
                    ],
                  ),
                  CustomButton(
                    text: SessionStatus.getName(SessionStatus.completed),
                    onTap: () {
                    },
                    isFlexible: true,
                    fontWeight: FontWeight.w600,
                    borderRadius: 4,
                    fontSize: 7,
                    verticalMargin: 0,
                    isBorder: true,
                    verticalPadding: 3,
                    borderColor:
                        SessionStatus.getColor(SessionStatus.completed),
                    textColor: SessionStatus.getColor(SessionStatus.completed),
                    color: SessionStatus.getColor(SessionStatus.accepted)
                        .withOpacity(0.05),
                    horizontalPadding: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
        vSizedBox2,
        CustomText.smallText(
          'Give Rating',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        vSizedBox,
       ValueListenableBuilder(
         valueListenable: rating,
          builder: (context, ratingValue, child){
            return  CustomRating(
              rating: ratingValue,
              ignoreGestures: false,
              itemSize: 33,
              onRatingUpdate: (value) {
                rating.value=value;
              },
            );
          }
        ),
        vSizedBox2,
        CustomTextField(
          headingText: 'Write your Review',
          fontSize: 12,
          headingFontSize: 12,
          headingFontWeight: FontWeight.w600,
          hintText: 'Write here',
          hintTextFontSize: 12,
          contentPaddingVertical: 10,
          borderRadius: 10,
          contentPaddingHorizonatly: 15,
          maxLines: 8,
          controller: reviewController,
        ),
        vSizedBox4,
        CustomButton(
          height: 45,
          onTap: () {
            if(reviewController.text.trim().isEmpty)
              {
                showSnackbar("Please write something");
                return;
              }

            SessionsProvider sessionProvider = Provider.of<SessionsProvider>(context, listen: false);
            sessionProvider.rateSession(request: {
              ApiKeys.bookingId:session.bookingId,
              ApiKeys.rating:rating.value,
              ApiKeys.comment:reviewController.text.trim(),
            });

          },
          text: 'Rate',
          verticalMargin: 0,
          borderRadius: 4,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
