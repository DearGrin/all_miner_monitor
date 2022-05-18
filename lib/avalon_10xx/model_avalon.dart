import 'package:avalon_tool/analyzator/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/avalon_10xx/chip_model.dart';
import 'package:avalon_tool/avalon_10xx/error_handler.dart';
import 'package:avalon_tool/avalon_10xx/regexp_parser.dart' as regexp;
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart'; // TODO remove

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
class AvalonData{
  String? rawData;
  String? version;
  int? elapsed;
  String? elapsedString;
  String? dna;
  String? workMode;
  List<int?>? netFail;
  int? tInput;
  List<int?>? fans;
  int? fanR;
  int? hashBoardCount;
  int? chipCount;
  int? tAvg;
  int? tMax;
  List<int?>? errors;
  List<int?>? tMaxByHashBoard;
  List<AvalonError>? ECMM;
  List<List<AvalonError>?>? ECHU;
  int? hw;
  double? dh;
  double? freq;
  double? currentSpeed;
  double? averageSpeed;
  List<int?>? ps;
  List<AvalonError>? psErrors;
  double? voltageMM;
  double? voltageOutput;
  int? powerHashBoards;
  double? requiredVoltage;
  int? consumption;
  String? psCommunication;
  List<Hashboard>? hashBoards;
  int? maxHashBoards;
  String? ip;
  int? ipInt;
  String? model;
  String? mm;
  String? manufacture;
  int? aging;
  String? status;
  int? aucN;
  int? led;
  List<Pool>? pools;
  bool isScrypt = false;

  bool? speedError;
  bool? fanError;
  bool? tempError;
  bool? chipCountError;
  bool? chipSError;
  bool? hashCountError;
  AvalonData({this.rawData, this.version, this.elapsed, this.elapsedString, this.dna, this.workMode, this.netFail,
    this.tInput, this.fans, this.fanR, this.hashBoardCount, this.chipCount,
    this.tAvg, this.tMax, this.tMaxByHashBoard, this.ECMM, this.ECHU, this.hw, this.dh,
    this.freq, this.currentSpeed, this.averageSpeed, this.ps, this.psErrors, this.voltageMM,
    this.voltageOutput, this.powerHashBoards, this.requiredVoltage, this.consumption,
    this.psCommunication, this.hashBoards, this.maxHashBoards, this.ip,
    this.model, this.mm, this.manufacture, this.aging, this.status='', this.aucN,
    this.ipInt, this.led, this.pools, this.errors, this.speedError, this.chipCountError, this.chipSError, this.fanError, this.hashCountError, this.tempError});
  factory AvalonData.fromString(String data, String ip, [int? _aucN]){
    String _company = 'Unknown';
    try {
     // _company = regexp.company.firstMatch(data)?.group(2) ?? '-';
      _company = 'Avalon';
    }
    catch(e){
      print(e);
    }
    String? _model = 'Unknown';
    try {
      _model = regexp.version.firstMatch(data)?.group(2)?.split('-')[0];
    }
    catch(e){
      print(e);
    }
    List<String> _octet = ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = 0;
    try {
      _ipInt = int.tryParse(_octet.join());
    }
    catch(e){
      print(e);
    }
   // String _elapsed = regexp.elapsed.firstMatch(data)?.group(2) ?? '-';
   // String _tempInput = regexp.tempInput.firstMatch(data)?.group(2) ?? '-';
    List<int?>? _netFail;
    try{
    _netFail = regexp.netFail.firstMatch(data)?.group(2)?.split(' ').map((e) =>
        int.tryParse(nullCheck(e))
    ).toList();
    }
    catch(e){
      print(e);
    }

    List<int?>? _fans;
    try{
        List<int?>? _f = regexp.fans.allMatches(data).map((e) =>
        int.tryParse(nullCheck(e.group(4)))
        ).toList();
        _fans = _f;
    }
    catch(e){
      print(e);
    }
    List<int?>? _tMaxByBoard;
    try {
      _tMaxByBoard = regexp.tMaxByBoard.firstMatch(data)?.group(2)?.
      split(' ').map((e) => getInt(e)).toList();
    }
    catch(e){
      print(e);
    }
   // String _fanR = regexp.fanR.firstMatch(data)?.group(2) ?? '-';
    List<int?>? _ps;
    try {
      _ps = regexp.ps.firstMatch(data)?.group(2)?.split(' ').map((
          e) => getInt(e)).toList();
    }
    catch(e){
      print(e);
    }
    int _maxHashBoards = 0; //TODO very scary
    try {
      _maxHashBoards = regexp.mw
          .allMatches(data)
          .length;
    }
    catch(e){
      print(e);
    }
    List<Hashboard>? _hashBoards = [];
    List<int?>? _rawEchu;
    try {
      _rawEchu = regexp.echu.firstMatch(data)?.group(2)
          ?.split(' ')
          .map((e) => getInt(e))
          .toList() ?? [];
    }
    catch(e){
      print(e);
    }
    List<List<AvalonError>?>? _echu;
    try {
      _echu = _rawEchu!.map((e) =>
          ErrorHandler().getErrors(e)
      ).toList();
    }
    catch(e){
      print(e);
    }
    int? _rawEcmm;
    try {
      _rawEcmm = getInt(regexp.ecmm.firstMatch(data)?.group(2));
    }
    catch(e){
      print(e);
    }
    List<AvalonError>? _ecmm;
    try {
      _ecmm = ErrorHandler().getErrors(_rawEcmm);
    }
    catch(e){
      print(e);
    }
    List<int?>? _errors;
    try{
      List<int?>? _ = _rawEchu;
      _?.insert(0, _rawEcmm);
      _errors = _;
    }
    catch(e){
      print(e);
    }
    for(int i = 0; i < _maxHashBoards; i++)
      {
        try {
          _hashBoards.add(Hashboard.fromString(i, data,));
        }
        catch(e){
          print(e);
        }
      }

    int _chipCount = 0;
    try {
      for (int i = 0; i < _hashBoards.length; i++) {
        for (int c = 0; c < _hashBoards[i].chips!.length; c++) {
          int _v = _hashBoards[i].chips?[c].voltage ?? -40;
          if (_v > 0) {
            _chipCount++;
          }
        }
      }
    }
    catch(e){
      print(e);
    }
    int? _tMax;
    try{
     _tMax =  getInt(regexp.tMax.firstMatch(data)?.group(2));
    }
    catch(e){
      print(e);
    }
    double? _currentSpeed;
    try{
      _currentSpeed =getDouble(regexp.currentSpeed.firstMatch(data)?.group(2))!/1000;
    }
    catch(e){
      print(e);
    }
    AnalyseResolver analyseResolver = Get.find();
    bool _speedError = analyseResolver.hasErrors('min_speed', _currentSpeed, _model);
    bool _tempError =  analyseResolver.hasErrors('temp_max', _tMax, _model);
    bool _fanError = analyseResolver.hasErrors('null_list', _fans, _model);
    List<int> _chipCountList = [];
    for(Hashboard board in _hashBoards){
      int _ = 0;
      _chipCountList.add(board.chips!.length); /// first value in avalon is max chip possible
      for(ChipModel chip in board.chips!){
        if(chip.voltage!=null && chip.voltage!>0)
          {
            _++;
          }
      }
      _chipCountList.add(_);
    }
    bool _chipCountError = analyseResolver.hasErrors('chip_count', _chipCountList, _model);
    bool _chipSError = false;
    bool _hashCountError = analyseResolver.hasErrors('hash_count', _maxHashBoards, _model);
    return AvalonData(
      version: regexp.version.firstMatch(data)?.group(2) ?? '-',
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      dna: regexp.dna.firstMatch(data)?.group(2) ?? '-',
      workMode: regexp.workMode.firstMatch(data)?.group(2) ?? '-',
      netFail: _netFail,
      tInput: getInt(regexp.tempInput.firstMatch(data)?.group(2)),
      fans: _fans,
      fanR: getInt(regexp.fanR.firstMatch(data)?.group(2)),
      hashBoardCount: getInt(regexp.hashBoardCount.firstMatch(data)?.group(2))??_hashBoards.length,
      chipCount: _chipCount,
      tAvg: getInt(regexp.tAvg.firstMatch(data)?.group(2))??getInt(regexp.tAverage.firstMatch(data)?.group(2)),
      tMax: _tMax,
      tMaxByHashBoard: _tMaxByBoard,
      ECMM: _ecmm,
      ECHU: _echu,
      hw: getInt(regexp.hw.firstMatch(data)?.group(2)),
      dh: getDouble(regexp.dh.firstMatch(data)?.group(2)),
      freq: getDouble(regexp.freq.firstMatch(data)?.group(2)),
     currentSpeed: _currentSpeed,
     averageSpeed: getDouble(regexp.averageSpeed.firstMatch(data)?.group(2))!=null?  getDouble(regexp.averageSpeed.firstMatch(data)?.group(2))!/1000: null,
      ps: _ps,
      psErrors: ErrorHandler().getPSErrors(_ps?[0]),
      voltageMM: _ps?[1] != null? _ps![1]!/100:0,
      voltageOutput: _ps?[2] != null? _ps![2]!/100:0,
      powerHashBoards: _ps?[3],
      requiredVoltage: _ps?[5] != null? _ps![5]!/100:0,
      consumption: _ps?[4],
      psCommunication: regexp.powerCommunication.firstMatch(data)?.group(2) ?? '-',
      maxHashBoards: _maxHashBoards,
      hashBoards: _hashBoards,
      ip: ip,
      ipInt: _ipInt,
      model: _model,
      mm: regexp.version.firstMatch(data)?.group(2)?.split('-')[1],
      manufacture: _company,
      aging: getInt(regexp.aging.firstMatch(data)?.group(2)),
      aucN: _aucN,
      led: getInt(regexp.led.firstMatch(data)?.group(2)),
      pools: [],
      rawData: data,
      errors: _errors,
      chipCountError: _chipCountError,
      fanError: _fanError,
      hashCountError: _hashCountError,
      speedError: _speedError,
      tempError: _tempError,
      chipSError: _chipSError,
    );
  }

}
class Hashboard{
  List<ChipModel>? chips = [];
  List<AvalonError>? errors = [];
  Hashboard({this.chips, this.errors});
  factory Hashboard.fromString(int index, String data){
    var _pvtT;
    var _pvtV;
    try {
      if (regexp.pvtT
          .allMatches(data)
          .isNotEmpty) {
        _pvtT = regexp.pvtT.allMatches(data).elementAt(index).group(2)?.split(
            ' ');
        _pvtT!.removeWhere((element) => element == '');
      }
    }
    catch(e){
      print(e);
    }
    try {
      if (regexp.pvtV
          .allMatches(data)
          .isNotEmpty) {
        _pvtV =
            regexp.pvtV.allMatches(data).elementAt(index).group(2)?.split(' ');
      }
    }
    catch(e){
      print(e);
    }
    List<String?>? _mw = [];
    try {
      _mw = regexp.mw.allMatches(data).elementAt(index).group(2)?.split(
          ' ');
    }
    catch(e){
      print(e);
    }
    List<String?>? _errors = [];
    try {
      _errors = regexp.echu.firstMatch(data)?.group(2)?.split(' ') ?? [];
    }
    catch(e){
      print(e);
    }
    List<AvalonError>? _er;
    try {
      List<AvalonError>? _er = ErrorHandler().getErrors(
          int.parse(nullCheck(_errors?[index])));
    }
    catch(e){
      print(e);
    }

   List<ChipModel> _tmp = [];

   for(int i = 0; i < _mw!.length; i++)
     {
       try {
         ChipModel _ = ChipModel(
             number: i + 1,
             temp: _pvtT == null ? null : int.tryParse(_pvtT[i]),
             voltage: _pvtV == null ? null : int.tryParse(_pvtV[i]),
             mw: int.tryParse(nullCheck(_mw[i]))
         );
         _tmp.add(_);
       }
       catch(e){
         print(e);
       }
     }
    return Hashboard(
      chips: _tmp,
      errors: _er,
    );
  }
}

class RaspberryAva extends AvalonData{
  List<AvalonData>? devices;
  String? version;
  int? elapsed;
  String? elapsedString;
  int? tInput;
  int? tMax;
  double? currentSpeed;
  String? ip;
  int? ipInt;
  String? model;
  String? mm;
  @override
  String? manufacture;
  String? status;
  bool isScrypt = false;
  double? averageSpeed;


  List<int?>? fans;
  List<int?>? errors;
  List<Pool>? pools;
  List<int?>? ps;
  List<int?>? netFail;


  //String? status;
  //List<int?>? fans;
  //List<int?>? ps;
// List<int?>? netFail;
  RaspberryAva({this.devices, this.version, this.elapsed, this.elapsedString,
    this.tInput, this.tMax, this.currentSpeed, this.ip, this.mm,
    this.model, this.manufacture, this.ipInt, this.fans, this.errors, this.pools,
  this.ps, this.netFail, this.averageSpeed, this.isScrypt = false, this.status});

  factory RaspberryAva.fromString(String data, String _ip) {
    List<RegExpMatch> _aucs = [];
    try {
      _aucs = regexp.aucs.allMatches(data).toList();
    }
    catch(e){
      print(e);
    }
    List<AvalonData> _tmp = [];
    int? _tempInput;
    int? _tMax;
    double _currentSpeed = 0;
    double _averageSpeed = 0.0;
    int _count = 0;
    List<String?> _models = [];
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
    for(int n = 0; n < _aucs.length; n++) {
      List<RegExpMatch> _auc = [];
      try {
        _auc = regexp.singleData.allMatches(
          _aucs[n].group(2) ?? '').toList();
    }
    catch(e){
        print(e);
    }
      //print(_aucs[1].group(2));
      for(int i =0; i < _auc.length; i++)
      {
     //   print(_auc[i].group(2));
        try {
          AvalonData _data = AvalonData.fromString(
              _auc[i].group(2) ?? '', '$_ip', n);
          _tmp.add(_data);
          if(_tempInput==null&&_data.tInput!=null || _tempInput!<_data.tInput!)
          {
            _tempInput = _data.tInput;
          }
          if(_tMax==null&&_data.tMax!=null || _tMax!<_data.tMax!)
          {
            _tMax = _data.tMax;
          }
          if(_data.currentSpeed!=null)
          {
            _currentSpeed += _data.currentSpeed!;
          }
          if(!_models.contains(_data.model))
          {
            _models.add(_data.model);
          }
        }
        catch(e){
          print(e);
        }

        try {
          for (var a in _tmp) {
            if (a.averageSpeed != null) {
              _averageSpeed += a.averageSpeed!;
              _count++;
            }
          }
        }
        catch(e){
          print(e);
        }
        _averageSpeed = _averageSpeed/_count;
      }
    }
    return RaspberryAva(
      devices: _tmp,
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      tInput: _tempInput,
      tMax: _tMax,
      currentSpeed: _currentSpeed,
      ip: _ip,
      manufacture: 'Avalon',
      model: _models.join(','),
      ipInt: _ipInt,
      errors: [],
      fans: [],
      ps: [],
      netFail: [],
      version: '',
      averageSpeed: _averageSpeed,
      status: '',
      isScrypt: false,
      );
  }
}
