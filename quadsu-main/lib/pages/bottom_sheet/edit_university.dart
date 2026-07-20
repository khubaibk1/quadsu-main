

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

class EditUniversity extends StatefulWidget {
  const EditUniversity({super.key});

  @override
  State<EditUniversity> createState() => _EditUniversityState();
}

class _EditUniversityState extends State<EditUniversity> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> reload = ValueNotifier(false);

  ValueNotifier specialitiesNotifier = ValueNotifier(null);
  List universityList=[];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var myAuthProvider=Provider.of<MyAuthProvider>(context,listen: false);
      if(userDataNotifier.value?.guidePrefrence?.university != null){
        List tempt= userDataNotifier.value?.guidePrefrence?.university.split(',')??[];
        print('lklk---');
        for(int j =0; j<tempt.length;j++){
          for(int i =0; i<myAuthProvider.globalUniversity.length;i++){
            if(tempt[j].trim()==myAuthProvider.globalUniversity[i]['id'].toString()){
              universityList.add(myAuthProvider.globalUniversity[i]);
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
                        'Edit University',
                        fontWeight: FontWeight.w600,
                      ),
                      vSizedBox3,
                      if( myAuthProvider.globalLanguages.isNotEmpty)
                        Wrap(
                          children:List.generate(universityList.length,
                                (index) {
                              return GestureDetector(
                                onTap: () {
                                  universityList.removeAt(index);
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
                                    "${universityList[index]['university_name']} ×",
                                    fontWeight: FontWeight.w600,
                                    increamentFontSize: 1,
                                  ),
                                ),
                              );
                            },),
                        ),
                      if(universityList.isNotEmpty)
                        const SizedBox(
                          height: 5,
                        ),
                      if( myAuthProvider.globalSpecialities.isNotEmpty)
                        ValueListenableBuilder(
                          valueListenable:specialitiesNotifier ,
                          builder: (context, specialitiesValue, child) =>
                              CustomDropdownButton(
                                items: myAuthProvider.globalUniversity,
                                hint:'Select' ,
                                hintTextFontSize: 14,
                                contentPaddingVertical: 11,
                                headingFontWeight:FontWeight.w600,
                                itemMapKey: "university_name",
                                singleSelectedItem: specialitiesValue,
                  wantSearch:true,
                                // validatorSingle: (val) {
                                //   return ValidationFunction.requiredValidation(val);
                                // },
                                onChangedSingle: (val){
                                  specialitiesNotifier.value=val;
                                  if(!universityList.contains(val)){
                                    universityList.add(val);
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
                            if(universityList.isEmpty) {
                              showSnackbar("Please select language");
                              return;}
                            for(int i=0;i<universityList.length;i++) {
                              lIds.add(universityList[i]['id'].toString());
                              request[ApiKeys.university]=lIds;}
                            print("print ::::: List Of Ifd:::$lIds");
                            print("print ::::: List Of Ifd:::$request");
                            myAuthProvider.editUniversity(context, request: request);
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
