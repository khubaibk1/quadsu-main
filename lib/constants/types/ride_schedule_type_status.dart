

class RideScheduleTypeStatus{
  static const int immediate = 0;
  static const int schedule = 1;

  static String getName(int status){
    switch(status){
      case RideScheduleTypeStatus.immediate:return "Immediate";
      case RideScheduleTypeStatus.schedule:return "Schedule";
     default: return 'Immediate';
    }
  }
}