import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../debugger/debug_print.dart';

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
  double minSpeedT19 = 12;
  double minSpeedS11 = 12;
  double minSpeed1047 = 36;
  double minSpeed1066 = 50;
  double minSpeed11xx = 70;
  double minSpeed12xx = 82;
  double minSpeed9xx = 18;
  double minSpeed8xx = 14;

  /// fixed values
  int hashCountL3 = 4;
  int hashCountS9 = 3;
  int hashCountS19 = 3;
  int hashCountT9 = 3;
  int hashCountT19 = 3; //TODO fix value
  int hashCountS11 = 3;
  int chipCountL3 = 72;
  int chipCountS9 = 63;
  int chipCountS19 = 96;
  int chipCountT9 = 54;
  int chipCountT19 = 54; //TODO fix value
  int chipCountS11 = 84;
  int hashCount8xx = 4;
  int hashCount9xx = 6;
  int hashCount1047 = 2;
  int hashCountAvalon = 3;
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
        case 'min_hash_T19':
          minSpeedT19 = event.value;
          break;
        case 'min_hash_S11':
          minSpeedS11 = event.value;
          break;
        case 'min_hash_1047':
          minSpeed1047 = event.value;
          break;
        case 'min_hash_1066':
          minSpeed1066 = event.value;
          break;
        case 'min_hash_11xx':
          minSpeed11xx = event.value;
          break;
        case 'min_hash_12xx':
          minSpeed12xx = event.value;
          break;
        case 'min_hash_9xx':
          minSpeed9xx = event.value;
          break;
        case 'min_hash_8xx':
          minSpeed8xx = event.value;
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
    minSpeedT19 = box.get('min_hash_T19')??12;
    minSpeedS11 = box.get('min_hash_S11')??12;
    minSpeed1047 = box.get('min_hash_1047')??36;
    minSpeed1066 = box.get('min_hash_1066')??50;
    minSpeed11xx = box.get('min_hash_11xx')??70;
    minSpeed12xx = box.get('min_hash_12xx')??82;
    minSpeed9xx = box.get('min_hash_9xx')??18;
    minSpeed8xx = box.get('min_hash_8xx')??14;
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
          String? _model = model;
          if(model!='L3'||model!='S9'||model!='S19'||model!='T9'||model!='T19'||model!='S11'){
            if(model!.startsWith('9')){
              _model = '9xx';
            }
            else if(model.startsWith('8')){
              _model = '8xx';
            }
            else if(model.startsWith('11')){
              _model = '11xx';
            }
            else if(model.startsWith('12')){
              _model = '12xx';
            }
            else if(model.startsWith('1066')){
              _model = '1066';
            }
            else{
              _model = '1047';
            }
          }
          switch(_model){
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
            case 'T19':
              _ = value<hashCountT19? Colors.red:null;
              break;
            case 'S11':
              _ = value<hashCountS11? Colors.red:null;
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
            case 'T19':
              _ = value<chipCountT19? Colors.red:null;
              break;
            case 'S11':
              _ = value<chipCountS11? Colors.red:null;
              break;
            default:
              _ = Colors.red;
          }
          break;

        case 'min_speed':
          String? _model = model;
          if(model!='L3'&&model!='S9'&&model!='S19'&&model!='T9'&&model!='T19'&&model!='S11'){
            if(model!.startsWith('9')){
              _model = '9xx';
            }
            else if(model.startsWith('8')){
              _model = '8xx';
            }
            else if(model.startsWith('11')){
              _model = '11xx';
            }
            else if(model.startsWith('12')){
              _model = '12xx';
            }
            else if(model.startsWith('1066')){
              _model = '1066';
            }
            else{
              _model = '1047';
            }
          }
          switch(_model){
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
            case 'T19':
              _ = value>minSpeedT19? null : Colors.red;
              break;
            case 'S11':
              _ = value>minSpeedS11? null : Colors.red;
              break;
            case '1047':
              _ = value>minSpeed1047? null : Colors.red;
              break;
            case '1066':
              _ = value>minSpeed1066? null : Colors.red;
              break;
            case '11xx':
              _ = value>minSpeed11xx? null : Colors.red;
              break;
            case '12xx':
              _ = value>minSpeed12xx? null : Colors.red;
              break;
            case '9xx':
              _ = value>minSpeed9xx? null : Colors.red;
              break;
            case '8xx':
              _ = value>minSpeed8xx? null : Colors.red;
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
  Future<bool> hasErrors(String? type, dynamic value, [String? model]) async{
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
          String? _model = model;
          if(model!='L3'||model!='S9'||model!='S19'||model!='T9'||model!='T19'||model!='S11'){
            if(model!.startsWith('9')){
              _model = '9xx';
            }
            else if(model.startsWith('8')){
              _model = '8xx';
            }
            else if(model.startsWith('11')){
              _model = '11xx';
            }
            else if(model.startsWith('12')){
              _model = '12xx';
            }
            else if(model.startsWith('1066')){
              _model = '1066';
            }
            else{
              _model = '1047';
            }
          }
          switch(_model){
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
            case 'T19':
              _ = value<minSpeedT19;
              break;
            case 'S11':
              _ = value<minSpeedS11;
              break;
            case '1047':
              _ = value<minSpeed1047;
              break;
            case '1066':
              _ = value<minSpeed1066;
              break;
            case '11xx':
              _ = value<minSpeed11xx;
              break;
            case '12xx':
              _ = value<minSpeed12xx;
              break;
            case '9xx':
              _ = value<minSpeed9xx;
              break;
            case '8xx':
              _ = value<minSpeed8xx;
              break;
            default:
              _ = value<minSpeedDefault;
          }
          break;
        case 'hash_count':
          String? _model = model;
          if(model!='L3'||model!='S9'||model!='S19'||model!='T9'||model!='T19'||model!='S11'){
            if(model!.startsWith('9')){
              _model = '9xx';
            }
            else if(model.startsWith('8')){
              _model = '8xx';
            }
            else if(model.startsWith('11')){
              _model = '11xx';
            }
            else if(model.startsWith('12')){
              _model = '12xx';
            }
            else if(model.startsWith('1066')){
              _model = '1066';
            }
            else{
              _model = '1047';
            }
          }
          switch(_model){
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
            case 'T19':
              _ = value<hashCountT19;
              break;
            case 'S11':
              _ = value<hashCountS11;
              break;
            case '1047':
              _ = value<hashCount1047;
              break;
            case '1066':
              _ = value<hashCountAvalon;
              break;
            case  '11xx':
              _ = value<hashCountAvalon;
              break;
            case '12xx':
              _ = value<hashCountAvalon;
              break;
            case '9xx':
              _ = value<hashCount9xx;
              break;
            case '8xx':
              _ = value<hashCount8xx;
              break;
            default:
              _ = true;
          }
          break;
        case 'chip_count':
          debug(subject: 'analyse resolver', message: 'value: $value', function: 'chip count');
          List<int?>? chipPerChain = value;
          int? _minChip;
          if(chipPerChain!=null){
            for(int? c in chipPerChain){
              if(_minChip==null)
                {
                  _minChip = c;
                }
              else{
                if(c!=null &&_minChip>c){
                  _minChip = c;
                }
              }
            }
          }
          if(_minChip!=null){
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
              case 'T19':
                _ = _minChip<chipCountT19;
                break;
              case 'S11':
                _ = _minChip<chipCountS11;
                break;
              default:
                try {
                  int _maxChip = 0;
                  if (chipPerChain != null && chipPerChain.length > 1) {
                    _maxChip = chipPerChain[0] ?? 0;
                  }
                  _ = _minChip < _maxChip;
                }
                catch(e){
                  _ = true;
                }
                break;
            }
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