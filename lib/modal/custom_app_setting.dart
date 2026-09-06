class MyAppSettings {
  String? firebaseProjectId;
  int? firebaseProjectNumber;
  String? agoraAppid;
  String? agoraSignkey;
  String? agoraProjectname;
  String? agoraCustomerkey;
  String? agoraCustomersecret;
  String? paypalClientId;
  String? paypalClientSecret;
  bool? isPaymentLive;
  String ? payPalBaseUrl;
  bool? isHide;
  String? sessionPrice;

  MyAppSettings(
      {this.firebaseProjectId,
        this.firebaseProjectNumber,
        this.agoraAppid,
        this.agoraSignkey,
        this.agoraProjectname,
        this.agoraCustomerkey,
        this.agoraCustomersecret,
        this.paypalClientId,
        this.isPaymentLive,
        this.payPalBaseUrl,
        this.paypalClientSecret,
      this.isHide=true});

  MyAppSettings.fromJson(Map<String, dynamic> json) {
    print("value of hide is ::::::::${json['paypal_api_baseurl']}");
    firebaseProjectId = json['firebase_project_id']??"";
    firebaseProjectNumber = json['firebase_project_number']??0101;
    agoraAppid = json['agora_appid']??"";
    agoraSignkey = json['agora_signkey']??"";
    agoraProjectname = json['agora_projectname']??"";
    agoraCustomerkey = json['agora_customerkey']??"";
    agoraCustomersecret = json['agora_customersecret']??"";
    
    paypalClientId = json['paypal_client_id'] ?? json['PAYPAL_CLIENT_ID'] ?? "";
    paypalClientSecret = json['paypal_client_secret'] ?? json['PAYPAL_CLIENT_SECRET'] ?? "";
    payPalBaseUrl = json['paypal_api_baseurl'] ?? json['PAYPAL_API_BASEURL'] ?? "";
    
    sessionPrice = json['session_price']?.toString() ?? json['SESSION_PRICE']?.toString() ?? "0";
    if (payPalBaseUrl != null && payPalBaseUrl!.toLowerCase().contains("sandbox")) {
      isPaymentLive = false;
    } else {
      isPaymentLive = json['paypal_is_live'] == "FALSE" ? false : true;
    }
    isHide = json['isHide']!= null ?json['isHide'].toString()=="1":true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_price'] = sessionPrice;
    data['firebase_project_id'] = firebaseProjectId;
    data['firebase_project_number'] = firebaseProjectNumber;
    data['agora_appid'] = agoraAppid;
    data['agora_signkey'] = agoraSignkey;
    data['agora_projectname'] = agoraProjectname;
    data['agora_customerkey'] = agoraCustomerkey;
    data['agora_customersecret'] = agoraCustomersecret;
    data['paypal_client_id'] = paypalClientId;
    data['paypal_client_secret'] = paypalClientSecret;
    data['paypal_is_live'] = isPaymentLive;
    data['paypal_api_baseurl'] = payPalBaseUrl;
    return data;
  }
}