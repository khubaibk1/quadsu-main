import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomNavigation{
  static Future push({required  BuildContext context, required Widget screen,bool isCupertinoPush=true})async{
    if(isCupertinoPush){
      return    Navigator.push(context,CupertinoPageRoute(builder: (context){
        return screen;
      }));
    }
    else{
      return Navigator.push(context, MaterialPageRoute(builder: (context){
        return screen;
      }));
    }
  }

  static Future pushReplacement({required  BuildContext context, required Widget screen,bool isCupertinoPush=true})async{

    if(isCupertinoPush){
      return Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
        return screen;
      }));
    }
    else{
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return screen;
      }));
    }

  }
  static Future pushAndRemoveUntil({required  BuildContext context, required Widget screen,bool isCupertinoPush=true})async{

    if(isCupertinoPush){
      return   Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => screen,), (route) => false);
    }
    else{
      return   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen,), (route) => false);

    }
  }
  static Future pop<T extends Object?>(BuildContext context, [ T? result ])async{
    return Navigator.pop(context, result);
  }

  static Future popUntil<T extends Object?>(BuildContext context,RoutePredicate predicate)async{
    return Navigator.popUntil(context, predicate);
  }


}