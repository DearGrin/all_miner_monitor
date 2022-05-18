import 'package:avalon_tool/pools_editor/device_pool.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';

class DeviceModel{
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
  Pools? pools;
  List<dynamic>? ps;
  List<int?>? netFail;
  bool? speedError;
  bool? fanError;
  bool? tempError;
  bool? chipCountError;
  bool? chipsSError;
  bool? hashCountError;
  dynamic data;
  DeviceModel({this.status, this.ip, this.ipInt, this.manufacture, this.model, this.isScrypt,
    this.elapsed, this.elapsedString, this.currentSpeed, this.averageSpeed,
    this.tMax, this.tInput, this.mm, this.fans, this.errors, this.pools, this.ps, this.netFail,
    this.data, this.speedError, this.chipCountError, this.chipsSError, this.fanError, this.hashCountError, this.tempError});

  factory DeviceModel.fromData(dynamic data, String _ip){
    /// string ip to int ip for correct sort by ip
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    int? _ipInt = int.tryParse(_octet.join());
    ///manufacture, model and isScrypt
    String _manufacture =  data.manufacture ?? 'unknown';
    String _model = data.model  ?? 'unknown';
    bool _isScrypt = data.isScrypt ?? false;
    ///elapsed
    int _elapsed = data.elapsed ?? -100;
    String _elapsedString = data.elapsedString ?? '-';
    ///speed data
    double? _currentSpeed = data.currentSpeed ?? -100.00;
    double?  _averageSpeed = data.averageSpeed ??  -100.00;
    ///temp
    int? _tMax = data.tMax ??-100;
    int?  _tInput = data.tInput ?? -100;
    ///mm
    String? _mm = data.mm ?? 'unknown';
    ///fans
    List<int?>? _fans = data.fans ?? [];
    ///errors
    List<int?>?  _errors = data.errors;
    ///power supply
    List<dynamic>? _ps=data.ps;
    print(_ps);
    ///net fail
    List<int?>?  _netFail = data.netFail;
    ///pools
    //Pools?  _pools = data.pools;
    ///status resolver
    String _status = '';
    bool? _speedError = data.speedError;
    bool? _fanError = data.fanError;
    bool? _tempError = data.tempError;
    bool? _chipCountError = data.chipCountError;
    bool? _chipSError = data.chipsSError;
    bool? _hashCountError = data.hashCountError;
    return DeviceModel(
      ip: _ip,
      ipInt: _ipInt,
      manufacture: _manufacture,
      model: _model,
      isScrypt: _isScrypt,
      elapsed: _elapsed,
      elapsedString: _elapsedString,
      currentSpeed: _currentSpeed,
      averageSpeed: _averageSpeed,
      tMax: _tMax,
      tInput: _tInput,
      mm: _mm,
      fans: _fans,
      errors: _errors,
      pools: null,
      data: data,
      status: _status,
      ps: _ps,
      netFail: _netFail,
      speedError: _speedError,
      fanError: _fanError,
      tempError: _tempError,
      chipCountError: _chipCountError,
      chipsSError: _chipSError,
      hashCountError: _hashCountError,
    );
  }
}