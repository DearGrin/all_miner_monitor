import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/avalon_10xx/chip_model.dart';
import 'package:avalon_tool/avalon_10xx/error_handler.dart';
import 'package:avalon_tool/avalon_10xx/regexp_parser.dart' as regexp;
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:flutter/cupertino.dart';
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
    if(_model!.startsWith('1'))
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
/*
class General{
  String? version;
  String? elapsed;
  String? dna;
  String? status;
  String? workMode;
  String? netFail;
  int? tempEnter;
  String? fans;
  List<Map<String, String>>? infos = [];

  General({this.version, this.elapsed, this.dna, this.status, this.workMode,
    this.netFail, this.tempEnter, this.fans, this.infos});
  factory General.fromModel(AvalonData data){
    return General(

    );
  }
  factory General.fromString(String data){
    final RegExp regExp = RegExp(r'(Ver\[)(.*?)(\])');
    final RegExp regExp2 = RegExpHelper().version;
    List<String> _ = [];
    final m = RegExpHelper().version.firstMatch(data)?.group(2);
    final m2 = RegExpHelper().elapsed.firstMatch(data)?.group(2);
    final m3 = RegExpHelper().dna.firstMatch(data)?.group(2);
    final m4 = RegExpHelper().status.firstMatch(data)?.group(2);
    final m5 = RegExpHelper().workMode.firstMatch(data)?.group(2);
    final m6 = RegExpHelper().netFail.firstMatch(data)?.group(2);
    final m7 = RegExpHelper().tempEnter.firstMatch(data)?.group(2);
    final m8 = RegExpHelper().fans.allMatches(data).forEach((element) {
      _.add(element.group(2)??'0');
      //_.add('/');
    });
    //print('ver: $m');
    //print('elapsed: $m2');
    //print('dna: $m3');
   // print('status: $m4');
    //print('work mode: $m5');
   // print('net fail: $m6');
   // print('temp input: $m7');
    //print(_.join(' '));
    String m9 = _.join('/');
    //print(regExp.firstMatch(data).toString());
    //final match = regExp.firstMatch(data);
    //print(match!.group(2));
    String _t = RegExpHelper().tempEnter.firstMatch(data)?.group(2)??'-255';
    return General(
      version: RegExpHelper().version.firstMatch(data)?.group(2) ?? 'no data',
      elapsed: RegExpHelper().elapsed.firstMatch(data)?.group(2) ?? 'no data',
      dna: RegExpHelper().dna.firstMatch(data)?.group(2) ?? 'no data',
      workMode: RegExpHelper().workMode.firstMatch(data)?.group(2) ?? 'no data',
      tempEnter: int.parse(_t),
      fans: _.join(' '),
      infos: [
        {'Version':'$m'},
        {'Elapsed':'$m2'},
        {'Dna':'$m3'},
        {'Work mode':'$m5'},
        {'temp input':'$m7'},
        {'fans':m9},
      ],
    );
  }
}
class Hashboards{
  String? hashCount;
  String? chipCount;
  String? tAvgMax;
  String? tPerHashMax;
  String? errors;
  String? dh;
  List<Map<String, String>>? infos = [];
  Hashboards({this.hashCount, this.chipCount, this.tAvgMax, this.tPerHashMax,
    this.errors, this.dh, this.infos});
  factory Hashboards.fromString(String data){
    final _hc = RegExpHelper().hashBoardCount.firstMatch(data)?.group(2);
    final _tav = RegExpHelper().tAvg.firstMatch(data)?.group(2);
    final _tm = RegExpHelper().tMax.firstMatch(data)?.group(2);
    final String _tam = '$_tav / $_tm';
    final _tbm = RegExpHelper().tMaxByBoard.firstMatch(data)?.group(2)?.split(' ') ?? [];
    final String _tbms = _tbm.join('/');
    final _ecmm = RegExpHelper().ecmm.firstMatch(data)?.group(2) ?? '-1';
    String _ = '';
    final _ecmme = ErrorHandler().getErrors(int.tryParse(_ecmm));
    for(int i = 0; i < _ecmme!.length; i++)
      {
        _ = _ + _ecmme[i].id.toString() + ' - ' +_ecmme[i].descr + '\n';
      }
    final _hw = RegExpHelper().hw.firstMatch(data)?.group(2) ?? '';
    final _dh = RegExpHelper().dh.firstMatch(data)?.group(2) ?? '';
    String _d = '$_hw - $_dh';
    return Hashboards(
      infos: [
        {'Hash board count':'$_hc'},
        {'t - avg/max': _tam},
        {'t - max by board': _tbms},
        {'Errors':_},
        {'Hardware errors':_d},
      ],
    );
  }
}
class Speed{
  String? freq;
  String? currentSpeed;
  String? averageSpeed;
  List<Map<String, String>>? infos = [];
  Speed({this.freq, this.currentSpeed, this.averageSpeed, this.infos});
  factory Speed.fromString(String data){
    final _f = RegExpHelper().freq.firstMatch(data)?.group(2);
    final _cs = RegExpHelper().currentSpeed.firstMatch(data)?.group(2) ?? '-255';
    final _as = RegExpHelper().averageSpeed.firstMatch(data)?.group(2) ?? 'no data';
    String _c = ((int.parse(_cs.substring(0,_cs.length-3)))/1000).toStringAsFixed(2);
    String _a = _as=='no data'? '-' : ((double.tryParse(_as.substring(0,_as.length-3)))!/1000).toStringAsFixed(2);
    //String _a = ((double.tryParse(_as.substring(0,_as.length-3)))!/1000).toStringAsFixed(2);
   // print('$_f');
  //  print('$_cs');
  //  print('$_as');
    return Speed(
      infos: [
        {'Frequency':'$_f'},
        {'Current speed':'$_c TH/s'},
        {'Average speed':'$_a TH/s'},
      ],
    );
  }
}
class PowerSupply{
  String? errors;
  String? voltageMM;
  String? voltageOutput;
  String? powerHashboards;
  String? requiredVoltage;
  String? consumption;
  String? communication;
  List<Map<String,String>>? infos = [];
  PowerSupply({this.errors, this.voltageMM, this.voltageOutput,
    this.powerHashboards, this.requiredVoltage,
    this.consumption, this.communication, this.infos});
  factory PowerSupply.fromString(String data){
    final _comm = RegExpHelper().powerCommunication.firstMatch(data)?.group(2) ?? 'no data';
    final _ps = RegExpHelper().ps.firstMatch(data)?.group(2)?.split(' ');
    String _er = _ps?[0]=='0'? 'no errors' : _ps?[0]
        ?? 'no data';
    final _vmm = (int.tryParse(_ps![1]))!/100;
    final _out = (int.tryParse(_ps![2]))!/100;
    final _a = _ps[3].toString() + 'A';
    final _w = _ps[4].toString() + 'W';
    final _r = (int.tryParse(_ps![5]))!/100;
    return PowerSupply(
      infos: [
        {'Errors': _er},
        {'Voltage MM':'$_vmm V'},
        {'Voltage output':'$_out V'},
        {'Hashboard consumption':'$_a / $_w'},
        {'Required voltage':'$_r V'},
      //  {'Total consumtion':'$'},
        {'Communication':_comm},
      ],
    );
  }
}
class Extras{}


 */
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
/*
class Raspberry{

  Future<String> loadAsset() async {
    return await rootBundle.loadString('lib/assets/log_rasp.txt');
  }
  printData(String? ip) async {
    String _ = await loadAsset();
    RaspberryAva rasp = RaspberryAva.fromString(_, ip);
  }
}

 */