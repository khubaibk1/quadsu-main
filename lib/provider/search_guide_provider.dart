import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/modal/search_guide_model.dart';
import 'package:quadsu_app/services/api_urls.dart';
import 'package:quadsu_app/services/newest_webservices.dart';

class SearchGuideProvider extends ChangeNotifier{
  String searchKeyWord='';
  String searchCategoryId="";
  String searchHourlyRate="";
  String shortBy="Top Guides";

  List<String> searchLanguageValues=[];
  List<String> searchUniversityValues=[];
  List<String> searchStudentPrefValues=[];
  List<String> searchAvailableDaysValues=[];
  List<String> searchRattingValues=[];

  SearchGuide? searchGuide;
  List<SearchGuideList> searchGuideList= [];
  bool searchGuideLode=false;
  bool isLastGuide=false;
  int offset=1;
  bool isRefresh=false;

  Future<void> getGuideSearchResult() async {
    searchGuideLode=true;
    if(offset==1&& isRefresh==false)
      {
        EasyLoading.show();
      }
    notifyListeners();
    Map<String,dynamic> request={};
     request[ApiKeys.page]=offset;
    if(shortBy.isNotEmpty)
      {
        request[ApiKeys.sortOptionValue]=shortBy;
      }

    if(searchCategoryId.isNotEmpty)
      {
        request[ApiKeys.selectedCategoryId]=searchCategoryId;
      }

    if(searchKeyWord.isNotEmpty)
      {
        request[ApiKeys.keyword]=searchKeyWord;

      }

    if(searchHourlyRate.isNotEmpty)
      {
        request[ApiKeys.searchByHourlyRate]=searchHourlyRate;
      }


    if(searchRattingValues.isNotEmpty)
      {
        request[ApiKeys.selectedRattingValues]=searchRattingValues;

      }

    if(searchLanguageValues.isNotEmpty)
      {
      request[ApiKeys.selectedLangValues]=searchLanguageValues;

      }

    if(searchStudentPrefValues.isNotEmpty)
      {
      request[ApiKeys.selectedStudentPreValues]=searchStudentPrefValues;

      }

    if(searchUniversityValues.isNotEmpty)
      {
      request[ApiKeys.selectedUniversityValues]=searchUniversityValues;

      }

    if(searchAvailableDaysValues.isNotEmpty)
      {
      request[ApiKeys.selectedAvailabilityValues]=searchAvailableDaysValues;

      }


    var jsonResponse = await NewestWebServices.getResponse(
      apiUrl: ApiUrls.searchGuide,
      request: request,
      apiMethod: ApiMethod.post,
    );

    if (jsonResponse.status == 1) {
      print("datdadtadatadtadtadtadtadtadta:::::::::::::${jsonResponse.data}");

      if(offset==1)
        {
          isLastGuide=false;
          notifyListeners();
          searchGuide=SearchGuide.fromJson(jsonResponse.data);
          searchGuideList=List.from(searchGuide?.data??[]);
        }
      else
      {
        searchGuide=SearchGuide.fromJson(jsonResponse.data);
        if(searchGuide?.data.isNotEmpty==true)
          {
            searchGuideList=List.from(searchGuideList+searchGuide!.data);
            isLastGuide=false;
          }
        else
          {
            isLastGuide=true;
          }
      }
    }

    EasyLoading.dismiss();
    searchGuideLode=false;
    notifyListeners();
  }




  void resetAllValues()
  {
    searchKeyWord="";
    searchCategoryId="";
    searchHourlyRate="";
    shortBy="Top Guides";
    offset=1;
    isRefresh=false;
    isLastGuide=false;
    searchGuideLode=false;
    searchGuide=null;
    searchGuideList.clear();
    searchLanguageValues.clear();
    searchUniversityValues.clear();
    searchStudentPrefValues.clear();
    searchAvailableDaysValues.clear();
    searchRattingValues.clear();
    notifyListeners();
  }
}