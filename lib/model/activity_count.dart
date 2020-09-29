import 'package:flutter/cupertino.dart';
import 'package:membership_card/model/activity_model.dart';
import 'package:membership_card/model/enterprise_model.dart';

///This is a structure of list including activities of all companies.
///Use "set" to assign the list
class ActivityCounter extends ChangeNotifier {
//  static const String ACTIVITY_JSON = "";

  List<ActivityInfo> _activityList = new List<ActivityInfo>();

  ActivityCounter(this._activityList);

  set activityList(List<ActivityInfo> value) {
    _activityList = value;
    notifyListeners();
  }

  ActivityCounter.fromJson(List<dynamic> json){
    List<ActivityInfo> list = [];
    for (int i = 0; i < json.length; i++) {
      list.add(ActivityInfo.fromJson(json[i]));
    }
    _activityList = list;
  }


  List<ActivityInfo> get activityList => _activityList;
  ActivityInfo getOneActivity(int index) {
    return _activityList.elementAt(index);
  }


}
