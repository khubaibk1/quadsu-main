class SharedPreferenceKeys {
  static const String userData = 'user_info';
  static const String userToken = 'token';
  static const String selectedLanguage = 'selectedLanguage';
  //pin or pattern
}


// orderID is null , order id is not sending in request, the paypal boooking verification req do not have order id, the id will come from paypal and that will send, see my laravel backend err