import 'package:avalon_tool/scan_list/header_defaults.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/scan_list/table_header_model.dart';
import 'package:avalon_tool/settings/header_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsController extends GetxController{
  RxInt currentIndex = 0.obs;
  RxInt octetCount = 1.obs;
  RxInt threadsCount = 20.obs;
  List<TableHeaderModel> headers = [];
  List<bool> isVisibleHeader = <bool>[].obs;
  RxBool isDarkMode = true.obs;
  RxString language = 'english'.obs;
  RxInt maxTemp = 100.obs;
  RxInt maxTempInput = 90.obs;
  RxDouble minHash = 50.0.obs;
  RxInt volReq = 1200.obs;
  RxDouble maxDh = 7.5.obs;
  RxDouble kWork = 10.0.obs;

  late Box box;
  //final ScanListController scanListController = Get.put(ScanListController());
  final ResizeController resizeController = Get.put(ResizeController());
  //TODO add hive interaction
  @override
  onInit() async {
    box = await Hive.openBox('settings');
    ///get headers
    List<dynamic>? _tmp = box.get('headers');
    List<TableHeaderModel> _ =  _tmp!.cast<TableHeaderModel>();
    for(int i =0; i < _tmp.length; i++){
      headers.add(_[i]);
      isVisibleHeader.add(_[i].isVisible??true);
    }
    update(['headers_settings']);
    ///get batch
    int? _threads =  box.get('max_threads');
    if(_threads==null)
      {
        box.put('max_threads', 20);
      }
    else{
      threadsCount.value=_threads;
    }
    int? _octetCount = box.get('octet_count');
    if(_octetCount==null){
      box.put('octet_count', 1);
    }
    else{
      octetCount.value = _octetCount;
    }
    ///other settings
    bool? _darkMode = box.get('dark_mode');
    if(_darkMode == null){
      box.put('dark_mode', true);
    }
    else{
      isDarkMode.value = _darkMode;
    }
    String? _language = box.get('language');
    if(_language==null){
      box.put('language', 'english');
    }
    else{
      language.value = _language;
    }
    ///warnings settings
    int? _maxTemp = box.get('max_temp');
    if(_maxTemp==null){
        box.put('max_temp', 100);
      }
    else{
      maxTemp.value = _maxTemp;
    }
    int? _maxTempInput = box.get('max_temp_input');
    if(_maxTempInput==null){
      box.put('max_temp_input', 90);
    }
    else{
      maxTempInput.value = _maxTempInput;
    }
    double? _minHash = box.get('min_hash');
    if(_minHash==null){
      box.put('min_hash', 50.0);
    }
    else{
      minHash.value = _minHash;
    }
    int? _volReq = box.get('min_vol');
    if(_volReq==null){
      box.put('min_vol', 100);
    }
    else{
      volReq.value = _volReq;
    }
    double? _maxDh = box.get('max_dh');
    if(_maxDh==null){
      box.put('max_dh', 7.5);
    }
    else{
      maxDh.value = _maxDh;
    }
    double? _kWork = box.get('k_work');
    if(_kWork==null){
      box.put('k_work', 7.5);
    }
    else{
      kWork.value = _kWork;
    }
    super.onInit();
  }
  onClick(int index){
    currentIndex.value = index;
  }
  setOctetCount(int value){
    octetCount.value =  value;
    box.put('octet_count', value);
  }
  setThreadsCount(String value){
    int? _ = int.tryParse(value);
    if(_!=null){

      threadsCount.value = _;
      box.put('max_threads', _);
    }
  }
  setVisibility(int index, bool value){
    headers[index].isVisible = value;
    isVisibleHeader[index] = value;
    box.put('headers', headers);
    resizeController.updateHeaders(headers, index);
  }
  setDarkMode(bool value){
    isDarkMode.value = value;
    box.put('dark_mode', value);
    Get.changeThemeMode(value? ThemeMode.dark : ThemeMode.light);
  }
  changeLanguage(String? value){
    language.value = value!;
    box.put('language', value);
    Get.updateLocale(value=='english'?
      const Locale('en','Us') : const Locale('ru','RU'));
  }
  setMaxTemp(String value){
    int? _ = int.tryParse(value);
    if(_!=null){
      maxTemp.value = _;
      box.put('max_temp', _);
    }
  }
  setMaxTempInput(String value){
    int? _ = int.tryParse(value);
    if(_!=null){
      maxTempInput.value = _;
      box.put('max_temp_input', _);
    }
  }
  setMinHash(String value){
    double? _ = double.tryParse(value);
    if(_!=null){
      minHash.value = _;
      box.put('min_hash', _);
    }
  }
  setMinVol(String value){
    int? _ = int.tryParse(value);
    if(_!=null){
      volReq.value = _;
      box.put('min_vol', _);
    }
  }
  setMaxDh(String value){
    double? _ = double.tryParse(value);
    if(_!=null){
      maxDh.value = _;
      box.put('max_dh', _);
    }
  }
  setKWork(String value){
    double? _ = double.tryParse(value);
    if(_!=null){
      kWork.value = _;
      box.put('k_work', _);
    }
  }
}