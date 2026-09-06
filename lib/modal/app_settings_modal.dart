class AppSettingModal{
  int buildNumberAndroid;
  int buildNumberIos;

  AppSettingModal({
    required this.buildNumberAndroid,
    required this.buildNumberIos,
  });
  
  
  factory AppSettingModal.fromJson(Map json){
    return AppSettingModal(buildNumberAndroid: json['appVersionAndroid'], buildNumberIos: json['appVersionIos'],);
  }
}