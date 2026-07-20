import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/modal/student_dashboard_model.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart';
import '../guide_module/schedule_components/sessionSlots.dart';

class GuideProfileScreen extends StatefulWidget {
  final int guideId;
  const GuideProfileScreen({super.key, required this.guideId});

  @override
  State<GuideProfileScreen> createState() => _GuideProfileScreenState();
}

class _GuideProfileScreenState extends State<GuideProfileScreen> {
  // --- State for Data & Editing ---
  bool _isLoading = true;
  bool _isEditing = false;
  ValueNotifier<Guide?> guide = ValueNotifier(null);

  // Controllers for "In-Place" Editing
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _responseTimeController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();

  // Language Handling
  List<String> _selectedLanguageNames = [];

  // --- Design Colors ---
  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kAccentOrange = Color(0xFFF79E1B);
  static const Color kTextGrey = Color(0xFF8A8A8F);
  static const Color kTextBlack = Color(0xFF1C1C1E);
  static const Color kChipBlue = Color(0xFF6B71B9);
  static const Color kBgGrey = Color(0xFFF0F0F2);

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    // 1. Fetch the Standard Guide Object (For Name, Image, Reviews, Videos etc)
    final dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
    guide.value =
        await dashBoardProvider.getGuideProfile(guideId: widget.guideId);

    // 2. Fetch the Specific Editable Profile Data
    // Only if viewing own profile
    if (userDataNotifier.value?.userId == widget.guideId) {
      await _getTutorProfile();
    } else {
      // Populate from guide data for student viewing
      await _getGuideProfileData();
    }
  }

  // ================= API LOGIC (Isolated) =================

  Future<void> _getGuideProfileData() async {
    try {
      print("Fetching tutor profile for guide ID: ${widget.guideId}");
      var response = await NewestWebServices.getResponse(
        apiUrl: "${ApiUrls.getTutorProfile}?user_id=${widget.guideId}",
        request: {},
        apiMethod: ApiMethod.get,
      );

      print("API Response Status: ${response.status}");
      print("API Response Data: ${response.data}");

      if (response.status == 1) {
        final data = response.data;
        setState(() {
          _graduationYearController.text =
              data['graduation_year']?.toString() ?? "";
          _majorController.text = data['speciality'] ?? "";
          _responseTimeController.text = data['response_time'] ?? "";
          _aboutController.text = data['about'] ?? "";
          _expertiseController.text = data['expertise'] ?? "";
          _interestsController.text = data['interests'] ?? "";

          String langString = data['language'] ?? "";
          if (langString.isNotEmpty) {
            _selectedLanguageNames =
                langString.split(',').map((e) => e.trim()).toList();
          } else {
            _selectedLanguageNames = [];
          }
          _isLoading = false;
        });
        print(
            "Controllers populated - About: ${_aboutController.text}, Expertise: ${_expertiseController.text}");
      } else {
        print("API returned status 0: ${response.message}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching guide profile: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getTutorProfile() async {
    try {
      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.getTutorProfile,
        request: {},
        apiMethod: ApiMethod.get,
      );

      if (response.status == 1) {
        final data = response.data;
        setState(() {
          _graduationYearController.text =
              data['graduation_year']?.toString() ?? "";
          _majorController.text = data['speciality'] ?? "";
          _responseTimeController.text = data['response_time'] ?? "";
          _aboutController.text = data['about'] ?? "";
          _expertiseController.text = data['expertise'] ?? "";
          _interestsController.text = data['interests'] ?? "";

          String langString = data['language'] ?? "";
          if (langString.isNotEmpty) {
            _selectedLanguageNames =
                langString.split(',').map((e) => e.trim()).toList();
          } else {
            _selectedLanguageNames = [];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateTutorProfile() async {
    setState(() => _isLoading = true);
    try {
      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.updateTutorProfile,
        request: {
          "graduation_year": _graduationYearController.text.trim(),
          "speciality": _majorController.text.trim(),
          "response_time": _responseTimeController.text.trim(),
          "about": _aboutController.text.trim(),
          "expertise": _expertiseController.text.trim(),
          "interests": _interestsController.text.trim(),
          "language": _selectedLanguageNames
        },
      );

      if (response.status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")));
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        _initialLoad();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error updating profile: $e");
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  // ================= UI BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBlue))
          : ValueListenableBuilder(
              valueListenable: guide,
              builder: (context, guideValue, child) {
                if (guideValue == null) return const SizedBox();

                return Consumer<MyAuthProvider>(
                  builder: (context, myAuthProvider, child) {
                    bool isOwnProfile =
                        userDataNotifier.value?.userId == widget.guideId;

                    // Fallback for visual data if API hasn't populated yet or not own profile
                    String universityName =
                        guideValue.guidePrefrence?.university ?? "University";

                    return Stack(
                      children: [
                        CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            // --- 1. APP BAR ---
                            SliverAppBar(
                              expandedHeight: 420.0,
                              pinned: true,
                              stretch: true,
                              backgroundColor: kPrimaryBlue,
                              elevation: 0,
                              leading: IconButton(
                                icon: Image.asset('assets/icons/back.png',
                                    color: Colors.black, width: 35),
                                onPressed: () => Navigator.pop(context),
                              ),
                              actions: [
                                if (isOwnProfile)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: _isEditing
                                        ? IconButton(
                                            onPressed: _updateTutorProfile,
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(Icons.check,
                                                  color: kPrimaryBlue),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isEditing = true;
                                              });
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white24,
                                              child: Icon(Icons.edit,
                                                  color: Colors.white),
                                            ),
                                          ),
                                  ),
                              ],
                              flexibleSpace: FlexibleSpaceBar(
                                stretchModes: const [
                                  StretchMode.zoomBackground
                                ],
                                centerTitle: true,
                                titlePadding: const EdgeInsets.only(bottom: 16),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${guideValue.firstName ?? ""} ${guideValue.lastName ?? ""}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        universityName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                background: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CustomImage(
                                      imageUrl: guideValue
                                              .guidePrefrence?.profileImage ??
                                          "",
                                      height: double.infinity,
                                      width: double.infinity,
                                      fileType: CustomFileType.network,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(0, 49, 25, 154),
                                            Color.fromARGB(255, 46, 49, 146)
                                          ],
                                          stops: [0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // --- 2. PROFILE CONTENT ---
                            SliverToBoxAdapter(
                              child: Container(
                                color: kPrimaryBlue,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      24, 30, 24, isOwnProfile ? 24 : 120),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // --- A. TOP STATS ---
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // GRADUATION YEAR (Editable)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                const Icon(
                                                    Icons.school_outlined,
                                                    color: kAccentOrange,
                                                    size: 26),
                                                const SizedBox(height: 6),
                                                const Text("Graduation Year",
                                                    style: TextStyle(
                                                        color: kTextGrey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                const SizedBox(height: 4),
                                                _isEditing
                                                    ? SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              _graduationYearController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: const TextStyle(
                                                              color: kTextBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        _graduationYearController
                                                                .text.isEmpty
                                                            ? (guideValue
                                                                    .guidePrefrence
                                                                    ?.graduationYear ??
                                                                "N/A")
                                                            : _graduationYearController
                                                                .text,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: kTextBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                              ],
                                            ),
                                          ),

                                          // SPECIALITY / MAJOR (Editable)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/icons/book.png',
                                                    width: 26),
                                                const SizedBox(height: 6),
                                                const Text("Major",
                                                    style: TextStyle(
                                                        color: kTextGrey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                const SizedBox(height: 4),
                                                _isEditing
                                                    ? SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              _majorController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: kTextBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        _majorController
                                                                .text.isEmpty
                                                            ? (guideValue
                                                                    .guidePrefrence
                                                                    ?.speciality ??
                                                                "N/A")
                                                            : _majorController
                                                                .text,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: kTextBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                              ],
                                            ),
                                          ),

                                          // RESPONSE TIME (Editable)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/icons/Group.png',
                                                    width: 26),
                                                const SizedBox(height: 6),
                                                const Text("Response",
                                                    style: TextStyle(
                                                        color: kTextGrey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                const SizedBox(height: 4),
                                                _isEditing
                                                    ? SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              _responseTimeController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: kTextBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        _responseTimeController
                                                                .text.isEmpty
                                                            ? "1 hr"
                                                            : _responseTimeController
                                                                .text,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: kTextBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      _buildDivider(),

                                      // --- B. ABOUT SECTION (Editable) ---
                                      _buildSectionTitle('About'),
                                      const SizedBox(height: 12),
                                      if (_isEditing)
                                        TextField(
                                          controller: _aboutController,
                                          maxLines: 5,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Tell us about yourself...",
                                            border: OutlineInputBorder(),
                                          ),
                                        )
                                      else
                                        Text(
                                          _aboutController.text.isNotEmpty
                                              ? _aboutController.text
                                              : (guideValue.guidePrefrence
                                                      ?.profileHeadline ??
                                                  "No description available."),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 121, 121, 121),
                                              fontSize: 13,
                                              height: 1.5),
                                        ),

                                      _buildDivider(),

                                      // --- C. EXPERTISE (Editable) ---
                                      _buildSectionTitle('Areas of Expertise'),
                                      const SizedBox(height: 12),
                                      if (_isEditing) ...[
                                        TextField(
                                          controller: _expertiseController,
                                          maxLines: 2,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Physics, Math, Chemistry (Separate with commas)",
                                            helperText:
                                                "Separate items with commas",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ] else ...[
                                        if (_expertiseController
                                            .text.isNotEmpty)
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: _expertiseController.text
                                                .split(',')
                                                .map((e) => _buildChip(e.trim(),
                                                    isBlue: true))
                                                .toList(),
                                          )
                                        else
                                          const Text("No expertise listed.",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                      ],

                                      _buildDivider(),

                                      // --- D. INTERESTS (Editable) ---
                                      _buildSectionTitle('Interests'),
                                      const SizedBox(height: 12),
                                      if (_isEditing) ...[
                                        TextField(
                                          controller: _interestsController,
                                          maxLines: 2,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Hiking, Reading, Gaming (Separate with commas)",
                                            helperText:
                                                "Separate items with commas",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ] else ...[
                                        if (_interestsController
                                            .text.isNotEmpty)
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: _interestsController.text
                                                .split(',')
                                                .map((e) => _buildChip(e.trim(),
                                                    isBlue: false))
                                                .toList(),
                                          )
                                        else
                                          const Text("No interests listed.",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                      ],

                                      _buildDivider(),

                                      // --- E. LANGUAGES (Editable) ---
                                      _buildSectionTitle('Languages'),
                                      const SizedBox(height: 12),
                                      if (_isEditing) ...[
                                        const Text(
                                            "Select languages you speak:",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          children: myAuthProvider
                                              .globalLanguages
                                              .map((langMap) {
                                            String langName =
                                                langMap['language'];
                                            bool isSelected =
                                                _selectedLanguageNames
                                                    .contains(langName);
                                            return FilterChip(
                                              label: Text(langName),
                                              selected: isSelected,
                                              selectedColor:
                                                  kChipBlue.withOpacity(0.2),
                                              checkmarkColor: kPrimaryBlue,
                                              labelStyle: TextStyle(
                                                  color: isSelected
                                                      ? kPrimaryBlue
                                                      : Colors.black,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                              onSelected: (val) {
                                                setState(() {
                                                  if (val) {
                                                    _selectedLanguageNames
                                                        .add(langName);
                                                  } else {
                                                    _selectedLanguageNames
                                                        .remove(langName);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        )
                                      ] else ...[
                                        if (_selectedLanguageNames.isNotEmpty)
                                          Wrap(
                                            spacing: 8,
                                            children: _selectedLanguageNames
                                                .map((l) => _buildSimpleTag(l))
                                                .toList(),
                                          )
                                        else
                                          const Text("No languages selected.",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                      ],

                                      _buildDivider(),

                                      // --- F. EDUCATION (Read Only - only show to others) ---
                                      if (!isOwnProfile &&
                                          guideValue.guidePrefrence
                                                  ?.ugCollegeName !=
                                              null) ...[
                                        _buildSectionTitle('Education'),
                                        const SizedBox(height: 12),
                                        _buildEducationRow(
                                            guideValue.guidePrefrence
                                                    ?.ugCollegeName ??
                                                "",
                                            guideValue.guidePrefrence
                                                    ?.ugDegreeType ??
                                                "",
                                            "Undergraduate"),
                                        if (guideValue.guidePrefrence
                                                    ?.gCollegeName !=
                                                null &&
                                            guideValue.guidePrefrence!
                                                .gCollegeName.isNotEmpty)
                                          _buildEducationRow(
                                              guideValue.guidePrefrence
                                                      ?.gCollegeName ??
                                                  "",
                                              guideValue.guidePrefrence
                                                      ?.gDegreeType ??
                                                  "",
                                              "Graduate"),
                                        _buildDivider(),
                                      ],

                                      // --- G. POLICIES (Read Only for now) ---
                                      _buildSectionTitle('Policies'),
                                      const SizedBox(height: 12),
                                      _buildPolicyRow('Session cancellation',
                                          "${guideValue.guidePrefrence?.lessonCancellation ?? ""} hours notice"),
                                      _buildPolicyRow('Hours Available',
                                          "${guideValue.guidePrefrence?.hoursAvailablePerWeek ?? ""} hrs/week"),
                                      _buildDivider(),

                                      // --- H. REVIEWS ---
                                      _buildSectionTitle(
                                          'Reviews (${guideValue.guideReviews.length})'),
                                      const SizedBox(height: 12),
                                      if (guideValue.guideReviews.isNotEmpty)
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              guideValue.guideReviews.length,
                                          separatorBuilder: (c, i) =>
                                              Divider(color: Colors.grey[200]),
                                          itemBuilder: (context, index) {
                                            var review =
                                                guideValue.guideReviews[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(review.ratingComment,
                                                  style: const TextStyle(
                                                      color: Colors.black87)),
                                            );
                                          },
                                        )
                                      else
                                        const Text("No reviews yet.",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Booking Button (Only if NOT own profile)
                        if (!isOwnProfile)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, -5))
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () =>
                                    _handleBookingLogic(context, guideValue),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Book Your Session',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  // ================= HELPERS =================

  Widget _buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Divider(color: Colors.grey[200], thickness: 1.5),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: kTextBlack, fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildStatItem(Widget iconWidget, String label, String value) {
    return Column(
      children: [
        SizedBox(height: 26, width: 26, child: iconWidget),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                color: kTextGrey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 90),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: kTextBlack, fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {required bool isBlue}) {
    if (label.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isBlue ? kChipBlue : kBgGrey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isBlue ? Colors.white : kPrimaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 13),
      ),
    );
  }

  Widget _buildSimpleTag(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 13, color: Colors.black54)),
    );
  }

  Widget _buildEducationRow(String school, String degree, String level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: kBgGrey, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.school, color: kPrimaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(school,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text("$level • $degree",
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  void _handleBookingLogic(BuildContext context, Guide guideValue) {
    if (userDataNotifier.value == null) {
      Provider.of<MyAuthProvider>(context, listen: false).logout(context);
      return;
    }
    BookGuideProvider bookGuideProvider =
        Provider.of<BookGuideProvider>(context, listen: false);
    bookGuideProvider.selectedGuide = guideValue;

    if (guideValue.guidePrefrence?.instantBookingAvailability == 1) {
      CustomNavigation.push(
          context: context, screen: const SessionSlotsScreen());
      // showCustomBottomSheet(
      //     context: context,
      //     child: RequestInstantBooking(
      //         dateTime: "10:00 AM", guideId: guideValue.id.toString()));
    } else {
      CustomNavigation.push(
          context: context, screen: const SessionSlotsScreen());
      // CustomNavigation.push(
      //     context: context, screen: const ContactToGuideScreen());
    }
  }
}
