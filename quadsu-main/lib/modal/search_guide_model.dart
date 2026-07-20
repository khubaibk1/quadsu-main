import '../services/api_urls.dart';

class SearchGuide {

  int currentPage;
  List<SearchGuideList> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Links> links;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  SearchGuide({
    this.currentPage = 0,
    this.data = const [],
    this.firstPageUrl = "",
    this.from = 0,
    this.lastPage = 0,
    this.lastPageUrl = "",
    this.links = const [],
    this.nextPageUrl = "",
    this.path = "",
    this.perPage = 0,
    this.prevPageUrl = "",
    this.to = 0,
    this.total = 0,
  });

  SearchGuide.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] ?? 0,
        data = (json['data'] as List?)?.map((v) => SearchGuideList.fromJson(v)).toList() ?? [],
        firstPageUrl = json['first_page_url'] ?? "",
        from = json['from'] ?? 0,
        lastPage = json['last_page'] ?? 0,
        lastPageUrl = json['last_page_url'] ?? "",
        links = (json['links'] as List?)?.map((v) => Links.fromJson(v)).toList() ?? [],
        nextPageUrl = json['next_page_url'] ?? "",
        path = json['path'] ?? "",
        perPage = json['per_page'] ?? 0,
        prevPageUrl = json['prev_page_url'] ?? "",
        to = json['to'] ?? 0,
        total = json['total'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['links'] = links.map((v) => v.toJson()).toList();
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class SearchGuideList {
  int id;
  String firstName;
  String lastName;
  String profileHeadline;
  String speciality;
  String tagLine;
  String hourlyRate;
  String profileImage;
  String workingHoursCalculated;
  String tutoringExperience;
  String studentTypes;
  String guideLanguage;
  String university;
  double  avgRate;
  int noOfRate;
  String universityName;
  int session;
  int userCount;


  SearchGuideList({
    this.id = 0,
    this.firstName = "",
    this.lastName = "",
    this.profileHeadline = "",
    this.speciality = "",
    this.tagLine = "",
    this.session = 0,
    this.userCount= 0,
    this.hourlyRate = "",
    this.profileImage = "",
    this.workingHoursCalculated = "",
    this.tutoringExperience = "",
    this.studentTypes = "",
    this.guideLanguage = "",
    this.university = "",
    this.avgRate =0.0,
    this.noOfRate = 0,
    this.universityName = "",
  });

  SearchGuideList.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        firstName = json['first_name'] ?? "",
        lastName = json['last_name'] ?? "",
        profileHeadline = json['profile_headline'] ?? "",
        speciality = json['speciality'] ?? "",
        tagLine = json['tag_line'] ?? "",
        hourlyRate = json['hourly_rate'] ?? "",
        profileImage = json['profile_image']!=null ?"${ApiUrls.baseImageUrl}${json['profile_image']}" : "",
        workingHoursCalculated = json['working_hours_calculated'] ?? "",
        tutoringExperience = json['tutoring_experience'] ?? "",
        studentTypes = json['student_types'] ?? "",
        guideLanguage = json['guide_language'] ?? "",
        university = json['university'] ?? "",
        avgRate = json['avg_rate']!=null?double.parse(double.parse(json['avg_rate'].toString()).toStringAsFixed(1)):0.0,
        noOfRate = json['no_of_rate'] ?? 0,
        session = json['session']!=null?int.parse(json['session'].toString()): 0,
         userCount = json['user_count']!=null?int.parse(json['user_count'].toString()): 0,
        universityName = json['university_name'] ?? "";


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_headline'] = profileHeadline;
    data['speciality'] = speciality;
    data['tag_line'] = tagLine;
    data['hourly_rate'] = hourlyRate;
    data['profile_image'] = profileImage;
    data['working_hours_calculated'] = workingHoursCalculated;
    data['tutoring_experience'] = tutoringExperience;
    data['student_types'] = studentTypes;
    data['guide_language'] = guideLanguage;
    data['university'] = university;
    data['avg_rate'] = avgRate;
    data['no_of_rate'] = noOfRate;
    data['university_name'] = universityName;
    return data;
  }
}

class Links {
  String url;
  String label;
  bool active;

  Links({
    this.url = "",
    this.label = "",
    this.active = false,
  });

  Links.fromJson(Map<String, dynamic> json)
      : url = json['url'] ?? "",
        label = json['label'] ?? "",
        active = json['active'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}

