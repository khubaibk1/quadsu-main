import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/provider/search_guide_provider.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/widget/custom_gesture_detector.dart';
import '../student_module/guide_profile_screen.dart';
import '../student_module/search_screen.dart';

class GuideHomeScreen extends StatefulWidget {
  const GuideHomeScreen({super.key});

  @override
  State<GuideHomeScreen> createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? timer;

  final Color kBackgroundColor = const Color(0xFFF5F6FA);
  final Color kPrimaryBlue = const Color(0xFF2D3388);
  final Color kAccentOrange = const Color(0xFFF79E1B);
  final Color kWhite = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        timer?.cancel();
        DashBoardProvider dashBoardProvider =
            Provider.of<DashBoardProvider>(context, listen: false);
        await dashBoardProvider.getStudentDashBoard();

        SearchGuideProvider searchGuideProvider =
            Provider.of<SearchGuideProvider>(context, listen: false);
        searchGuideProvider.resetAllValues();
        await searchGuideProvider.getGuideSearchResult();
        
        if (dashBoardProvider.category.isEmpty) {
          await _fetchCategories(dashBoardProvider);
        }

        timer = Timer.periodic(
          const Duration(seconds: 10),
          (timer) async {
            if (userDataNotifier.value == null) {
              timer.cancel();
            } else {
              await dashBoardProvider.getStudentDashBoard(showLoader: false);
            }
          },
        );
      },
    );
  }

  Future<void> _fetchCategories(DashBoardProvider dashBoardProvider) async {
    var response = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.homeData,
      request: {},
      apiMethod: ApiMethod.get,
    );
    if (response.status == 1) {
      var homeData = StudentDashboard.fromJson(response.data);
      dashBoardProvider.category = homeData.category ?? [];
      dashBoardProvider.notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void _performSearch() {
    SearchGuideProvider searchGuideProvider =
        Provider.of<SearchGuideProvider>(context, listen: false);

    searchGuideProvider.resetAllValues();
    searchGuideProvider.searchKeyWord = searchController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchScreen(searchValue: searchController.text.trim()),
      ),
    );
  }

  String _getUniversityNames(String universityIds, List globalUniversity) {
    if (universityIds.isEmpty) return "";
    
    List<String> ids = universityIds.split(',');
    List<String> names = [];
    
    for (String id in ids) {
      String trimmedId = id.trim();
      for (var uni in globalUniversity) {
        if (uni['id'].toString() == trimmedId) {
          names.add(uni['university_name']);
          break;
        }
      }
    }
    
    return names.isEmpty ? universityIds : names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Consumer2<DashBoardProvider, SearchGuideProvider>(
          builder: (context, dashBoardProvider, searchGuideProvider, child) {
            if (dashBoardProvider.studentDashboard == null &&
                userDataNotifier.value != null) {
              return const Center(child: CircularProgressIndicator());
            }

            final myAuthProvider = Provider.of<MyAuthProvider>(context, listen: false);

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 45,
                          errorBuilder: (ctx, _, __) => Icon(Icons.shield,
                              color: kAccentOrange, size: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Connect with students and help them decide with confidence',
                      style: TextStyle(
                        color: kPrimaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- SEARCH BAR ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (val) => _performSearch(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/icons/search_outline.png',
                              width: 20,
                              height: 20,
                              color: Colors.grey[400],
                            ),
                          ),
                          hintText: 'Search by school or major...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),

                    if (userDataNotifier.value != null) ...[
                      const SizedBox(height: 30),

                      _buildSectionHeader(
                        title: 'Featured Guides',
                        assetPath: 'assets/icons/star_outline.png',
                        iconColor: kAccentOrange,
                      ),
                      const SizedBox(height: 16),

                      // --- FEATURED GUIDES HORIZONTAL LIST ---
                      if (searchGuideProvider.searchGuideLode)
                        const Center(child: CircularProgressIndicator())
                      else if (searchGuideProvider.searchGuideList.isNotEmpty)
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemCount: searchGuideProvider.searchGuideList.length > 10 
                                ? 10 
                                : searchGuideProvider.searchGuideList.length,
                            itemBuilder: (context, index) {
                              final guide = searchGuideProvider.searchGuideList[index];
                              String imageUrl = guide.profileImage;
                              String universityName = _getUniversityNames(
                                guide.university,
                                myAuthProvider.globalUniversity,
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (guide.id != null) {
                                    CustomNavigation.push(
                                      context: context,
                                      screen: GuideProfileScreen(guideId: guide.id!),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            image: imageUrl.isNotEmpty
                                                ? DecorationImage(
                                                    image: NetworkImage(imageUrl),
                                                    fit: BoxFit.cover,
                                                    onError: (exception, stackTrace) => {},
                                                  )
                                                : null,
                                          ),
                                          child: imageUrl.isEmpty
                                              ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                                              : null,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                kPrimaryBlue.withOpacity(0.9),
                                              ],
                                              stops: const [0.0, 0.6, 1.0],
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Icon(Icons.favorite_border, color: Colors.white, size: 22),
                                        ),
                                        Positioned(
                                          bottom: 12,
                                          left: 12,
                                          right: 12,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${guide.firstName}\n${guide.lastName}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  height: 1.1,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                universityName,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.9),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                guide.speciality.isNotEmpty ? guide.speciality : "Guide",
                                                style: TextStyle(
                                                  color: kAccentOrange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Text("No guides found.", style: TextStyle(color: Colors.grey[500])),
                        ),
                    ],

                    const SizedBox(height: 30),

                    // --- TRENDING MAJORS ---
                    _buildSectionHeader(
                      title: 'Trending Majors',
                      assetPath: 'assets/icons/trending.png',
                      iconColor: kAccentOrange,
                    ),
                    const SizedBox(height: 16),
                    if (dashBoardProvider.category.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: dashBoardProvider.category.map((category) {
                          return GestureDetector(
                            onTap: () {
                              SearchGuideProvider searchGuideProvider =
                                  Provider.of<SearchGuideProvider>(context, listen: false);
                              searchGuideProvider.resetAllValues();
                              searchGuideProvider.searchCategoryId = category.id.toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(searchValue: ""),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEFF3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                category.title ?? "",
                                style: TextStyle(
                                  color: kPrimaryBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Text("No categories found.", style: TextStyle(color: Colors.grey[500])),

                    const SizedBox(height: 30),

                  

                    if (searchGuideProvider.searchGuideList.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchGuideProvider.searchGuideList.length,
                        itemBuilder: (context, index) {
                          final guide = searchGuideProvider.searchGuideList[index];
                          String imageUrl = guide.profileImage;
                          String universityName = _getUniversityNames(
                            guide.university,
                            myAuthProvider.globalUniversity,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CustomGestureDetector(
                              onTap: () {
                                if (guide.id != null) {
                                  CustomNavigation.push(
                                    context: context,
                                    screen: GuideProfileScreen(guideId: guide.id!),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kWhite,
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.grey[200],
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.person, color: Colors.grey, size: 40);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${guide.firstName} ${guide.lastName}',
                                            style: TextStyle(
                                              color: kPrimaryBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            universityName,
                                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                          ),
                                          const SizedBox(height: 2),
                                          if (guide.speciality.isNotEmpty)
                                            Text(
                                              guide.speciality,
                                              style: TextStyle(
                                                color: kAccentOrange,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          if (guide.workingHoursCalculated.isNotEmpty)
                                            _buildTag(
                                                "${guide.workingHoursCalculated.split(":").first}h ${guide.workingHoursCalculated.split(":").last}m"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Text("No guides found.", style: TextStyle(color: Colors.grey[500])),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String assetPath,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          width: 26,
          height: 26,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: kPrimaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
    );

    Path dashPath = Path();
    double dashWidth = 8.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
