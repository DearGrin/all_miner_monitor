import 'package:get/get_utils/src/extensions/internacionalization.dart';

String intToDate(int? value){
  if(value !=null) {
    int h, m, s;
    String d, min, hr, sec;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    d = 'd'.tr;
    hr ='h'.tr;
    min = 'm'.tr;
    sec='s'.tr;
    String result = '$h$hr $m$min $s$sec';
    return result;
  }
  else {
    return '';
  }
}