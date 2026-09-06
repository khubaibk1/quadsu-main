import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/my_image_url.dart';

class CustomRating extends StatelessWidget {
 final Color? fillColor;
 final Color? disableColor;
 final double? rating;
 final double? itemSize;
 final bool ignoreGestures;
 final ValueChanged<double>? onRatingUpdate;

   const CustomRating({super.key,this.fillColor, this.disableColor, this.rating,this.itemSize,
     this.ignoreGestures=true,  this.onRatingUpdate
   });

  @override
  Widget build(BuildContext context) {
    return   RatingBar(
      initialRating:rating??3,
      minRating: 1,
      ignoreGestures: ignoreGestures,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: itemSize??12,
      ratingWidget: RatingWidget(
        full: Image.asset(
          MyImagesUrl.star_fill,
          color:fillColor?? const Color(0xFFFBBC04),
        ),
        half: Image.asset(MyImagesUrl.star_fill),
        empty: Image.asset(
          MyImagesUrl.star_fill,
          color:disableColor?? const Color(0xFFC1C1C1),
        ),
      ),
      onRatingUpdate: onRatingUpdate??(rating) {},
    );
  }
}
