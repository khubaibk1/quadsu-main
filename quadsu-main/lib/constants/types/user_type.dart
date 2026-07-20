class UserType{
  static const String student="student";
  static const String guide="guide";



  static String getName(String status, {int? secsLeft}){
    switch(status){
      case UserType.student:return 'Student';
      case UserType.guide: return 'Guid';
      // case UserType.company: return 'Company';

      default: return 'Other';
    }
  }
}
