class ApprovalStatus{
  static const int approved = 1;
  static const int pending = 0;
  static const int rejected = 2;
  // static const int company = 3;


  static String getName(int status, {int? secsLeft}){
    switch(status){
      case ApprovalStatus.approved:return 'Approved';
      case ApprovalStatus.rejected: return 'Rejected';
      case ApprovalStatus.pending: return 'Pending';
    // case UserType.company: return 'Company';

      default: return 'Other';
    }
  }
}
