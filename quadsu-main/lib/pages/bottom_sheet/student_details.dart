import 'package:flutter/cupertino.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../widget/app_specific/expanded_row_widget.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_rating.dart';
import '../../widget/custom_text.dart';

class StudentDetailsSheet extends StatelessWidget {

  const StudentDetailsSheet({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  const CustomImage(
                    imageUrl: MyImagesUrl.image01,
                    height: 65,
                    width: 65,
                    isShowStackImage: true,
                    fileType: CustomFileType.asset,
                  ),
                  hSizedBox2,
                  Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.headingSmall(
                              'Katharine miao',
                              fontWeight: FontWeight.w600,
                            ),
                            vSizedBox02,
                            CustomText.smallText(
                              'Chemistry',
                              color: MyColors.blackColor40,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              vSizedBox2,
              ExpandedRowWidget(title: 'Booking ID:', subTitle: '#15410'),
              ExpandedRowWidget(title: 'Booking date', subTitle: '09-07-2024 02:29pm'),
              ExpandedRowWidget(title: 'Booked Date', subTitle: '23-07-2024'),
              ExpandedRowWidget(title: 'Start and end time', subTitle: '05:30pm to 06:30pm'),
              ExpandedRowWidget(title: 'Comments', subTitle: 'I am a student'),
              ExpandedRowWidget(title: 'Grand Total', subTitle: '\$25.2',fontWeight: FontWeight.w600),
              vSizedBox2,
              CustomText.smallText(
                'Student Review',
                increamentFontSize: 1,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        vSizedBox05,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          color:MyColors.containerBgColor,
          child: Column(
            children: [
              Row(
                children: [
                  const CustomImage(
                    imageUrl: MyImagesUrl.image01,
                    height: 30,
                    width: 30,
                    isShowStackImage: true,
                    fileType: CustomFileType.asset,
                  ),
                  hSizedBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.smallText(
                                  'Kasey B',
                                  fontWeight: FontWeight.w600,
                                ),
                                vSizedBox02,
                                const CustomRating(
                                  rating: 4,
                                  itemSize: 11,
                                )
                              ],
                            ),

                            CustomText.smallText(
                              '01-07-2024, 01:30pm',
                              color: MyColors.blackColor50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              vSizedBox05,
              CustomText.smallText(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                color: MyColors.blackColor50,
              ),
            ],
          ),
        )
      ],
    );
  }
}
