import 'dart:async';
import 'package:avalon_tool/antminer/antminer_model.dart';
import 'package:avalon_tool/antminer/mock_ant.dart';
import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/mock_rasp.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:avalon_tool/isolates/isolate_service.dart';
import 'package:avalon_tool/models/device_model.dart';
import 'package:avalon_tool/pools_editor/mock_pool.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../pools_editor/device_pool.dart';

class Scanner extends GetxController{
  final Api api = Api();
  final CommandConstructor command = CommandConstructor();
  final int threadMax = 10; //TODO should change via settings?
  StreamController scanResult = StreamController<dynamic>.broadcast();
  StreamController computeStatus = StreamController<String>();
  StreamController progressStream = StreamController<double>();
  StreamController isolateStream = StreamController<EventModel>();
  StreamController stopStream = StreamController<bool>.broadcast();
  int currentIndex = 0;
  List<int> start = [];
  List<int> end = [];
  List<Pool> pools = [];
  late StreamSubscription sub;
  int finalProgress = 0;
  int jobsDone = 0;
  String? tag;
  @override
  void onInit(){
    sub = computeStatus.stream.listen((event) {

      currentIndex++;
    });
    isolateStream.stream.listen((event) {
      currentIndex++;
      handleDevice(event);
    });
    super.onInit();
  }

  void onDispose(){
    sub.cancel();
    super.dispose();
  }

  bool validateIp(String ip){
    final RegExp regExp = RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$');
    return regExp.hasMatch(ip);
  }
handleDevice(EventModel event){
      event.tag = tag;
      jobsDone++;
      double _progress = jobsDone/finalProgress;
      progressStream.add(_progress);
      ///mock pools
     // var _pool = Pools.fromString(mockPoolAva);
      ///mock L3
      var _device = AntMinerModel.fromString(mockAntL3, '10.10.10.10');
      ///mock S9
     // String _data = mockAntS9.replaceAll('"', '').replaceAll(':', '=');
      //var _device = AntMinerModel.fromString(_data, '10.10.10.10');
      ///mock Avalon 1066
     // var _device = AvalonData.fromString(mockData, '10.10.10.10');
      ///mock Avalon 9xx raspberry
      //var _device = RaspberryAva.fromString(mockRasp, '10.10.10.10');
     // var device = DeviceModel.fromData(_device, '10.10.10.10');
      //device.pools = _pool;
      //scanResult.add(EventModel('device', device, '10.10.10.10', mockData, tag: tag));

    scanResult.add(event);

}
  universalCreate(List<String?>? ips, List<String> commands, [List<String>? addCommands]) async {
    if(ips!=null) {
      finalProgress = ips.length;
      jobsDone = 0;
      Box box = await Hive.openBox('settings');
      int _threads = box.get('max_threads') ?? 20;
      int maxTasks = (ips.length / _threads).ceil();
      List<List<String?>> tasksByThread = [];
      List<List<String>> commandsByThread = [];
      List<List<String>> addCommandsByThread = [];
      for (int i = 0; i < _threads; i++) {
        List<String?> _ = ips.skip(i * maxTasks).take(maxTasks).toList();
        if (commands.length > 1) {
          List<String> _c = commands.skip(i * maxTasks).take(maxTasks).toList();
          commandsByThread.add(_c);
        }
        else {
          commandsByThread.add(commands);
        }
        if(addCommands!=null){
          List<String> _ac = addCommands.skip(i * maxTasks).take(maxTasks).toList();
          addCommandsByThread.add(_ac);
        }
        if (_.isNotEmpty) {
          tasksByThread.add(_);
        }
      }
      stopStream.add(true);
      for (int i = 0; i < tasksByThread.length; i++) {
        startCompute(
            tasksByThread[i], commandsByThread[i], isolateStream, stopStream, addCommands!=null?addCommandsByThread[i]:null);
      }
    }
  }

handleCallback(String callback, String ip){
  computeStatus.add('next');
  dynamic _data;
  EventModel _event;
  if(callback.contains('STATUS=')&&callback.contains('ID=AVA')){
    _data = AvalonData.fromString(callback, ip);
    _event = EventModel('device', _data, ip, callback);
  }
  else if(callback.contains('STATUS=')&&callback.contains('ID=AV')){
    _data = RaspberryAva.fromString(callback, ip);
    _event = EventModel('device', _data, ip, callback);
  }
  else if(callback.contains('STATUS=')&&callback.contains('Pool(s)')){
    _data = Pool.fromString(callback);
    _event = EventModel('pool', _data, ip, callback);
  }
  else if(callback.contains('STATUS=')){
    _event = EventModel('update', callback, ip, callback);
  }
  else{
    _event = EventModel('error', callback, ip, callback);
  }
  scanResult.add(_event);
}

  newScan({List<IpRangeModel>? scanList, List<String?>? ips, String? tg}) async {
    stopStream.add(true);
    if(tag!=null){
      scanResult.add(EventModel('abort', null, '', '', tag: tag));
    }
    tag = tg;
    clearQuery();
    List<String?> _ips = [];
    if(scanList!=null) {
      for (int i = 0; i < scanList.length; i++) {
        List<int>? _start = scanList[i].startIp?.split('.').map((e) =>
        int.tryParse(e)!).toList();
        List<int>? _end = scanList[i].endIp?.split('.').map((e) =>
        int.tryParse(e)!).toList();
        while (_start![3] <= _end![3]) {
          String _ip = _start[0].toString() + '.' + _start[1].toString() + '.' +
              _start[2].toString() + '.' + _start[3].toString();

          _ips.add(_ip);
          if (_start[3] != _end[3]) {
            _start[3]++;
          }
          else {
            if (_start[2] < _end[2]) {
              _start[3] = 1;
              _start[2] ++;
            }
            else {
              _start[3]++;
            }
          }
        }
      }
    }
    if(ips!=null){
      _ips=ips;
    }
    universalCreate(_ips, ['stats']);
  }
clearQuery(){
    currentIndex = 0;
   // toScan.clear();
    //toChangePool.clear();
    pools.clear();
   // controlPanelController.updateProgress(0.0);
    progressStream.add(0.0);
    finalProgress = 0;
    jobsDone = 0;
}
}