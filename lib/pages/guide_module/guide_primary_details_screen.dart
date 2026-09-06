
import 'dart:async';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_image_url.dart';
import 'package:quadsu_app/pages/auth_module/login_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/services/image_picker.dart';
import 'package:quadsu_app/services/location_services.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/widget/custom_gesture_detector.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_button.dart';

class GuidePrimaryDetailsScreen extends StatefulWidget {
  const GuidePrimaryDetailsScreen({super.key});

  @override
  State<GuidePrimaryDetailsScreen> createState() => _GuidePrimaryDetailsScreenState();
}

class _GuidePrimaryDetailsScreenState extends State<GuidePrimaryDetailsScreen> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController profileHeadlineController = TextEditingController();
  TextEditingController tagLineController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  TextEditingController locationAddress = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);
  ValueNotifier universityNotifier = ValueNotifier(null);
  ValueNotifier languageNotifier = ValueNotifier(null);
  List language=[];
  List speciality=[];
  ValueNotifier specialitiesNotifier = ValueNotifier(null);
  ValueNotifier<GetLocation?> getLocationModel = ValueNotifier(null);
  ValueNotifier<bool> reload = ValueNotifier(false);
  Timer? searchTimer;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAuthProvider>(
        builder: (context, myAuthProvider, child) {
        return ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child)  {
            print("datdatdtda:::::::${getLocationModel.value?.predictions?.length}");
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  color: MyColors.whiteColor,
                  image: DecorationImage(
                      alignment: Alignment.bottomLeft,
                      image: AssetImage(MyImagesUrl.loginBgImage),
                      fit: BoxFit.fill
                  ),
              ),
              child: CustomScaffold(
                backgroundColor: MyColors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: loginFormKey,
                      child:Padding(
                        padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                CustomNavigation.pushAndRemoveUntil(context: context, screen:const LoginPage());
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: (){
                                      var provider=Provider.of<MyAuthProvider>(context,listen: false);
                                      provider.logoutPopup(context);
                                    },
                                    icon: Image.asset(MyImagesUrl.logout,width: 23,),
                                  ),
                                  hSizedBox05,
                                  CustomText.headingSmall('Logout')

                                ],
                              ),
                            ),
                            vSizedBox2,
                            CustomText.headingLarge(
                              "Welcome, ${userDataNotifier.value?.firstName??""}!",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            vSizedBox05,
                            CustomText.bodyText1(
                              "to get started, tell us more about yourself",
                            ),
                            vSizedBox2,
                             Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CustomImage(imageUrl: MyImagesUrl.profile_icon,
                                    fileType: image == null ?CustomFileType.asset:CustomFileType.file,
                                    height: 120,image: image,
                                    width: 120,fit: image == null ?null:BoxFit.cover,
                                  ),
                                  CustomGestureDetector(
                                    onTap: () async {
                                      image=await cameraImagePicker(context);
                                      reload.value=!reload.value;
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right:3,bottom: 7),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:MyColors.cyanColor ,
                                        child: Icon(Icons.add,color: MyColors.whiteColor,size: 18,),
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
                            CustomTextField(
                              controller: profileHeadlineController,
                              hintText: "",
                              //headingText: 'Profile Headline',
                              headingText: 'Describe Yourself In One Sentence',
                              headingFontSize: 15,
                              maxLines: 3,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,
                            CustomTextField(
                              controller: tagLineController,
                              hintText: "",
                              headingText: 'Fun Fact About You!',
                              // headingText: 'Profile Tag Line',
                              headingFontSize: 15,
                              maxLines: 3,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,

                            if( myAuthProvider.globalUniversity.isNotEmpty)
                              Consumer<MyAuthProvider>(
                                  builder: (context, myAuthProvider, child) {
                                    return ValueListenableBuilder(
                                      valueListenable:universityNotifier ,
                                      builder: (context, universityValue, child) =>
                                          CustomDropdownButton(
                                            items:myAuthProvider.globalUniversity,
                                            hint:'' ,
                                            wantSearch:true,
                                            headingText: 'University',
                                            headingFontWeight:FontWeight.w600,
                                            singleSelectedItem: universityValue,
                                            validatorSingle: (val) {
                                              return ValidationFunction.requiredValidation(val);
                                            },
                                            itemMapKey: "university_name",
                                            onChangedSingle: (val){
                                              universityNotifier.value=val;
                                            },
                                          ),
                                    );
                                  }
                              ),
                            if( myAuthProvider.globalUniversity.isNotEmpty)
                              vSizedBox2,

                            Wrap(
                              children:List.generate(language.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      language.removeAt(index);
                                      reload.value=!reload.value;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      margin: const EdgeInsets.only(right: 10,bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: MyColors.fillColor,
                                          border: Border.all(
                                              color: MyColors.enabledTextFieldBorderColor
                                          )
                                      ),
                                      child:  CustomText.bodyText2(
                                        "${language[index]['language']} ×",
                                        fontWeight: FontWeight.w600,
                                        increamentFontSize: 1,
                                      ),
                                    ),
                                  );
                                },),
                            ),
                            if(language.isNotEmpty)
                              const SizedBox(
                                height: 5,
                              ),
                            if( myAuthProvider.globalLanguages.isNotEmpty)

                            ValueListenableBuilder(
                              valueListenable:languageNotifier ,
                              builder: (context, languageValue, child) =>
                                  CustomDropdownButton(
                                    items: myAuthProvider.globalLanguages,
                                    hint:'' ,
                                    headingFontSize: 15,
                                    headingText: 'Your Language(s)',
                                    headingFontWeight:FontWeight.w600,
                                    singleSelectedItem: languageValue,
                                    itemMapKey: "language",
                                    validatorSingle: (val) {
                                      return ValidationFunction.requiredValidation(val);
                                    },
                                    onChangedSingle: (val){
                                      if(!language.contains(val))
                                        {
                                          language.add(val);
                                        }
                                      //languageNotifier.value=val;
                                      reload.value= !reload.value;
                                    },
                                  ),
                            ),
                            if( myAuthProvider.globalLanguages.isNotEmpty)
                              vSizedBox2,
                            Wrap(
                              children:List.generate(speciality.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      speciality.removeAt(index);
                                      reload.value=!reload.value;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      margin: const EdgeInsets.only(right: 10,bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: MyColors.fillColor,
                                          border: Border.all(
                                              color: MyColors.enabledTextFieldBorderColor
                                          )
                                      ),
                                      child:  CustomText.bodyText2(
                                        "${speciality[index]['title']} ×",
                                        fontWeight: FontWeight.w600,
                                        increamentFontSize: 1,
                                      ),
                                    ),
                                  );
                                },),
                            ),
                            if(speciality.isNotEmpty)
                              const SizedBox(
                                height: 5,
                              ),
                            if( myAuthProvider.globalSpecialities.isNotEmpty)
                            ValueListenableBuilder(
                              valueListenable:specialitiesNotifier ,
                              builder: (context, specialitiesValue, child) =>
                                  CustomDropdownButton(
                                    items: myAuthProvider.globalSpecialities,
                                    hint:'' ,
                                    headingFontSize: 15,
                                    // headingText: 'Your Specialty(s)',
                                     headingText: 'Your Specialty/Major/Concentration',
                                    headingFontWeight:FontWeight.w600,
                                    itemMapKey: "title",
                                    singleSelectedItem: specialitiesValue,
                                    validatorSingle: (val) {
                                      return ValidationFunction.requiredValidation(val);
                                    },
                                    onChangedSingle: (val){
                                      if(!speciality.contains(val))
                                      {
                                        speciality.add(val);
                                      }
                                      //  specialitiesNotifier.value=val;
                                      reload.value= !reload.value;
                                    },
                                  ),
                            ),
                            if( myAuthProvider.globalSpecialities.isNotEmpty)
                              vSizedBox2,

                            CustomTextField(
                              controller: hourlyRateController,
                              hintText: "",
                              headingText: 'Hourly Rate(\$)',
                              headingFontSize: 15,
                              keyboardType: TextInputType.number,

                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,
                            ValueListenableBuilder(
                                valueListenable: selectedCountryCode,
                                builder: (context, value, child) {
                                  return CustomTextField(
                                    controller: mobileNumberController,
                                    headingText: 'Enter Your Phone Number',
                                    keyboardType: TextInputType.number,
                                    hintText: "",
                                    headingFontSize: 15,
                                    headingFontWeight: FontWeight.w600,
                                    validator: (val){
                                      return ValidationFunction.mobileNumberValidation(val,);
                                    },
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
                                        margin: const EdgeInsets.only(right: 8,left: 1),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFD9D9D9),
                                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomText.textFieldText(
                                              "+$value",
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Icon(Icons.keyboard_arrow_down,
                                                  size: 20, color: MyColors.hintColor),
                                            ),

                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            vSizedBox2,
                            CustomText.headingLarge(
                              "Your Mailing Address",
                              fontWeight: FontWeight.w600,
                            ),
                            vSizedBox,
                            CustomTextField(
                              controller: locationAddress,
                              hintText: "",
                              headingText: 'Location',
                              headingFontSize: 15,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  const duration = Duration(
                                      milliseconds:
                                      600); // set the duration that you want call search() after that.
                                  if (searchTimer != null) {
                                    searchTimer?.cancel(); // clear timer
                                  }

                                  searchTimer = Timer(duration, () async {
                                    getLocationModel.value=  await getGoogleAutoCompleteApi(value: value.trim());
                                    reload.value=!reload.value;

                                  });
                                } else {
                                  if (searchTimer != null) {
                                    searchTimer?.cancel(); // clear timer
                                  }
                                  getLocationModel.value = null;
                                }
                                reload.value=!reload.value;
                              },

                            ),
                            vSizedBox05,
                            Builder(
                              builder: (context) {
                                if (getLocationModel.value !=null) {
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
                                            if (predictions?.placeId != null &&
                                                predictions!
                                                    .placeId!.isNotEmpty) {
                                              AddressModal addressModel =
                                              await getPlaceDetails(predictions.placeId!);
                                              locationAddress.text = predictions
                                                  .structuredFormatting
                                                  ?.mainText ??
                                                  "";
                                              cityController.text = addressModel.city ??
                                                  "";
                                              stateController.text =
                                                  addressModel.state??"";
                                              countryController.text =
                                                  addressModel.country??"";
                                              pinCodeController.text =
                                                  addressModel.pincode??"";
                                            }
                                            getLocationModel.value = null;
                                            reload.value=!reload.value;

                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 15,
                                                top: index == 0 ? 15 : 0,
                                                left: 10,
                                                right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(getLocationModel.value?.predictions![index]
                                                    .description ??
                                                    ""),
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
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,
                            CustomTextField(
                              controller: stateController,
                              hintText: "",
                              headingText: 'State',
                              headingFontSize: 15,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,
                            CustomTextField(
                              controller: pinCodeController,
                              hintText: "",
                              headingText: 'Zip Code',
                              headingFontSize: 13,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,
                            CustomTextField(
                              controller: cityController,
                              hintText: "",
                              headingText: 'City',
                              headingFontSize: 15,
                              headingFontWeight: FontWeight.w600,
                              validator: (val) {
                                return ValidationFunction.requiredValidation(val);
                              },
                            ),
                            vSizedBox2,

                            Consumer<MyAuthProvider>(
                                builder: (context, myAuthProvider, child) {
                                  return CustomButton(
                                    height: 50,
                                    text: "Next",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    onTap: () async {
                                      String? url;


                                      if (loginFormKey.currentState!.validate()) {
                                        List<String> lIds=[];
                                        List<String> sIds=[];

                                        if(universityNotifier.value==null)
                                          {
                                            showSnackbar("Please select university");
                                            return;
                                          }

                                        Map<String,dynamic> request={
                                          ApiKeys.profileHeadline:profileHeadlineController.text.trim(),
                                          ApiKeys.tagLine:tagLineController.text.trim(),
                                          ApiKeys.hourlyRate:hourlyRateController.text.trim(),
                                          ApiKeys.location:locationAddress.text.trim(),
                                          ApiKeys.country:countryController.text.trim(),
                                          ApiKeys.state:stateController.text.trim(),
                                          ApiKeys.city:cityController.text.trim(),
                                          ApiKeys.zipCode:pinCodeController.text.trim(),
                                          ApiKeys.phone:mobileNumberController.text.trim(),
                                          ApiKeys.countryCode:selectedCountryCode.value,
                                          ApiKeys.university:universityNotifier.value['id'],
                                        };

                                        if(language.isEmpty)
                                          {
                                            showSnackbar("Please select language");
                                            return;
                                          }
                                        else
                                          {
                                            for(int i=0;i<language.length;i++)
                                            {
                                              lIds.add(language[i]['id'].toString());
                                            }
                                            request[ApiKeys.language]=lIds;

                                          }

                                       if(speciality.isEmpty)
                                          {
                                            showSnackbar("Please select speciality");
                                            return;
                                          }
                                       else
                                         {
                                           for(int i=0;i<speciality.length;i++)
                                           {
                                             sIds.add(speciality[i]['title'].toString());
                                             //request['${ApiKeys.speciality}[$i]']=speciality[i]['id'];
                                           }
                                           request[ApiKeys.speciality]=sIds;
                                         }

                                        if(image != null)
                                        {
                                          EasyLoading.show();
                                          url= await NewestWebServices.uploadImageAndGetUrl(image!.path);
                                          request[ ApiKeys.profileImage]=url;
                                          EasyLoading.dismiss();
                                        }
                                        else
                                        {
                                          showSnackbar("Please select profile image");
                                          return;
                                        }
                                        print("dadatdtadt::::$url");


                                        myAuthProvider.signUpStep3(context, request: request);

                                      }
                                    },
                                  );
                                }),
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
