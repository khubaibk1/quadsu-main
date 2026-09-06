import 'package:flutter/cupertino.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/widget/app_specific/custom_shadow_container.dart';
import 'package:quadsu_app/widget/custom_appbar.dart';
import 'package:quadsu_app/widget/custom_scaffold.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../constants/static_json.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Categories',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 15),
            child: CustomTextField(

              controller: searchController,
              contentPaddingVertical: 0,
              contentPaddingHorizonatly: 14,
              borderRadius: 10,
              hintColor: MyColors.blackColor.withOpacity(0.4),
              hintTextFontSize: 14,
              fontSize: 14,
              height:46,
              borderColor: MyColors.transparent,
              showShadow: true,
              hintText: 'Browse by school or subject',
              fillColor: MyColors.whiteColor,
              prefix:Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(MyImagesUrl.search_outline,
                   color: const Color(0xFF979797),
                    width: 18,height: 18,),
              ),
            ),
          ),
          vSizedBox,
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1/1,
                crossAxisSpacing: 10,
                mainAxisSpacing:10,
              ),
                itemCount: topCategory.length,
                itemBuilder: (context, index) {
                  return CustomShadowContainer(
                    verticalPadding: 4,
                    horizontalPadding:4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImage(
                          imageUrl: topCategory[index]['image'],
                          height: 42,
                          width: 42,
                          fileType: CustomFileType.asset,
                        ),
                        vSizedBox05,
                        CustomText.smallText(
                          topCategory[index]['title'],
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                        ),
                        vSizedBox02,
                        CustomText.smallText(
                          '2 items',
                          fontSize: 11,
                          color: MyColors.blackColor40,
                        ),
                      ],
                    ),
                  );
                },),
          )
        ],
      ),
    );
  }
}
