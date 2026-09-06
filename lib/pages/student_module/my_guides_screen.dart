import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import '../../constants/global_data.dart';
import '../../provider/student_guide_provider.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_image.dart';
import '../guide_module/student_profile.dart';
import 'guide_profile_screen.dart';

class MyStudentGuidesScreen extends StatefulWidget {
  const MyStudentGuidesScreen({super.key});

  @override
  State<MyStudentGuidesScreen> createState() => _MyStudentGuidesScreenState();
}

class _MyStudentGuidesScreenState extends State<MyStudentGuidesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        StudentGuideProvider instantBookingProvider =
            Provider.of<StudentGuideProvider>(context, listen: false);
        instantBookingProvider.studentGuideSessionsOffset = 1;
        instantBookingProvider.getStudentGuide();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const kPrimaryBlue = Color(0xFF2D3388);
    const kAccentOrange = Color(0xFFF79E1B);
    const kBackgroundWhite = Colors.white;

    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: SafeArea(
        bottom: false,
        child: Consumer<StudentGuideProvider>(
          builder: (context, studentGuideProvider, child) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  color: kBackgroundWhite,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            usertype == UserType.guide ? 'My Students' : 'Favorites',
                            style: const TextStyle(
                              color: Color(0xFF1C1C1E),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5EA)),
                    ],
                  ),
                ),
                if (studentGuideProvider.studentGuides.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        studentGuideProvider.studentGuideSessionsOffset = 1;
                        studentGuideProvider.isLastData = false;
                        await studentGuideProvider.getStudentGuide();
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: studentGuideProvider.studentGuides.length,
                        itemBuilder: (context, index) {
                          final studentGuide = studentGuideProvider.studentGuides[index];
                          return GestureDetector(
                            onTap: () {
                              if (usertype == UserType.student) {
                                CustomNavigation.push(
                                  context: context,
                                  screen: GuideProfileScreen(guideId: studentGuide.userId),
                                );
                              } else {
                                CustomNavigation.push(
                                  context: context,
                                  screen: StudentProfileScreen(studentId: studentGuide.userId ?? 0),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CustomImage(
                                      imageUrl: usertype == UserType.student
                                          ? studentGuide.guidePrefrence?.profileImage ?? ""
                                          : studentGuide.studentPrefrence?.profileImage ?? '',
                                      fit: BoxFit.cover,
                                      showLoader: false,
                                      isBackgroundImage: false,
                                      isShowStackImage: false,
                                      fileType: CustomFileType.network,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.0),
                                            kPrimaryBlue.withOpacity(0.8),
                                          ],
                                          stops: const [0.5, 0.7, 1.0],
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Icon(Icons.favorite_border, color: Colors.white, size: 24),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${studentGuide.firstName ?? ""} ${studentGuide.lastName ?? ""}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          if (usertype == UserType.student)
                                            Text(
                                              studentGuide.guidePrefrence?.university ?? "",
                                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 2),
                                          if (usertype == UserType.student)
                                            Text(
                                              studentGuide.guidePrefrence?.speciality ?? "",
                                              style: const TextStyle(
                                                color: kAccentOrange,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
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
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: kPrimaryBlue,
                          size: 64,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          usertype == UserType.guide ? 'No Students yet' : 'No Favorites yet',
                          style: const TextStyle(
                            color: Color(0xFF1C1C1E),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            usertype == UserType.guide
                                ? 'Students you connect with will appear here'
                                : 'Start exploring guides and save your favorites here',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
