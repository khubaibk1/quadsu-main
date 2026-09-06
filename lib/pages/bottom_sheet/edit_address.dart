import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/types/user_type.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../services/location_services.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';

class EditAddressDetails extends StatelessWidget {
  EditAddressDetails({super.key});

  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> reload = ValueNotifier(false);
  TextEditingController locationAddress = TextEditingController(text:usertype==UserType.guide? userDataNotifier.value?.guidePrefrence?.location??'':userDataNotifier.value?.studentPrefrence?.location);
  TextEditingController countryController = TextEditingController(text: usertype==UserType.guide?userDataNotifier.value?.guidePrefrence?.country??'':userDataNotifier.value?.studentPrefrence?.country??'');
  TextEditingController stateController = TextEditingController(text: usertype==UserType.guide?userDataNotifier.value?.guidePrefrence?.state??'':userDataNotifier.value?.studentPrefrence?.state??'');
  TextEditingController cityController = TextEditingController(text: usertype==UserType.guide?userDataNotifier.value?.guidePrefrence?.city??'':userDataNotifier.value?.studentPrefrence?.city??'');
  TextEditingController pinCodeController = TextEditingController(text: usertype==UserType.guide?userDataNotifier.value?.guidePrefrence?.zipCode??'':userDataNotifier.value?.studentPrefrence?.zipCode??'');
  ValueNotifier<GetLocation?> getLocationModel = ValueNotifier(null);
  String? latitude=userDataNotifier.value?.guidePrefrence?.latitude??'0';
  String? longitude=userDataNotifier.value?.guidePrefrence?.longitude??'0';
  Timer? searchTimer;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.headingSmall(
                  usertype==UserType.guide?'Edit Address':"Your Working Address",
                  fontWeight: FontWeight.w600,
                ),
                vSizedBox2,
                CustomTextField(
                  controller: locationAddress,
                  hintText: "",
                  headingText: 'Location',
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
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
                        getLocationModel.value =
                            await getGoogleAutoCompleteApi(value: value.trim());
                        reload.value = !reload.value;
                      });
                    } else {
                      if (searchTimer != null) {
                        searchTimer?.cancel(); // clear timer
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
                                Predictions? predictions =
                                    getLocationModel.value?.predictions![index];
                                if (predictions?.placeId != null &&
                                    predictions!.placeId!.isNotEmpty) {
                                  AddressModal addressModel =
                                      await getPlaceDetails(
                                          predictions.placeId!);
                                  locationAddress.text = predictions.structuredFormatting?.mainText ?? "";
                                  cityController.text = addressModel.city ?? "";
                                  stateController.text = addressModel.state ?? "";
                                  countryController.text = addressModel.country ?? "";
                                  pinCodeController.text = addressModel.pincode ?? "";
                                  latitude = addressModel.lat ?? "";
                                  longitude= addressModel.lng ?? "";
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
                                    Text(getLocationModel.value
                                            ?.predictions![index].description ??
                                        ""),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              getLocationModel.value?.predictions?.length,
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
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
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
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
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
                  hintTextFontSize: 14,
                  fontSize: 14,
                  contentPaddingVertical: 11,
                  headingFontWeight: FontWeight.w600,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                CustomButton(
                  height: 50,
                  borderRadius: 4,
                  text: 'Save',
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      MyAuthProvider myAuthProvider =
                          Provider.of<MyAuthProvider>(context, listen: false);
                      Map<String, dynamic> request = {
                        ApiKeys.location: locationAddress.text.trim(),
                        ApiKeys.country: countryController.text.trim(),
                        ApiKeys.state: stateController.text.trim(),
                        ApiKeys.city: cityController.text.trim(),
                        ApiKeys.zip_code: pinCodeController.text.trim(),
                        ApiKeys.latitude:latitude,
                        ApiKeys.longitude:longitude,
                      };
                      myAuthProvider.editAddress(context, request: request, userType: usertype);
                    }
                  },
                )
              ],
            );
          }),
    );
  }
}
