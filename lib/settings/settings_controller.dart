import 'package:AllMinerMonitor/scan_list/resize_controller.dart';
import 'package:AllMinerMonitor/scan_list/table_header_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  RxDouble minHashDefault = 50.0.obs;
  RxDouble minHashL3 = 500.0.obs;
  RxDouble minHashS9 = 15.0.obs;
  RxDouble minHashS19 = 100.0.obs;
  RxDouble minHashT9 = 12.0.obs;
  RxDouble minHashT19 = 12.0.obs;
  RxDouble minHashS11 = 12.0.obs;
  RxDouble minHash1047 = 36.0.obs;
  RxDouble minHash1066 = 50.0.obs;
  RxDouble minHash11xx = 70.0.obs;
  RxDouble minHash12xx = 82.0.obs;
  RxDouble minHash9xx = 18.0.obs;
  RxDouble minHash8xx = 14.0.obs;
  RxDouble minHashM20 = 50.0.obs;
  RxDouble minHashM31 = 70.0.obs;
  RxDouble minHashM32 = 60.0.obs;
  RxInt raspCount = 5.obs;
  RxInt volReq = 1200.obs;
  RxDouble maxDh = 7.5.obs;
  RxDouble kWork = 10.0.obs;
  RxBool isAntVisible = false.obs;
  RxBool isAvalonVisible = false.obs;
  RxBool isWhatsminerVisible = false.obs;
  RxList<Map<dynamic, dynamic>> antPasswords = <Map<dynamic, dynamic>>[].obs;
  RxList<Map<String, String>> avalonPasswords = <Map<String, String>>[].obs;
  RxBool isObscured = true.obs;
  RxInt timeout = 10.obs;
  RxInt delay = 300.obs;
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
    int? _timeout =  box.get('timeout');
    if(_timeout==null)
    {
      box.put('timeout', 10);
    }
    else{
      timeout.value = _timeout;
    }
    int? _delay =  box.get('delay');
    if(_delay==null)
    {
      box.put('delay', 300);
    }
    else{
      delay.value=_delay;
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
    double? _minHashDefault = box.get('min_hash_default');
    if(_minHashDefault==null){
      box.put('min_hash_default', 50.0);
    }
    else{
      minHashDefault.value = _minHashDefault;
    }
    double? _minHashL3 = box.get('min_hash_L3');
    if(_minHashL3==null){
      box.put('min_hash_L3', 500.0);
    }
    else{
      minHashL3.value = _minHashL3;
    }
    double? _minHashS9 = box.get('min_hash_S9');
    if(_minHashS9==null){
      box.put('min_hash_S9', 15.0);
    }
    else{
      minHashS9.value = _minHashS9;
    }
    double? _minHashS19 = box.get('min_hash_S19');
    if(_minHashS19==null){
      box.put('min_hash_S19', 15.0);
    }
    else{
      minHashS19.value = _minHashS19;
    }
    double? _minHashT9 = box.get('min_hash_T9');
    if(_minHashT9==null){
      box.put('min_hash_T9', 15.0);
    }
    else{
      minHashT9.value = _minHashT9;
    }
    double? _minHashT19 = box.get('min_hash_T19');
    if(_minHashT19==null){
      box.put('min_hash_T19', 15.0);
    }
    else{
      minHashT19.value = _minHashT19;
    }
    double? _minHashS11 = box.get('min_hash_S11');
    if(_minHashS11==null){
      box.put('min_hash_S11', 15.0);
    }
    else{
      minHashS11.value = _minHashS11;
    }
    double? _minHash1047 = box.get('min_hash_1047');
    if(_minHash1047==null){
      box.put('min_hash_1047', 36.0);
    }
    else{
      minHash1047.value = _minHash1047;
    }
    double? _minHash1066 = box.get('min_hash_1066');
    if(_minHash1066==null){
      box.put('min_hash_1066', 50.0);
    }
    else{
      minHash1066.value = _minHash1066;
    }
    double? _minHash11xx = box.get('min_hash_11xx');
    if(_minHash11xx==null){
      box.put('min_hash_11xx', 70.0);
    }
    else{
      minHash11xx.value = _minHash11xx;
    }
    double? _minHash12xx = box.get('min_hash_12xx');
    if(_minHash12xx==null){
      box.put('min_hash_12xx', 82.0);
    }
    else{
      minHash12xx.value = _minHash12xx;
    }
    double? _minHash9xx = box.get('min_hash_9xx');
    if(_minHash9xx==null){
      box.put('min_hash_9xx', 18.0);
    }
    else{
      minHash9xx.value = _minHash9xx;
    }
    double? _minHash8xx = box.get('min_hash_8xx');
    if(_minHash8xx==null){
      box.put('min_hash_8xx', 14.0);
    }
    else{
      minHash8xx.value = _minHash8xx;
    }
    double? _minHashM20 = box.get('min_hash_m20');
    if(_minHashM20==null){
      box.put('min_hash_m20', 50.0);
    }
    else{
      minHashM20.value = _minHashM20;
    }
    double? _minHashM31 = box.get('min_hash_m31');
    if(_minHashM31==null){
      box.put('min_hash_m31', 70.0);
    }
    else{
      minHashM31.value = _minHashM31;
    }
    double? _minHashM32 = box.get('min_hash_m32');
    if(_minHashM32==null){
      box.put('min_hash_m32', 60.0);
    }
    else{
      minHashM32.value = _minHashM32;
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
  //  box.put('ant_passwords', [{'root':'root'},]);
    print(box.get('ant_passwords'));
  //  box.delete('ant_passwords');
    List<dynamic> _t = box.get('ant_passwords');
    List<Map<dynamic, dynamic>>? _antPasswords;
    //= box.get('ant_passwords');
    _antPasswords = _t.cast<Map>();
    if(_antPasswords.isEmpty)
      {
      box.put('ant_passwords', [{'root':'root'},]);
      antPasswords.add({'root':'root'});
      }
    else{
     // box.delete('ant_passwords');
      antPasswords.value = _antPasswords;
    }
    int? _raspCount = box.get('rasp_count');
    if(_raspCount==null){
      box.put('rasp_count', 5);
    }
    else{
      raspCount.value = _raspCount;
    }
   /*
    List<Map<String, String>>? _avalonPasswords = box.get('avalon_passwords');
    if(_avalonPasswords==null || _avalonPasswords.isEmpty)
    {
      box.put('avalon_passwords', {['root':'root'}]);
      avalonPasswords.add({'root':'root'});
    }
    else{
      avalonPasswords.value = _avalonPasswords;
    }


    */
    super.onInit();
  }
  onClick(int index){
    currentIndex.value = index;
  }
  setOctetCount(int value){
    octetCount.value =  value;
    box.put('octet_count', value);
  }
  setRaspCount(String value){
    int? _ = int.tryParse(value);
    if(_!=null){
      raspCount.value = _;
      box.put('rasp_count', _);
    }
  }
  setThreadsCount(String value){
    int? _ = int.tryParse(value);
    if(_!=null){

      threadsCount.value = _;
      box.put('max_threads', _);
    }
  }
  setTimeout(String value){
    int? _ = int.tryParse(value);
    if(_!=null){

      timeout.value = _;
      box.put('timeout', _);
    }
  }
  setDelay(String value){
    int? _ = int.tryParse(value);
    if(_!=null){

      delay.value = _;
      box.put('delay', _);
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
  setMinHash(String value, String type){
    double? _ = double.tryParse(value);
    if(_!=null){
     // minHash.value = _;
      box.put('min_hash_$type', _);
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
  showAntSettings(){
    isAntVisible.value = !isAntVisible.value;
  }
  showAvalonSettings(){
    isAvalonVisible.value = !isAvalonVisible.value;
  }
  showWhatsminerSettings(){
    isWhatsminerVisible.value = !isWhatsminerVisible.value;
  }
  addField(String type){
    switch(type){
      case 'antminer':
        Map<String,String>_ ={'':''};
        antPasswords.add(_);
        box.put('ant_passwords', antPasswords);
        break;
      case 'avalon':
        Map<String,String>_ ={'':''};
        avalonPasswords.add(_);
        box.put('avalon_passwords', avalonPasswords);
        break;
    }
  }
  deleteField(int index, String type){
    switch(type){
      case 'antminer':
        antPasswords.removeAt(index);
        box.put('ant_passwords', antPasswords);
        break;
    }
  }
  editLogin(String value, int index, String type){
    switch(type){
      case 'antminer':
        Map<String,String> _ = {value:antPasswords[index].entries.first.value};
        antPasswords.replaceRange(index, index+1, [_]);
        box.delete('ant_passwords');
        box.put('ant_passwords', antPasswords);
        break;
    }
  }
  editPassword(String value, int index, String type){
    switch(type){
      case 'antminer':
        antPasswords[index].values.toList()[0] = value;
        Map<String,String> _ = {antPasswords[index].entries.first.key:value};
        antPasswords.replaceRange(index, index+1, [_]);
        box.delete('ant_passwords');
        box.put('ant_passwords', antPasswords);
        break;
    }
  }
  showPasswords(){
    isObscured.value = !isObscured.value;
  }
  openLink(String url)async{
    final Uri _url = Uri.parse('url');
    if (!await launchUrlString(url)) throw 'Could not launch $url';
  }
}