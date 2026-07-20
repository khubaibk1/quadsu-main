import 'package:flutter/cupertino.dart';

import '../constants/global_data.dart';

Map<String, dynamic> selectedLanguageNotifier = languagesList[1];
class AppLanguageProvider extends ChangeNotifier{





  initializeLanguage()async{
    print('initializeLanguage--');

    // sharedPreference = await SharedPreferences.getInstance();
    String? temp = sharedPreference.getString('lang');


    print('The default language of app is $temp');
    if(temp==null){
      selectedLanguageNotifier = languagesList[0];
    }else{
      for (var element in languagesList) {
        if(element['key']==temp){
          selectedLanguageNotifier = element;
        }
      }
    }
  }

  changeAppLanguage(dynamic value)async{
    selectedLanguageNotifier = value;
    sharedPreference.setString("lang", selectedLanguageNotifier['key']);
    notifyListeners();
  }

}
