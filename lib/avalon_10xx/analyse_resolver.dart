import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AnalyseResolver extends GetxController{
  late Box box;
  int maxTempInput = 90;
  int maxTemp = 100;
  double kWork = 10;
  int minVoltage = 1200;
  double dh = 7.5;
  double minSpeed = 50;
  @override
  onInit() async {
    box = await Hive.openBox('settings');
    getValues();
    super.onInit();
  }
  getValues(){
    maxTempInput = box.get('max_temp_input')??90;
    maxTemp = box.get('max_temp')??100;
    kWork = box.get('k_work')??10;
    minVoltage = box.get('min_vol')??1200;
    dh = box.get('max_dh')??7.5;
    minSpeed = box.get('min_hash')??50;
  }

  Color? getColor(String? type, dynamic value){
    Color? _;
    if(value !=null) {
      switch (type) {
        case 'temp_input':
          _ = value < maxTempInput ? null : Colors.red;
          break;
        case 'temp_max':
          _ = value < maxTemp ? null : Colors.red;
          break;
        case 'k_work':
          _ = value < kWork ? null : Colors.red;
          break;
        case 'min_vol':
          _ = value < minVoltage ? null : Colors.red;
          break;
        case 'null':
          _ = value > 0 ? null : Colors.red;
          break;
        case 'null_list':
          List<int?> _i = value;
          _ = _i.contains(0) ? Colors.red : null;
          break;
        case 'dh':
          _ = value < dh ? null : Colors.red;
          break;
        case 'min_speed_s': //TODO move to a separate function to vary models
        double _v = double.tryParse(value)??0;
          _ = _v > minSpeed ? null : Colors.red;
          break;
        case 'min_speed':
          _ = value>minSpeed? null : Colors.red;
          break;
        default:
          _ = null;
          break;
      }
    }
    return _;
  }
  bool hasErrors(String? type, dynamic value){
    bool _ = false;
    if(value !=null) {
      switch (type) {
        case 'temp_max':
         _ = value < maxTempInput;
         break;
        case 'null_list':
          List<int?> _i = value;
          _ = _i.contains(0);
          break;
        case 'dh':
          _ = value < dh;
          break;
        case 'min_speed':
          _ = value>minSpeed;
          break;
        default:
           _ = false;
      }
    }
    else{
      _ = false;
    }
    return _;
  }
}