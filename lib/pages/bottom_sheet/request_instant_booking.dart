import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/sized_box.dart';

import '../../provider/instant_booking_provider.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';

class RequestInstantBooking extends StatelessWidget {
  final String dateTime;
  final String guideId;

  const RequestInstantBooking({super.key, required this.dateTime, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSizedBox,
        CustomText.headingSmall(
          'Request for Instant Booking',
          fontWeight: FontWeight.w600,
        ),
        vSizedBox,
        CustomText.bodyText2(
          'Request By : ${userDataNotifier.value?.firstName ?? ""} ${userDataNotifier.value?.lastName ?? ""}\nYou are making a booking request for $dateTime, Please confirm.?',
        ),
        vSizedBox4,
        CustomButton(
          height: 45,
          text: 'Request',
          onTap: () {
            InstantBookingProvider instantBookingProvider =
                Provider.of<InstantBookingProvider>(context, listen: false);
            instantBookingProvider.requestInstantBooking(request: {
              ApiKeys.guide_id:guideId,
              ApiKeys.instantBookingDis:"Requesting for $dateTime",

            });
          },
          borderRadius: 4,
          verticalMargin: 0,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
