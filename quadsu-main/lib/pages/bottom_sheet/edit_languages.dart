

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_text.dart';

class EditLanguage extends StatefulWidget {
  const EditLanguage({super.key});

  @override
  State<EditLanguage> createState() => _EditLanguageState();
}

class _EditLanguageState extends State<EditLanguage> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> reload = ValueNotifier(false);

  ValueNotifier specialitiesNotifier = ValueNotifier(null);
  List languageList=[];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var myAuthProvider=Provider.of<MyAuthProvider>(context,listen: false);
      if(userDataNotifier.value?.guidePrefrence?.guideLanguage != null){
        List tempt= userDataNotifier.value?.guidePrefrence?.guideLanguage.split(',')??[];
        print('lklk---');
        for(int j =0; j<tempt.length;j++){
          for(int i =0; i<myAuthProvider.globalLanguages.length;i++){
            if(tempt[j].trim()==myAuthProvider.globalLanguages[i]['id'].toString()){
              languageList.add(myAuthProvider.globalLanguages[i]);
              reload.value=!reload.value;
            }
          }
        }
      }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder(
          valueListenable: reload,
          builder: (context, reloadValue, child)  {
            return Consumer<MyAuthProvider>(
                builder: (context, myAuthProvider, child)  {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.headingSmall(
                        'Edit Language',
                        fontWeight: FontWeight.w600,
                      ),
                      vSizedBox3,
                      if( myAuthProvider.globalLanguages.isNotEmpty)
                        Wrap(
                          children:List.generate(languageList.length,
                                (index) {
                              return GestureDetector(
                                onTap: () {
                                  languageList.removeAt(index);
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
                                    "${languageList[index]['language']} ×",
                                    fontWeight: FontWeight.w600,
                                    increamentFontSize: 1,
                                  ),
                                ),
                              );
                            },),
                        ),
                      if(languageList.isNotEmpty)
                        const SizedBox(
                          height: 5,
                        ),
                      if( myAuthProvider.globalSpecialities.isNotEmpty)
                        ValueListenableBuilder(
                          valueListenable:specialitiesNotifier ,
                          builder: (context, specialitiesValue, child) =>
                              CustomDropdownButton(
                                items: myAuthProvider.globalLanguages,
                                hint:'Select' ,
                                hintTextFontSize: 14,
                                contentPaddingVertical: 11,
                                headingFontWeight:FontWeight.w600,
                                itemMapKey: "language",
                                singleSelectedItem: specialitiesValue,
                                // validatorSingle: (val) {
                                //   return ValidationFunction.requiredValidation(val);
                                // },
                                onChangedSingle: (val){
                                  specialitiesNotifier.value=val;
                                  if(!languageList.contains(val)){
                                    languageList.add(val);
                                    reload.value=!reload.value;
                                  }
                                },
                              ),
                        ),
                      vSizedBox2,
                      CustomButton(
                        height: 50,
                        borderRadius: 4,
                        text: 'Save',
                        fontWeight: FontWeight.w600,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            Map<String,dynamic> request= {};
                            List<String> lIds=[];
                            if(languageList.isEmpty) {
                              showSnackbar("Please select language");
                              return;}
                              for(int i=0;i<languageList.length;i++) {
                                lIds.add(languageList[i]['id'].toString());
                                request[ApiKeys.language]=lIds;}
                              print("print ::::: List Of Ifd:::$lIds");
                              print("print ::::: List Of Ifd:::$request");
                             myAuthProvider.editLanguage(context, request: request);
                          }
                        },
                      )
                    ],
                  );
                });
          }
      ),
    );
  }
}
