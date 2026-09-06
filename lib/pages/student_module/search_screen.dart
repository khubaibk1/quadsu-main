import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/modal/search_guide_model.dart';
import 'package:quadsu_app/pages/bottom_sheet/filter_sheet.dart';
import 'package:quadsu_app/pages/student_module/guide_profile_screen.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_gesture_detector.dart';
import 'package:quadsu_app/widget/custom_paginated_list_view.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import '../../functions/showCustomBottomSheet.dart';
import '../../provider/search_guide_provider.dart';
import '../../widget/app_specific/custom_drawer.dart';
import '../../widget/custom_button.dart';
// import '../../widget/custom_image.dart'; // Commented out to prevent accidental usage

class SearchScreen extends StatefulWidget {
  final String? searchValue;

  const SearchScreen({super.key, this.searchValue});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? searchTimer;
  ValueNotifier shortByNotifier = ValueNotifier({"key": "Top Guides"});
  ValueNotifier<bool> showCancel = ValueNotifier(false);

  // --- New Design Colors ---
  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kAccentOrange = Color(0xFFF79E1B);
  static const Color kHeaderBg = Color(0xFFF0F1F9);
  static const Color kTextBlack = Color(0xFF1C1C1E);

  List shortBy = [
    {"key": "Top Guides"},
    {"key": "Best Match"},
    {"key": "Lower Price"},
    {"key": "Higher Price"},
    {"key": "Ratings"},
    {"key": "Experience"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        SearchGuideProvider searchGuideProvider =
            Provider.of<SearchGuideProvider>(context, listen: false);
        searchController.text = searchGuideProvider.searchKeyWord;
        if (searchController.text.isNotEmpty) {
          showCancel.value = true;
        } else {
          showCancel.value = false;
        }
        searchGuideProvider.offset = 1;
        searchGuideProvider.getGuideSearchResult();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      bottomNavigationBar: CustomButton(
        onTap: () async {
          SearchGuideProvider searchGuideProvider =
              Provider.of<SearchGuideProvider>(context, listen: false);
          await showCustomBottomSheet(
              context: context, child: const FilterSheet());
          searchGuideProvider.offset = 1;
          searchGuideProvider.getGuideSearchResult();
        },
        text: 'Filter',
        verticalMargin: 0,
        borderRadius: 0,
        fontSize: 18,
        textColor: Colors.white,
        color: kAccentOrange,
      ),
      body: Consumer<SearchGuideProvider>(
        builder: (context, searchGuideProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Container(
                color: kHeaderBg,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 45,
                          errorBuilder: (ctx, _, __) => const Icon(Icons.shield,
                              color: kAccentOrange, size: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Find your perfect college guide',
                      style: TextStyle(
                        color: kPrimaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryBlue.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[400]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: showCancel,
                                builder: (context, showCancelValue, child) {
                                  return TextField(
                                    controller: searchController,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Search by school or major...',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 15),
                                      border: InputBorder.none,
                                      suffixIcon: showCancelValue
                                          ? GestureDetector(
                                              onTap: () async {
                                                searchController.text = "";
                                                showCancel.value = false;
                                                searchGuideProvider
                                                    .searchKeyWord = "";
                                                searchGuideProvider.offset = 1;
                                                await searchGuideProvider
                                                    .getGuideSearchResult();
                                              },
                                              child: const Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.grey,
                                                  size: 20),
                                            )
                                          : null,
                                    ),
                                    onChanged: (value) async {
                                      if (value.isNotEmpty) {
                                        showCancel.value = true;
                                      } else {
                                        showCancel.value = false;
                                      }

                                      if (value.isNotEmpty) {
                                        const duration =
                                            Duration(milliseconds: 500);
                                        if (searchTimer != null) {
                                          searchTimer?.cancel();
                                        }
                                        searchTimer = Timer(duration, () async {
                                          searchGuideProvider.searchKeyWord =
                                              value;
                                          searchGuideProvider.offset = 1;
                                          await searchGuideProvider
                                              .getGuideSearchResult();
                                        });
                                      } else {
                                        if (searchTimer != null) {
                                          searchTimer?.cancel();
                                        }
                                        searchGuideProvider.searchKeyWord = "";
                                        searchGuideProvider.offset = 1;
                                        await searchGuideProvider
                                            .getGuideSearchResult();
                                      }
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- SORT LOGIC ---
              if (searchGuideProvider.searchGuide != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText.bodyText1(
                          '${searchGuideProvider.searchGuideList.length} Guide(s) found',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: shortByNotifier,
                        builder: (context, universityValue, child) =>
                            DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            icon: const Icon(Icons.sort, color: kPrimaryBlue),
                            value: universityValue['key'],
                            items: shortBy.map((e) {
                              return DropdownMenuItem(
                                value: e['key'],
                                child: CustomText.smallText(e['key'],
                                    color: kPrimaryBlue,
                                    fontWeight: FontWeight.w600),
                              );
                            }).toList(),
                            onChanged: (val) {
                              var selected = shortBy.firstWhere(
                                  (element) => element['key'] == val);
                              searchGuideProvider.shortBy = selected['key'];
                              shortByNotifier.value = selected;
                              searchGuideProvider.offset = 1;
                              searchGuideProvider.getGuideSearchResult();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // --- LIST BODY ---
              if (searchGuideProvider.searchGuide != null &&
                  searchGuideProvider.searchGuideList.isNotEmpty)
                Expanded(
                  child: CustomPaginatedListView(
                    onRefresh: () async {
                      searchGuideProvider.isRefresh = true;
                      searchGuideProvider.offset = 1;
                      searchGuideProvider.isLastGuide = false;
                      await searchGuideProvider.getGuideSearchResult();
                      searchGuideProvider.isRefresh = false;
                    },
                    onLoadMore: () async {
                      searchGuideProvider.offset =
                          searchGuideProvider.offset + 1;
                      await searchGuideProvider.getGuideSearchResult();
                    },
                    wantLoadMore: true,
                    isLastPage: searchGuideProvider.isLastGuide,
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 10, left: 24, right: 24),
                    itemBuilder: (context, index) {
                      SearchGuideList searchGuide =
                          searchGuideProvider.searchGuideList[index];

                      return Column(
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: CustomPaint(
                                painter: DashedBorderPainter(
                                  color: kAccentOrange,
                                  strokeWidth: 1.5,
                                  gap: 5.0,
                                  radius: 16.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: kAccentOrange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Can't find your guide?",
                                              style: TextStyle(
                                                color: kPrimaryBlue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Send us your request — we'll take care of the rest!",
                                              style: TextStyle(
                                                color:
                                                    kTextBlack.withOpacity(0.8),
                                                fontSize: 13,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // --- CARD DESIGN ---
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: index ==
                                            searchGuideProvider
                                                    .searchGuideList.length -
                                                1 &&
                                        searchGuideProvider.isLastGuide == false
                                    ? 60
                                    : 16),
                            child: CustomGestureDetector(
                              onTap: () {
                                CustomNavigation.push(
                                    context: context,
                                    screen: GuideProfileScreen(
                                      guideId: searchGuide.id,
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // *** FIXED IMAGE: USING STANDARD FLUTTER IMAGE ***
                                    ClipRRect(
                                      // 1. Force the Rounded Corners here
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: 80, // Square Height
                                        width: 80, // Square Width
                                        color: Colors
                                            .grey[200], // Background if loading
                                        child: Image.network(
                                          searchGuide.profileImage ?? "",
                                          fit: BoxFit
                                              .cover, // 2. Forces image to fill the square
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // 3. Show icon if URL is broken/empty
                                            return const Icon(Icons.person,
                                                color: Colors.grey, size: 40);
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Info Column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${searchGuide.firstName} ${searchGuide.lastName}',
                                            style: const TextStyle(
                                              color: kPrimaryBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            searchGuide.universityName,
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13),
                                          ),
                                          const SizedBox(height: 2),
                                          if (searchGuide.speciality.isNotEmpty)
                                            Text(
                                              searchGuide.speciality,
                                              style: const TextStyle(
                                                color: kAccentOrange,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          if (searchGuide
                                              .workingHoursCalculated
                                              .isNotEmpty)
                                            _buildTag(
                                                "${searchGuide.workingHoursCalculated.split(":").first}h ${searchGuide.workingHoursCalculated.split(":").last}m"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (searchGuideProvider.isLastGuide &&
                              index ==
                                  searchGuideProvider.searchGuideList.length -
                                      1)
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: CustomText.heading(
                                  'End',
                                  color: kPrimaryBlue,
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                ),
                              ),
                            )
                        ],
                      );
                    },
                    itemCount: searchGuideProvider.searchGuideList.length,
                  ),
                )
              else if (searchGuideProvider.searchGuide != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CustomText.bodyText1(
                            'No Guide found',
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final Path dashedPath = Path();
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
