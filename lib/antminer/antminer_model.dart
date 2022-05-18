import 'package:avalon_tool/analyzator/analyse_resolver.dart';
import 'package:avalon_tool/antminer/antminer_regexp.dart' as regexp;
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

String nullCheck(String? data){return data ?? '-';}
int? getInt(String? data){
  String _ = data??'-';
  return int.tryParse(_);
}
double? getDouble(String? data){
  String _ = data ?? '-';
  return double.tryParse(_);
}
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
class AntMinerModel{
  ///general data
  String? status;
  String? ip;
  int? ipInt;
  String? manufacture;
  String? model;
  bool? isScrypt;
  int? elapsed;
  String? elapsedString;
  double? currentSpeed;
  double? averageSpeed;
  int? tMax;
  int? tInput;
  String? mm;
  List<int?>? fans;
  List<int?>? errors;
  List<Pool>? pools;
  String? rawData;
  List<dynamic>? ps;
  List<int?>? netFail;
  ///manufacture specific data
  int? frequency;
  List<int?>? freqs;
  List<dynamic>? volt;
  List<int?>? watt;
  int? hashCount;
  int? fanNum;
  int? tempCount;
  List<int?>? tChipI;
  List<int?>? tChipO;
  List<int?>? tPcbI;
  List<int?>? tPcbO;
  List<int?>? chipPerChain;
  List<String?>? chainString;
  List<int?>? hwPerChain;
  List<double?>? ratePerChain;

  bool? speedError;
  bool? fanError;
  bool? tempError;
  bool? chipCountError;
  bool? chipsSError;
  bool? hashCountError;

  AntMinerModel({this.rawData, this.model, this.elapsed, this.currentSpeed, this.averageSpeed, this.frequency,
    this.freqs, this.fans, this.tMax, this.tChipO, this.tChipI, this.tPcbO, this.tPcbI,
    this.hashCount, this.volt, this.watt, this.chipPerChain, this.chainString,
    this.fanNum, this.hwPerChain, this.ratePerChain, this.tempCount, this.ip,
    this.ipInt, this.manufacture, this.status='', this.mm, this.elapsedString,
    this.pools, this.isScrypt, this.tInput, this.errors, this.ps, this.netFail,
    this.speedError, this.chipCountError, this.chipsSError, this.fanError, this.hashCountError, this.tempError});

  factory AntMinerModel.fromString(String data, String _ip){
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
   String _mm = '';
   try{
    _mm = regexp.mm.firstMatch(data)?.group(2)??'';
   }
   catch(e){
     print(e);
   }
    String _model = 'Unknown';
   bool _isScrypt = false;
    if(_mm.contains('L3')){
      _model = 'L3';
      _isScrypt = true;
    }
    else if (_mm.contains('S9')){
      _model = 'S9';
    }
    else if (_mm.contains('S19')){
      _model = 'S19';
    }
    else if (_mm.contains('T9')){
      _model = 'T9';
    }
    List<int?>? _freqs;
    try {
      _freqs = regexp.freqs.allMatches(data).map((e) =>
          int.tryParse(nullCheck(e.group(2)))).toList();
     if(_freqs.isEmpty){
       _freqs = regexp.freqsAvg.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))?.toInt()).toList();
     }
      if(_model=='S9'||_model=='T9'){
        _freqs = _freqs.skip(5).take(3).toList();
      }
    }
    catch(e){
      print(e);
    }
    List<dynamic>? _volt = [];
    try {
      var _ = regexp.volt.allMatches(data);
      for(var m in _){
        if(m.group(2)=='lowest'){
          _volt.add('lowest');
        }
        else{
          _volt.add(int.tryParse(nullCheck(m.group(2))));
        }
      }
    }
    catch(e){
      print(e);
    }
    List<int?>? _watt;
    try {
      _watt = regexp.watt.allMatches(data).map((e) =>
          int.tryParse(nullCheck(e.group(2)))).toList();
    }
    catch(e){
      print(e);
    }
    List<int?>? _fans;
    try{
    _fans = regexp.fans.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    if(_model=='S9'||_model=='T9'){
      _fans = _fans.skip(4).take(2).toList();
    }
    }
    catch(e){
      print(e);
    }
    List<int?>? _tChipI;
    try{
    _tChipI = regexp.tChipsI.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))?.toInt()).toList();
    }
    catch(e){
      print(e);
    }
    List<int?>? _tChipO;
    try{
    _tChipO = regexp.tChipsO.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))?.toInt()).toList();
    if(_model=='S9'||_model=='T9'){
      _tChipO = _tChipO.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    List<int?>? _tPcbI;
    try{
    _tPcbI =  regexp.tPcbI.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))?.toInt()).toList();
    if(_model=='S9'||_model=='T9'){
      _tPcbI = _tPcbI.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    List<int?>? _tPcbO;
    try{
    _tPcbO =  regexp.tPcbO.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))?.toInt()).toList();
    if(_model=='S9'||_model=='T9'){
      _tPcbO = _tPcbO.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    int? _tMax;
    try{
      for(int? temp in _tChipO!){
        if(_tMax==null&&temp!=null){
          _tMax = temp;
        }
        else if(temp!=null&&_tMax!=null&&_tMax<temp){
          _tMax = temp;
        }
      }
    }
    catch(e){
      print(e);
    }
    List<int?>? _hw;
    try{
    _hw = regexp.hw.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    if(_model=='S9'||_model=='T9'){
      _hw = _hw.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    List<double?>? _rate;
    try{
    _rate = regexp.chain_rate.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))).toList();
    }
    catch(e){
      print(e);
    }
    List<String?>? _chipString;
    try{
    _chipString = regexp.chain_acs.allMatches(data).map((e) => e.group(2)).toList();
    if(_model=='S9'||_model=='T9'){
      _chipString = _chipString.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    List<int?>? _chips;
    try{
    _chips = regexp.chain_acn.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    if(_model=='S9'||_model=='T9'){
      _chips = _chips.skip(5).take(3).toList();
    }
    }
    catch(e){
      print(e);
    }
    double? _currentSpeed;
    try{
      _currentSpeed = _model=='L3'? getDouble(regexp.currentSpeed.firstMatch(data)?.group(2)): getDouble(regexp.currentSpeed.firstMatch(data)?.group(2))!/1000;
    }
    catch(e){
      print(e);
    }
    AnalyseResolver analyseResolver = Get.find();
    bool _speedError = analyseResolver.hasErrors('min_speed', _currentSpeed, _model);
    bool _tempError =  analyseResolver.hasErrors('temp_max', _tMax, _model);
    bool _fanError = analyseResolver.hasErrors('null_list', _fans, _model);
    bool _chipCountError = analyseResolver.hasErrors('chip_count', _chips, _model);
    bool chipsSError = analyseResolver.hasErrors('acn_s', _chipString, _model);
    bool _hashCountError = analyseResolver.hasErrors('hash_count', null, _model);
    return AntMinerModel(
      speedError: _speedError,
      fanError: _fanError,
      tempError: _tempError,
      chipCountError: _chipCountError,
      chipsSError: chipsSError,
      hashCountError: _hashCountError,
      ip: _ip,
      ipInt: _ipInt,
      manufacture: 'Antminer',
      model: _model,
      mm: _mm,
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      currentSpeed: _currentSpeed,
      averageSpeed: _model=='L3'? getDouble(regexp.averageSpeed.firstMatch(data)?.group(2)): getDouble(regexp.averageSpeed.firstMatch(data)?.group(2))!/1000,
      frequency: getInt(regexp.frequency.firstMatch(data)?.group(2)),
      freqs: _freqs,
      volt: _volt,
      watt: _watt,
      tempCount: getInt(regexp.temp_num.firstMatch(data)?.group(2)),
      tChipI: _tChipI,
      tChipO: _tChipO,
      tPcbI: _tPcbI,
      tPcbO: _tPcbO,
      tMax: _tMax,
      fanNum: getInt(regexp.fan_num.firstMatch(data)?.group(2)),
      fans: _fans,
      hashCount: getInt(regexp.miner_count.firstMatch(data)?.group(2)),
      chipPerChain: _chips,
      chainString: _chipString,
      hwPerChain: _hw,
      ratePerChain: _rate,
      isScrypt: _isScrypt,
      pools: [],
      rawData: data,
      ps: _volt,
    );
  }
}