import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/services/location_services.dart';
import 'package:quadsu_app/widget/custom_gesture_detector.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_image.dart';
import '../../services/image_picker.dart';

class GuideProfileSetupScreen extends StatefulWidget {
  const GuideProfileSetupScreen({super.key});

  @override
  State<GuideProfileSetupScreen> createState() =>
      _GuideProfileSetupScreenState();
}

class _GuideProfileSetupScreenState extends State<GuideProfileSetupScreen> {
  final loginFormKey = GlobalKey<FormState>();

  // Personal Information
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController venmoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationAddress = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);

  // Academic Information
  ValueNotifier universityNotifier = ValueNotifier(null);
  String? selectedGradYear;
  String? isTransferStudent;
  TextEditingController majorController = TextEditingController();

  // Languages
  ValueNotifier languageNotifier = ValueNotifier(null);
  List language = [];

  // Tell Us More
  TextEditingController collegeFactorController = TextEditingController();
  TextEditingController schoolDescriptionController = TextEditingController();
  TextEditingController funFactController = TextEditingController();
  String? everBeenGuide;
  String? hoursPerWeek;

  // Uploads
  File? videoFile;
  File? image;

  ValueNotifier<GetLocation?> getLocationModel = ValueNotifier(null);
  ValueNotifier<bool> reload = ValueNotifier(false);
  Timer? searchTimer;

  // Static Data for Dropdowns
  final List<String> gradYears = List.generate(
      DateTime.now().year + 6 - 1975 + 1,
      (index) => (1975 + index).toString()).reversed.toList();

  @override
  void initState() {
    super.initState();
    fullNameController.text = "${userDataNotifier.value?.firstName ?? ''} ${userDataNotifier.value?.lastName ?? ''}";
    emailController.text = userDataNotifier.value?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(
        builder: (context, myAuthProvider, child) {
        return ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  color: MyColors.whiteColor,
                  image: DecorationImage(
                      alignment: Alignment.bottomLeft,
                      image: AssetImage(MyImagesUrl.loginBgImage),
                      fit: BoxFit.fill)),
              child: CustomScaffold(
                backgroundColor: MyColors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: loginFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: globalHorizontalPadding, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    // --- Top Bar (Logout) ---
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            var provider = Provider.of<MyAuthProvider>(context,
                                listen: false);
                            provider.logoutPopup(context);
                          },
                          icon: Image.asset(
                            MyImagesUrl.logout,
                            width: 23,
                          ),
                        ),
                        hSizedBox05,
                        CustomText.headingSmall('Logout')
                      ],
                    ),
                    vSizedBox2,

                    // --- Welcome Header ---
                    CustomText.headingLarge(
                      "Welcome, ${userDataNotifier.value?.firstName ?? ''}!",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    vSizedBox05,
                    CustomText.bodyText1(
                      "to get started, tell us more about yourself",
                    ),
                    vSizedBox2,

                    // Profile Image Upload with Icon Overlay
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImage(
                            imageUrl: MyImagesUrl.profile_icon,
                            fileType: image == null ? CustomFileType.asset : CustomFileType.file,
                            height: 120,
                            image: image,
                            width: 120,
                            fit: image == null ? null : BoxFit.cover,
                          ),
                          CustomGestureDetector(
                            onTap: () async {
                              image = await cameraImagePicker(context);
                              reload.value = !reload.value;
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 3, bottom: 7),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: MyColors.cyanColor,
                                child: Icon(Icons.add, color: MyColors.whiteColor, size: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    vSizedBox,
                    Align(
                      alignment: Alignment.center,
                      child: CustomText.bodyText1(
                        "Upload your profile image",
                      ),
                    ),
                    vSizedBox2,

                    // ==========================================
                    // Personal Information
                    // ==========================================
                    CustomText.headingLarge(
                      "Personal Information",
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox,

                    CustomTextField(
                      controller: fullNameController,
                      hintText: "Enter full name",
                      headingText: 'Full Name',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: emailController,
                      hintText: "Enter email address",
                      headingText: 'Email',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: venmoController,
                      hintText: "@JohnDoe123",
                      headingText: 'Venmo Username',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomText.headingLarge(
                      "Your Mailing Address",
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox,

                    CustomTextField(
                      controller: locationAddress,
                      hintText: "",
                      headingText: 'Street Address',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          const duration = Duration(milliseconds: 600);
                          if (searchTimer != null) {
                            searchTimer?.cancel();
                          }
                          searchTimer = Timer(duration, () async {
                            getLocationModel.value = await getGoogleAutoCompleteApi(value: value.trim());
                            reload.value = !reload.value;
                          });
                        } else {
                          if (searchTimer != null) {
                            searchTimer?.cancel();
                          }
                          getLocationModel.value = null;
                        }
                        reload.value = !reload.value;
                      },
                    ),
                    vSizedBox05,
                    Builder(
                      builder: (context) {
                        if (getLocationModel.value != null) {
                          return Card(
                            color: MyColors.whiteColor,
                            surfaceTintColor: MyColors.whiteColor,
                            elevation: 1,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    Predictions? predictions = getLocationModel.value?.predictions![index];
                                    if (predictions?.placeId != null && predictions!.placeId!.isNotEmpty) {
                                      AddressModal addressModel = await getPlaceDetails(predictions.placeId!);
                                      locationAddress.text = predictions.structuredFormatting?.mainText ?? "";
                                      cityController.text = addressModel.city ?? "";
                                      stateController.text = addressModel.state ?? "";
                                      countryController.text = addressModel.country ?? "";
                                      pinCodeController.text = addressModel.pincode ?? "";
                                    }
                                    getLocationModel.value = null;
                                    reload.value = !reload.value;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15,
                                        top: index == 0 ? 15 : 0,
                                        left: 10,
                                        right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getLocationModel.value?.predictions![index].description ?? ""),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: getLocationModel.value?.predictions?.length,
                              shrinkWrap: true,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: countryController,
                      hintText: "",
                      headingText: 'Country',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: stateController,
                      hintText: "",
                      headingText: 'State',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: pinCodeController,
                      hintText: "",
                      headingText: 'Zip Code',
                      headingFontSize: 13,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: cityController,
                      hintText: "",
                      headingText: 'City',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    ValueListenableBuilder(
                        valueListenable: selectedCountryCode,
                        builder: (context, value, child) {
                          return CustomTextField(
                            controller: phoneController,
                            headingText: 'Enter Your Phone Number',
                            keyboardType: TextInputType.number,
                            hintText: "",
                            headingFontSize: 15,
                            headingFontWeight: FontWeight.w600,
                            validator: (val) => ValidationFunction.mobileNumberValidation(val),
                            prefix: InkWell(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (value) {
                                    selectedCountryCode.value = value.phoneCode;
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                margin: const EdgeInsets.only(right: 8, left: 1),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 10),
                                    CustomText.textFieldText("+$value"),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(Icons.keyboard_arrow_down, size: 20, color: MyColors.hintColor),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    vSizedBox2,

                    // ==========================================
                    // Academic Information
                    // ==========================================
                    CustomText.headingLarge(
                      "Academic Information",
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox,

                    if (myAuthProvider.globalUniversity.isNotEmpty)
                      ValueListenableBuilder(
                        valueListenable: universityNotifier,
                        builder: (context, universityValue, child) => CustomDropdownButton(
                          items: myAuthProvider.globalUniversity,
                          hint: '',
                          wantSearch: true,
                          headingText: 'University',
                          headingFontWeight: FontWeight.w600,
                          singleSelectedItem: universityValue,
                          validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                          itemMapKey: "university_name",
                          onChangedSingle: (val) {
                            universityNotifier.value = val;
                          },
                        ),
                      ),
                    if (myAuthProvider.globalUniversity.isNotEmpty) vSizedBox2,

                    CustomDropdownButton(
                      items: gradYears.map((year) => {"year": year}).toList(),
                      hint: '',
                      headingText: 'Year of Expected Graduation or Graduation Year',
                      headingFontWeight: FontWeight.w600,
                      singleSelectedItem: selectedGradYear != null ? {"year": selectedGradYear} : null,
                      validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                      itemMapKey: "year",
                      onChangedSingle: (val) {
                        setState(() {
                          selectedGradYear = val?['year'];
                        });
                      },
                    ),
                    vSizedBox2,

                    CustomDropdownButton(
                      items: [{"value": "Yes"}, {"value": "No"}],
                      hint: '',
                      headingText: 'Are you a transfer student?',
                      headingFontWeight: FontWeight.w600,
                      singleSelectedItem: isTransferStudent != null ? {"value": isTransferStudent} : null,
                      validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                      itemMapKey: "value",
                      onChangedSingle: (val) {
                        setState(() {
                          isTransferStudent = val?['value'];
                        });
                      },
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: majorController,
                      hintText: "",
                      headingText: 'Major/Concentration',
                      headingFontSize: 15,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    // ==========================================
                    // Languages Spoken
                    // ==========================================
                    Wrap(
                      children: List.generate(language.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            language.removeAt(index);
                            reload.value = !reload.value;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(right: 10, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: MyColors.fillColor,
                                border: Border.all(color: MyColors.enabledTextFieldBorderColor)),
                            child: CustomText.bodyText2(
                              "${language[index]['language']} ×",
                              fontWeight: FontWeight.w600,
                              increamentFontSize: 1,
                            ),
                          ),
                        );
                      }),
                    ),
                    if (language.isNotEmpty) const SizedBox(height: 5),
                    if (myAuthProvider.globalLanguages.isNotEmpty)
                      ValueListenableBuilder(
                        valueListenable: languageNotifier,
                        builder: (context, languageValue, child) => CustomDropdownButton(
                          items: myAuthProvider.globalLanguages,
                          hint: '',
                          headingFontSize: 15,
                          headingText: 'Your Language(s)',
                          headingFontWeight: FontWeight.w600,
                          singleSelectedItem: languageValue,
                          itemMapKey: "language",
                          validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                          onChangedSingle: (val) {
                            if (!language.contains(val)) {
                              language.add(val);
                            }
                            reload.value = !reload.value;
                          },
                        ),
                      ),
                    if (myAuthProvider.globalLanguages.isNotEmpty) vSizedBox2,

                    // ==========================================
                    // Tell Us More!
                    // ==========================================
                    CustomText.headingLarge(
                      "Tell Us More!",
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox,

                    CustomTextField(
                      controller: collegeFactorController,
                      hintText: "The campus location and scholarship opportunities.",
                      headingText: 'What was the most important factor in your college decision?',
                      headingFontSize: 15,
                      maxLines: 3,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: schoolDescriptionController,
                      hintText: "A vibrant and diverse campus with strong student support programs.",
                      headingText: 'How would you describe your school to prospective students?',
                      headingFontSize: 15,
                      maxLines: 3,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomTextField(
                      controller: funFactController,
                      hintText: "I once backpacked across Europe in a summer!",
                      headingText: 'Fun Fact About You!',
                      headingFontSize: 15,
                      maxLines: 3,
                      headingFontWeight: FontWeight.w600,
                      validator: (val) => ValidationFunction.requiredValidation(val),
                    ),
                    vSizedBox2,

                    CustomDropdownButton(
                      items: [{"value": "Yes"}, {"value": "No"}],
                      hint: '',
                      headingText: 'Have you ever been a guide before?',
                      headingFontWeight: FontWeight.w600,
                      singleSelectedItem: everBeenGuide != null ? {"value": everBeenGuide} : null,
                      validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                      itemMapKey: "value",
                      onChangedSingle: (val) {
                        setState(() {
                          everBeenGuide = val?['value'];
                        });
                      },
                    ),
                    vSizedBox2,

                    CustomDropdownButton(
                      items: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"].map((h) => {"hours": h}).toList(),
                      hint: '',
                      headingText: 'How many hours per week are you available?',
                      headingFontWeight: FontWeight.w600,
                      singleSelectedItem: hoursPerWeek != null ? {"hours": hoursPerWeek} : null,
                      validatorSingle: (val) => ValidationFunction.requiredValidation(val),
                      itemMapKey: "hours",
                      onChangedSingle: (val) {
                        setState(() {
                          hoursPerWeek = val?['hours'];
                        });
                      },
                    ),
                    vSizedBox2,

                    // ==========================================
                    // Uploads
                    // ==========================================
                    CustomText.headingLarge(
                      "Upload a Video About Yourself (Optional)",
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox,
                    GestureDetector(
                      onTap: () async {
                        File? file = await videoPickerDialog(context, shouldCompress: true);
                        if (file != null) {
                          videoFile = file;
                          reload.value = !reload.value;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.shade100,
                        ),
                        child: Row(
                          children: [
                            const Text("Choose file", style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                videoFile != null ? videoFile!.path.split('/').last : "No file chosen",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "A 30-second self-introduction video...",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    vSizedBox3,

                    // ==========================================
                    // Submit Button
                    // ==========================================
                    CustomButton(
                      height: 50,
                      text: "Next",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      onTap: () async {
                        if (loginFormKey.currentState!.validate()) {
                          if (universityNotifier.value == null) {
                            showSnackbar("Please select university");
                            return;
                          }
                          if (selectedGradYear == null || isTransferStudent == null || everBeenGuide == null || hoursPerWeek == null) {
                            showSnackbar("Please fill in all dropdown selections.");
                            return;
                          }
                          if (language.isEmpty) {
                            showSnackbar("Please select language");
                            return;
                          }
                          if (image == null) {
                            showSnackbar("Please upload a profile image.");
                            return;
                          }

                          // Upload files first
                          EasyLoading.show();
                          String? imageUrl = await NewestWebServices.uploadImageAndGetUrl(image!.path);
                          String? videoUrl;
                          if (videoFile != null) {
                            videoUrl = await NewestWebServices.uploadImageAndGetUrl(videoFile!.path, isVideo: true);
                          }
                          EasyLoading.dismiss();

                          if (imageUrl == null) {
                            showSnackbar("Failed to upload profile image.");
                            return;
                          }

                          List<String> lIds = [];
                          for (int i = 0; i < language.length; i++) {
                            lIds.add(language[i]['id'].toString());
                          }

                          // Construct Request
                          Map<String, dynamic> request = {
                            "user_id": userDataNotifier.value?.userId, 
                            "full_name": fullNameController.text.trim(),
                            "email": emailController.text.trim(),
                            "venmo_username": venmoController.text.trim(),
                            "phone": phoneController.text.trim(),
                            "country_code": selectedCountryCode.value,
                            "location": locationAddress.text.trim(),
                            "country": countryController.text.trim(),
                            "state": stateController.text.trim(),
                            "city": cityController.text.trim(),
                            "zip_code": pinCodeController.text.trim(),
                            "university": universityNotifier.value['id'],
                            "name_of_the_institutions": universityNotifier.value['university_name'],
                            "grad_year": selectedGradYear,
                            "is_transfer": isTransferStudent,
                            "major": majorController.text.trim(),
                            "language": lIds,
                            "college_factor": collegeFactorController.text.trim(),
                            "school_desc": schoolDescriptionController.text.trim(),
                            "fun_fact": funFactController.text.trim(),
                            "ever_been_a_guide": everBeenGuide?.toLowerCase(),
                            "hours_a_week_avilable": int.tryParse(hoursPerWeek ?? "0") ?? 0,
                            "profile_image": imageUrl,
                          };

                          if (videoUrl != null) {
                            request["video"] = videoUrl;
                          }

                          // Debug
                          print('=== SIGNUP STEP 2 REQUEST ===');
                          print('User ID: ${userDataNotifier.value?.userId}');
                          print('Request Data: $request');
                          print('============================');

                          // Submit to Provider
                          myAuthProvider.signUpStep2(context, request: request);
                        } else {
                          showSnackbar("Please fill all required fields");
                        }
                      },
                    ),
                    vSizedBox3,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
          }
        );
      }
    );
  }
}