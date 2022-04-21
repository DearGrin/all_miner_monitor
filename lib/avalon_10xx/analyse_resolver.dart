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
  double minSpeedDefault = 50;
  double minSpeedL3 = 500;
  double minSpeedS9 = 15;
  double minSpeedS19 = 100;
  double minSpeedT9 = 12;

  /// fixed values
  int hashCountL3 = 4;
  int hashCountS9 = 3;
  int hashCountS19 = 3;
  int hashCountT9 = 3;
  int chipCountL3 = 72;
  int chipCountS9 = 63;
  int chipCountS19 = 96;
  int chipCountT9 = 54;
  @override
  onInit() async {
    box = await Hive.openBox('settings');
    getValues();
    box.watch().listen((event) {handleChange(event);
    });
    super.onInit();
  }
  handleChange(BoxEvent event){
    try {
      switch (event.key) {
        case 'max_temp_input':
          maxTempInput = event.value;
          break;
        case 'max_temp':
          maxTemp = event.value;
          break;
        case 'k_work':
          kWork = event.value;
          break;
        case 'min_vol':
          minVoltage = event.value;
          break;
        case 'max_dh':
          dh = event.value;
          break;
        case 'min_hash_default':
          minSpeedDefault = event.value;
          break;
        case 'min_hash_L3':
          minSpeedL3 = event.value;
          break;
        case 'min_hash_S9':
          minSpeedS9 = event.value;
          break;
        case 'min_hash_S19':
          minSpeedS19 = event.value;
          break;
        case 'min_hash_T9':
          minSpeedT9 = event.value;
          break;
        default:
      }
    }
    catch(e){
      print(e);
    }
  }
  getValues(){
    maxTempInput = box.get('max_temp_input')??90;
    maxTemp = box.get('max_temp')??100;
    kWork = box.get('k_work')??10;
    minVoltage = box.get('min_vol')??1200;
    dh = box.get('max_dh')??7.5;
    minSpeedDefault = box.get('min_hash_default')??50;
    minSpeedL3 = box.get('min_hash_L3')??500;
    minSpeedS9 = box.get('min_hash_S9')??15;
    minSpeedS19 = box.get('min_hash_S19')??100;
    minSpeedT9 = box.get('min_hash_T9')??12;
  }

  Color? getColor(String? type, dynamic value, [String? model]){
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
          _ = _v > minSpeedDefault ? null : Colors.red; //TODO get rid of
          break;
        case 'hash_count':
          switch(model){
            case 'L3':
             _ = value<hashCountL3? Colors.red:null;
              break;
            case 'S9':
              _ = value<hashCountS9? Colors.red:null;
              break;
            case 'S19':
              _ = value<hashCountS19? Colors.red:null;
              break;
            case 'T9':
              _ = value<hashCountT9? Colors.red:null;
              break;
            default:
              _ = Colors.red;
          }
          break;
        case 'chip_count':
          switch(model){
            case 'L3':
              _ = value<chipCountL3? Colors.red:null;
              break;
            case 'S9':
              _ = value<chipCountS9? Colors.red:null;
              break;
            case 'S19':
              _ = value<chipCountS19? Colors.red:null;
              break;
            case 'T9':
              _ = value<chipCountT9? Colors.red:null;
              break;
            default:
              _ = Colors.red;
          }
          break;

        case 'min_speed':
          switch(model){
            case 'L3':
              _ = value>minSpeedL3? null : Colors.red;
              break;
            case 'S9':
              _ = value>minSpeedS9? null : Colors.red;
              break;
            case 'S19':
              _ = value>minSpeedS19? null : Colors.red;
              break;
            case 'T9':
              _ = value>minSpeedT9? null : Colors.red;
              break;
            default:
              _ = value>minSpeedDefault? null : Colors.red;
          }
          break;
        default:
          _ = null;
      }
    }
    return _;
  }
  bool hasErrors(String? type, dynamic value, [String? model]){
    bool _ = false;
    if(value !=null) {
      switch (type) {
        case 'acn_s':
          List<String?>? chainString = value;
          if(chainString!=null) {
            for (String? s in chainString) {
              if (s != null && s.contains('x') || s == null) {
                _ = true;
                break;
              }
            }
          }
          break;
        case 'temp_max':
         _ = value > maxTempInput;
         break;
        case 'null_list':
          List<int?> _i = value;
          _ = _i.contains(0);
          break;
        case 'dh':
          _ = value < dh;
          break;
        case 'min_speed':
          switch(model){
            case 'L3':
              _ = value<minSpeedL3;
              break;
            case 'S9':
              _ = value<minSpeedS9;
              break;
            case 'S19':
              _ = value<minSpeedS19;
              break;
            case 'T9':
              _ = value<minSpeedT9;
              break;
            default:
              _ = value<minSpeedDefault;
          }
          break;
        case 'hash_count':
          switch(model){
            case 'L3':
              _ = value<hashCountL3;
              break;
            case 'S9':
              _ = value<hashCountS9;
              break;
            case 'S19':
              _ = value<hashCountS19;
              break;
            case 'T9':
              _ = value<hashCountT9;
              break;
            default:
              _ = true;
          }
          break;
        case 'chip_count':
          List<int?>? chipPerChain = value;
          int _minChip = 0;
          if(chipPerChain!=null){
            for(int? c in chipPerChain){
              if(c!=null && c < _minChip || c!=null&& _minChip==0){
                _minChip = c;
              }
            }
          }
          switch(model){
            case 'L3':
              _ = _minChip<chipCountL3;
              break;
            case 'S9':
              _ = _minChip<chipCountS9;
              break;
            case 'S19':
              _ = _minChip<chipCountS19;
              break;
            case 'T9':
              _ = _minChip<chipCountT9;
              break;
            default:
              _ = true;
          }
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