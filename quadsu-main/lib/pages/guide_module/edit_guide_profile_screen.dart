import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/custom_navigation_services.dart'; // Ensure this is imported
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import '../../services/image_picker.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_text.dart';
import '../student_module/guide_profile_screen.dart'; // Import for public profile

class EditGuideProfileScreen extends StatefulWidget {
  const EditGuideProfileScreen({super.key});

  @override
  State<EditGuideProfileScreen> createState() => _EditGuideProfileScreenState();
}

class _EditGuideProfileScreenState extends State<EditGuideProfileScreen> {
  File? image;
  bool _isLoading = true;
  bool _isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _gradYearController = TextEditingController();
  final TextEditingController _responseTimeController = TextEditingController();

  Map<String, dynamic>? _selectedUniversity;
  List<String> _selectedLanguageNames = [];

  static const Color kPrimaryBlue = Color(0xFF2D3388);
  static const Color kTextBlack = Color(0xFF1C1C1E);
  static const Color kTextGrey = Color(0xFF6E6E73);

  @override
  void initState() {
    super.initState();
    _fetchTutorProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specialityController.dispose();
    _aboutController.dispose();
    _interestsController.dispose();
    _expertiseController.dispose();
    _gradYearController.dispose();
    _responseTimeController.dispose();
    super.dispose();
  }

  Future<void> _fetchTutorProfile() async {
    try {
      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.getTutorProfile,
        request: {},
        apiMethod: ApiMethod.get,
      );

      if (response.status == 1) {
        final data = response.data;
        if (mounted) {
          setState(() {
            _firstNameController.text = data['first_name'] ?? userDataNotifier.value?.firstName ?? '';
            _lastNameController.text = data['last_name'] ?? userDataNotifier.value?.lastName ?? '';
            _specialityController.text = data['speciality'] ?? '';
            _aboutController.text = data['about'] ?? '';
            _interestsController.text = data['interests'] ?? '';
            _expertiseController.text = data['expertise'] ?? '';
            _gradYearController.text = data['graduation_year']?.toString() ?? '';
            _responseTimeController.text = data['response_time'] ?? '';

            // Find university from global list
            if (data['university'] != null) {
              final myAuthProvider = Provider.of<MyAuthProvider>(context, listen: false);
              _selectedUniversity = myAuthProvider.globalUniversity.firstWhere(
                (u) => u['id'].toString() == data['university'].toString(),
                orElse: () => null,
              );
            }

            String langString = data['language'] ?? "";
            if (langString.isNotEmpty) {
              final myAuthProvider = Provider.of<MyAuthProvider>(context, listen: false);
              List<String> langValues = langString.split(',').map((e) => e.trim()).toList();
              
              // Convert IDs to names if needed
              _selectedLanguageNames = langValues.map((val) {
                // Check if it's a number (ID) or already a name
                if (int.tryParse(val) != null) {
                  // It's an ID, find the language name
                  var lang = myAuthProvider.globalLanguages.firstWhere(
                    (l) => l['id'].toString() == val,
                    orElse: () => {'language': val},
                  );
                  return lang['language'] as String;
                } else {
                  // It's already a name
                  return val;
                }
              }).toList();
            }
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateTutorProfile() async {
    EasyLoading.show(status: 'Updating...');
    try {
      var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.updateTutorProfile,
        request: {
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "university": _selectedUniversity?['id'],
          "speciality": _specialityController.text.trim(),
          "about": _aboutController.text.trim(),
          "interests": _interestsController.text.trim(),
          "expertise": _expertiseController.text.trim(),
          "graduation_year": _gradYearController.text.trim(),
          "response_time": _responseTimeController.text.trim(),
          "language": _selectedLanguageNames,
        },
      );

      if (response.status == 1) {
        EasyLoading.showSuccess('Profile updated');
        setState(() => _isEditing = false);
        await Provider.of<MyAuthProvider>(context, listen: false).getUserData();
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading 
      ? const Center(child: CircularProgressIndicator(color: kPrimaryBlue))
      : SafeArea(
        bottom: false,
        child: Consumer<MyAuthProvider>(
          builder: (context, myAuthProvider, child) {
            return ValueListenableBuilder(
              valueListenable: userDataNotifier,
              builder: (context, userData, child) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: screenHeight * 0.4,
                      pinned: true,
                      backgroundColor: kPrimaryBlue,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Profile Image
                            GestureDetector(
                              onTap: () async {
                                image = await cameraImagePicker(context);
                                if (image != null) {
                                  EasyLoading.show();
                                  String? url = await NewestWebServices.uploadImageAndGetUrl(image!.path);
                                  if (context.mounted) {
                                    myAuthProvider.editProfileImage(context, request: {ApiKeys.profileImage: url}, userType: usertype);
                                  }
                                }
                              },
                              child: CustomImage(
                                imageUrl: userData?.guidePrefrence?.profileImage ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            
                            // Gradient Overlay
                            Container(color: Colors.black.withOpacity(0.4)),

                            // ============= VIEW PUBLIC PROFILE BUTTON =============
                            Positioned(
                              top: 16,
                              right: 16,
                              child: GestureDetector(
                                onTap: () {
                                  if (userData?.userId != null) {
                                    CustomNavigation.push(
                                      context: context,
                                      screen: GuideProfileScreen(guideId: userData!.userId),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.visibility, size: 16, color: kPrimaryBlue),
                                      SizedBox(width: 6),
                                      Text(
                                        'View Public Profile',
                                        style: TextStyle(
                                          color: kPrimaryBlue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Name & Email
                            Positioned(
                              bottom: 30, left: 0, right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    '${_firstNameController.text} ${_lastNameController.text}',
                                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  Text(userData?.email ?? "", style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Profile Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                _isEditing 
                                ? TextButton(
                                    onPressed: _updateTutorProfile,
                                    child: const Text("SAVE", style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold)),
                                  )
                                : IconButton(
                                    onPressed: () => setState(() => _isEditing = true),
                                    icon: const Icon(Icons.edit, color: kPrimaryBlue),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            if (_isEditing) ...[
                              _buildInlineField("First Name", _firstNameController),
                              _buildInlineField("Last Name", _lastNameController),
                            ],

                            _buildUniversityField(myAuthProvider),
                            _buildProfileItem("Speciality / Major", _specialityController, Icons.book_outlined),
                            _buildProfileItem("Graduation Year", _gradYearController, Icons.calendar_today, keyboardType: TextInputType.number),
                            _buildProfileItem("Bio / About", _aboutController, Icons.person_outline, maxLines: 4),
                            _buildProfileItem("Interests", _interestsController, Icons.star_border),
                            
                            const SizedBox(height: 12),
                            const Text("Languages", style: TextStyle(color: kTextGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            if (_isEditing)
                              Wrap(
                                spacing: 8,
                                children: myAuthProvider.globalLanguages.map((langMap) {
                                  String langName = langMap['language'];
                                  bool isSelected = _selectedLanguageNames.contains(langName);
                                  return FilterChip(
                                    label: Text(langName, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black)),
                                    selected: isSelected,
                                    selectedColor: kPrimaryBlue,
                                    onSelected: (val) {
                                      setState(() {
                                        val ? _selectedLanguageNames.add(langName) : _selectedLanguageNames.remove(langName);
                                      });
                                    },
                                  );
                                }).toList(),
                              )
                            else
                              Text(_selectedLanguageNames.isEmpty ? "Not set" : _selectedLanguageNames.join(', ')),

                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () => myAuthProvider.logoutPopup(context),
                              child: const Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kTextGrey, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, color: kTextGrey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                _isEditing 
                ? TextFormField(
                    controller: controller,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  )
                : Text(
                    controller.text.isEmpty ? 'Not set' : controller.text,
                    style: const TextStyle(fontSize: 15, color: kTextBlack),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildUniversityField(MyAuthProvider myAuthProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_outlined, color: kTextGrey, size: 22),
              const SizedBox(width: 15),
              const Text("University", style: TextStyle(fontSize: 13, color: kTextGrey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          _isEditing
          ? DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedUniversity,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: myAuthProvider.globalUniversity.map<DropdownMenuItem<Map<String, dynamic>>>((uni) {
                return DropdownMenuItem(
                  value: uni,
                  child: Text(
                    uni['university_name'],
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedUniversity = val),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 37),
              child: Text(
                _selectedUniversity?['university_name'] ?? 'Not set',
                style: const TextStyle(fontSize: 15, color: kTextBlack),
              ),
            ),
        ],
      ),
    );
  }
}