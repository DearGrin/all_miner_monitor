import 'package:avalon_tool/antminer/antminer_regexp.dart' as regexp;
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
  String? ip;
  int? ipInt;
  String? company;
  String? model;
  String? status;
  int? elapsed;
  String? elapsedString;
  String? mm;
  double? currentSpeed;
  double? averageSpeed;
  int? frequency;
  List<int?>? freqs;
  List<int?>? volt;
  List<int?>? watt;
  int? hashCount;
  int? fanNum;
  List<int?>? fans;
  int? tMax;
  int? tempCount;
  List<int?>? tChipI;
  List<int?>? tChipO;
  List<int?>? tPcbI;
  List<int?>? tPcbO;
  List<int?>? chipPerChain;
  List<String?>? chainString;
  List<int?>? hwPerChain;
  List<double?>? ratePerChain;
  AntMinerModel({this.model, this.elapsed, this.currentSpeed, this.averageSpeed, this.frequency,
    this.freqs, this.fans, this.tMax, this.tChipO, this.tChipI, this.tPcbO, this.tPcbI,
    this.hashCount, this.volt, this.watt, this.chipPerChain, this.chainString,
    this.fanNum, this.hwPerChain, this.ratePerChain, this.tempCount, this.ip,
    this.ipInt, this.company, this.status='', this.mm, this.elapsedString});

  factory AntMinerModel.fromString(String data, String _ip){
    print(data);
    List<String> _octet = _ip.split('.');
    print(_octet);
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
    print(_ipInt);
    print(regexp.mm.firstMatch(data)?.group(0));
    print(regexp.mm.firstMatch(data)?.group(2));
    String _mm = regexp.mm.firstMatch(data)?.group(2)??'';
    print(_mm);
    String _model = 'Unknown';
    if(_mm.contains('L3')){
      _model = 'L3';
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
    print(_model);
    print(regexp.freqs.firstMatch(data)?.group(2));
    List<int?>? _freqs;
    _freqs = regexp.freqs.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_freqs);
    List<int?>? _volt;
    _volt = regexp.volt.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_volt);
    List<int?>? _watt;
    _watt = regexp.watt.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_watt);
    List<int?>? _fans;
    _fans = regexp.fans.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_fans);
   // List<List<int?>?>? _allTemps;
    List<int?>? _temps;
   // print(regexp.temps.firstMatch(data)?.group(4));
   // _temps = regexp.temps.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(4)))).toList();
   // print(_temps);
    List<int?>? _tChipI;
    _tChipI = regexp.tChipsI.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_tChipI);
    List<int?>? _tChipO;
    _tChipO = regexp.tChipsO.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_tChipO);
    List<int?>? _tPcbI;
    _tPcbI =  regexp.tPcbI.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_tPcbI);
    List<int?>? _tPcbO;
    _tPcbO =  regexp.tPcbO.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_tPcbO);
    List<int?>? _hw;
    _hw = regexp.hw.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_hw);
    List<double?>? _rate;
    _rate = regexp.chain_rate.allMatches(data).map((e) => double.tryParse(nullCheck(e.group(2)))).toList();
    print(_rate);
    List<String?>? _chipString;
    _chipString = regexp.chain_acs.allMatches(data).map((e) => e.group(2)).toList();
    print(_chipString);
    List<int?>? _chips;
    _chips = regexp.chain_acn.allMatches(data).map((e) => int.tryParse(nullCheck(e.group(2)))).toList();
    print(_chips);
    return AntMinerModel(
      ip: _ip,
      ipInt: _ipInt,
      company: 'Antminer',
      model: _model,
      mm: _mm,
      elapsed: getInt(regexp.elapsed.firstMatch(data)?.group(2)),
      elapsedString: intToDate(getInt(regexp.elapsed.firstMatch(data)?.group(2))),
      currentSpeed: _model=='L3'? getDouble(regexp.currentSpeed.firstMatch(data)?.group(2)): getDouble(regexp.currentSpeed.firstMatch(data)?.group(2))!/1000,
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
      tMax: getInt(regexp.tMax.firstMatch(data)?.group(2)),
      fanNum: getInt(regexp.fan_num.firstMatch(data)?.group(2)),
      fans: _fans,
      hashCount: getInt(regexp.miner_count.firstMatch(data)?.group(2)),
      chipPerChain: _chips,
      chainString: _chipString,
      hwPerChain: _hw,
      ratePerChain: _rate,
    );
  }
}