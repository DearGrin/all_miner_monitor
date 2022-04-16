import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/avalon_10xx/chip_model.dart';
import 'package:avalon_tool/avalon_10xx/error_handler.dart';
import 'package:avalon_tool/avalon_10xx/regexp_parser.dart' as regexp;
import 'package:avalon_tool/pools_editor/pool_model.dart';
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
/*
class AvalonModel{
  General? general;
  Hashboards? hashboards;
  Speed? speed;
  PowerSupply? powerSupply;
  Extras? extras;
  List<Hashboard>? hashboard = [];
  AvalonModel({this.general, this.hashboards, this.speed, this.powerSupply, this.extras, this.hashboard});
  factory AvalonModel.fromData(AvalonData data){
    return AvalonModel(

    );
  }
}

 */

class AvalonData{
  String? version;
  int? elapsed;
  String? elapsedString;
  String? dna;
  String? workMode;
  List<int?>? netFail;
  int? tempInput;
  List<int?>? fans;
  int? fanR;
  int? hashBoardCount;
  int? chipCount;
  int? tAvg;
  int? tMax;
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
  String? company;
  int? aging;
  String? status;
  int? aucN;
  int? led;
  List<Pool>? pools;
  AvalonData({this.version, this.elapsed, this.elapsedString, this.dna, this.workMode, this.netFail,
    this.tempInput, this.fans, this.fanR, this.hashBoardCount, this.chipCount,
    this.tAvg, this.tMax, this.tMaxByHashBoard, this.ECMM, this.ECHU, this.hw, this.dh,
    this.freq, this.currentSpeed, this.averageSpeed, this.ps, this.psErrors, this.voltageMM,
    this.voltageOutput, this.powerHashBoards, this.requiredVoltage, this.consumption,
    this.psCommunication, this.hashBoards, this.maxHashBoards, this.ip,
    this.model, this.mm, this.company, this.aging, this.status='', this.aucN,
    this.ipInt, this.led, this.pools});
  factory AvalonData.fromString(String data, String ip, [int? _aucN]){
    String _company = regexp.company.firstMatch(data)?.group(2) ?? '-';
    String? _model = regexp.version.firstMatch(data)?.group(2)?.split('-')[0];
    List<String> _octet = ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
   // String _elapsed = regexp.elapsed.firstMatch(data)?.group(2) ?? '-';
   // String _tempInput = regexp.tempInput.firstMatch(data)?.group(2) ?? '-';
    List<int?>? _netFail = regexp.netFail.firstMatch(data)?.group(2)?.split(' ').map((e) =>
        int.tryParse(nullCheck(e))
    ).toList();
    List<int?>? _fans;
    if(_model!.startsWith('1')) //TODO is it needed?
      {
        List<int?>? _f = regexp.fans.allMatches(data).map((e) =>
        int.tryParse(nullCheck(e.group(4)))
        ).toList();
        _fans = _f;
      }
    else{
      List<int?>? _f = regexp.fans.allMatches(data).map((e) =>
      int.tryParse(nullCheck(e.group(4)))
      ).toList();
      _fans = _f;
    }
    List<int?>? _tMaxByBoard = regexp.tMaxByBoard.firstMatch(data)?.group(2)?.
        split(' ').map((e) => getInt(e)).toList();
   // String _fanR = regexp.fanR.firstMatch(data)?.group(2) ?? '-';
    List<int?>? _ps = regexp.ps.firstMatch(data)?.group(2)?.split(' ').map((e) => getInt(e)).toList();
    int _maxHashBoards = regexp.mw.allMatches(data).length;
    List<Hashboard>? _hashBoards = [];
    List<int?> _rawEchu = regexp.echu.firstMatch(data)?.group(2)?.split(' ').map((e) => getInt(e)).toList()??[];
    List<List<AvalonError>?> _echu = _rawEchu.map((e) =>
      ErrorHandler().getErrors(e)
      ).toList();

    for(int i = 0; i < _maxHashBoards; i++)
      {
        _hashBoards.add(Hashboard.fromString(i, data,));
      }
    int _chipCount = 0;
    for(int i = 0; i < _hashBoards.length; i++)
      {
        for(int c = 0; c <_hashBoards[i].chips!.length; c++){
          int _v = _hashBoards[i].chips?[c].voltage ?? -40;
          if(_v > 0){_chipCount++;}
        }
      }
    return AvalonData(
      version: regexp.version.firstMatch(data)?.group(2) ?? '-',
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      dna: regexp.dna.firstMatch(data)?.group(2) ?? '-',
      workMode: regexp.workMode.firstMatch(data)?.group(2) ?? '-',
      netFail: _netFail,
      tempInput: getInt(regexp.tempInput.firstMatch(data)?.group(2)),
      fans: _fans,
      fanR: getInt(regexp.fanR.firstMatch(data)?.group(2)),
      hashBoardCount: getInt(regexp.hashBoardCount.firstMatch(data)?.group(2))??_hashBoards.length,
      chipCount: _chipCount,
      tAvg: getInt(regexp.tAvg.firstMatch(data)?.group(2))??getInt(regexp.tAverage.firstMatch(data)?.group(2)),
      tMax: getInt(regexp.tMax.firstMatch(data)?.group(2)),
      tMaxByHashBoard: _tMaxByBoard,
      ECMM: ErrorHandler().getErrors(getInt(regexp.ecmm.firstMatch(data)?.group(2))),
      ECHU: _echu,
      hw: getInt(regexp.hw.firstMatch(data)?.group(2)),
      dh: getDouble(regexp.dh.firstMatch(data)?.group(2)),
      freq: getDouble(regexp.freq.firstMatch(data)?.group(2)),
     currentSpeed: getDouble(regexp.currentSpeed.firstMatch(data)?.group(2))!/1000,
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
      model: regexp.version.firstMatch(data)?.group(2)?.split('-')[0],
      mm: regexp.version.firstMatch(data)?.group(2)?.split('-')[1],
      company: _company.contains('AVA')? 'Avalon': 'unknown',
      aging: getInt(regexp.aging.firstMatch(data)?.group(2)),
      aucN: _aucN,
      led: getInt(regexp.led.firstMatch(data)?.group(2)),
      pools: [],
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
    if(regexp.pvtT.allMatches(data).isNotEmpty) {
      _pvtT = regexp.pvtT.allMatches(data).elementAt(index).group(2)?.split(
          ' ');
       _pvtT!.removeWhere((element) => element=='');
    }
    if(regexp.pvtV.allMatches(data).isNotEmpty) {
      _pvtV = regexp.pvtV.allMatches(data).elementAt(index).group(2)?.split(' ');
    }
   final _mw = regexp.mw.allMatches(data).elementAt(index).group(2)?.split(' ');
   final _errors = regexp.echu.firstMatch(data)?.group(2)?.split(' ')  ?? [];
   List<AvalonError>? _er = ErrorHandler().getErrors(int.parse(_errors[index]));
   List<ChipModel> _tmp = [];
   for(int i = 0; i < _mw!.length; i++)
     {
       ChipModel _ = ChipModel(
           number: i+1,
           temp: _pvtT==null? null : int.tryParse(_pvtT[i]),
           voltage: _pvtV==null? null : int.tryParse(_pvtV[i]),
           mw: int.tryParse(_mw![i])
       );
       _tmp.add(_);
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
  int? tempInput;
  int? tMax;
  double? currentSpeed;
  String? ip;
  int? ipInt;
  String? model;
  String? mm;
  @override
  String? company;
  //String? status;
  //List<int?>? fans;
  //List<int?>? ps;
// List<int?>? netFail;
  RaspberryAva({this.devices, this.version, this.elapsed, this.elapsedString,
    this.tempInput, this.tMax, this.currentSpeed, this.ip, this.mm,
    this.model, this.company, this.ipInt});

  factory RaspberryAva.fromString(String data, String _ip) {
    List<RegExpMatch> _aucs = regexp.aucs.allMatches(data).toList();
    List<AvalonData> _tmp = [];
    int? _tempInput;
    int? _tMax;
    double _currentSpeed = 0;
    List<String?> _models = [];
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
    for(int n = 0; n < _aucs.length; n++)
    {
      List<RegExpMatch> _auc = regexp.singleData.allMatches(_aucs[n].group(2)??'').toList();
      //print(_aucs[1].group(2));
      for(int i =0; i < _auc.length; i++)
      {
     //   print(_auc[i].group(2));
        AvalonData _data = AvalonData.fromString(_auc[i].group(2)??'', '$_ip', n);
        _tmp.add(_data);
        if(_tempInput==null&&_data.tempInput!=null || _tempInput!<_data.tempInput!)
        {
          _tempInput = _data.tempInput;
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
    }
    return RaspberryAva(
      devices: _tmp,
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      tempInput: _tempInput,
      tMax: _tMax,
      currentSpeed: _currentSpeed,
      ip: _ip,
      company: 'Avalon',
      model: _models.join(','),
      ipInt: _ipInt,
      );
  }
}
