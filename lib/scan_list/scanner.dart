import 'dart:async';
import 'dart:isolate';

import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/antminer/mock_ant.dart';
import 'package:AllMinerMonitor/avalon_10xx/api_commands.dart';
import 'package:AllMinerMonitor/avalon_10xx/chip_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/mock_data.dart';
import 'package:AllMinerMonitor/avalon_10xx/mock_rasp.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/ip_section/ip_range_model.dart';
import 'package:AllMinerMonitor/isolates/easy.dart';
import 'package:AllMinerMonitor/isolates/isolate_construct_ips_by_threads.dart';
import 'package:AllMinerMonitor/isolates/isolate_iprange_to_ip_list.dart';
import 'package:AllMinerMonitor/isolates/isolate_scan.dart';
import 'package:AllMinerMonitor/isolates/isolate_service.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/pools_editor/mock_pool.dart';
import 'package:AllMinerMonitor/pools_editor/pool_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:easy_isolate/easy_isolate.dart' as e;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../pools_editor/device_pool.dart';

class Scanner extends GetxController{
  //final CommandConstructor command = CommandConstructor();
  final  AnalyseResolver analyseResolver = Get.find();
  final int threadMax = 10; //TODO should change via settings?
  StreamController scanResult = StreamController<dynamic>.broadcast();
//  StreamController computeStatus = StreamController<String>();
  StreamController progressStream = StreamController<double>();
  StreamController isolateStream = StreamController<EventModel>();
  StreamController stopStream = StreamController<bool>.broadcast();
 // int currentIndex = 0;
 // List<int> start = [];
 // List<int> end = [];
  List<Pool> pools = [];
  late StreamSubscription sub;
  int finalProgress = 0;
  int jobsDone = 0;
  String? tag;
  double progress = 0.0;

  List<String?> ipToScan = [];
  List<String?> scannedIps = [];
  Map<String, e.Worker> workers = {};

  List<e.Worker> eworkers = [];
  List<String?> ipsToScan = [];
  @override
  void onInit()async{
  /*
    sub = computeStatus.stream.listen((event) {

      currentIndex++;
    });

   */
    isolateStream.stream.listen((event) async{
  //    currentIndex++;
     await handleDevice(event);
    });
    Box box = await Hive.openBox('settings');
    int _threads = box.get('max_threads')??100;
    for(int i = 0; i < _threads; i++){
      final worker = e.Worker();
      await worker.init(mainHandler, isolateHandler, queueMode: true);
      eworkers.add(worker);
    }
    print('spawned ${eworkers.length} isolates!');
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
handleDevice(EventModel event) async {
  debug(subject: 'got event', message: 'type: ${event.type}, tag: $tag', function: 'scanner > handleDevice');
    //  event.tag = tag;

      ///mock pools
     // var _pool = Pools.fromString(mockPoolAva);
      ///mock L3
     // var _device = AntMinerModel.fromString(mockAntL3, '10.10.10.10');
      ///mock S9
     // String _data = mockAntS9.replaceAll('"', '').replaceAll(':', '=');
      //var _device = AntMinerModel.fromString(_data, '10.10.10.10');
      ///mock Avalon 1066
     // var _device = AvalonData.fromString(mockData, '10.10.10.10');
      ///mock Avalon 9xx raspberry
      //var _device = RaspberryAva.fromString(mockRasp, '10.10.10.10');
      //var device = DeviceModel.fromData(_device, '10.10.10.10');
    //  scanResult.add(EventModel('device', device, '10.10.10.10', mockData, tag: tag));

      //device.pools = _pool;


      //scanResult.add(EventModel('device', device, '10.10.10.10', mockData, tag: tag));
/// analyse devices
     if(event.type == 'device') {
       dynamic device = event.data;
       if(device.data.manufacture=='Avalon'&&device.data.isRasp)
         {
           List<DeviceModel> _devices = [];
           for(DeviceModel d in device.data.devices){
             _devices.add(await analyse(d));
           }
           device.data.devices = _devices;
         }
       else{
        device = await analyse(event.data);
       }
       EventModel _event = EventModel('device', device, event.ip, event.rawData, tag: event.tag);
       scanResult.add(_event);
     }
     else {
      scanResult.add(event);
     }
  jobsDone++;
  progress = jobsDone/finalProgress;
  progressStream.add(progress);
}
Future<DeviceModel>analyse(DeviceModel device) async {
  bool _speedError = false;
  bool _fanError = false;
  bool _tempError = false;
  bool _chipCountError = false;
  bool _chipsSError = false;
  bool _hashCountError = false;
  try {
    _speedError = await analyseResolver.hasErrors(
        'min_speed', device.currentSpeed, device.model);
  }
  catch(e){
    debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _speedError');
  }

  try {
    _tempError =
        await  analyseResolver.hasErrors('temp_max', device.tMax, device.model);
  }
  catch(e){
    debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _tempError');
  }

  try {
    _fanError =
        await  analyseResolver.hasErrors('null_list', device.data.fans, device.model);
  }
  catch(e){
    debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _fanError');
  }

  try {
    _hashCountError = await analyseResolver.hasErrors(
        'hash_count', device.manufacture == 'Antminer' ? null : device.data
        .hashBoardCount, device.model);
  }
  catch(e){
    debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _hashCountError');
  }

  try {
    print('manufac is ${device.manufacture}');
    if (device.manufacture!.contains('Whatsminer')) {
      _chipCountError = false;
    }
    else {
      List<int> _chipCountList = [];
      if (device.manufacture == 'Avalon') {
        for (Hashboard board in device.data.hashBoards) {
          int _ = 0;
          _chipCountList.add(board.chips!.length);

          /// first value in avalon is max chip possible
          for (ChipModel chip in board.chips!) {
            if (chip.voltage != null && chip.voltage! > 0) {
              _++;
            }
          }
          _chipCountList.add(_);
        }
      }
      _chipCountError = await analyseResolver.hasErrors(
          'chip_count', device.manufacture == 'Antminer'
          ? device.data.chipPerChain
          : _chipCountList, device.model);
    }
  }
  catch(e){
    debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _chipCountError');
  }

  try {
    _chipsSError =
    device.manufacture == 'Antminer' ? await analyseResolver.hasErrors(
        'acn_s', device.data.chainString, device.model) : false;
  }
  catch(e){
  debug(subject: 'catch error', message: '$e', function: 'scanner > handleDevice > _chipsSError');
  }
  device.speedError = _speedError;
  device.fanError = _fanError;
  device.tempError = _tempError;
  device.chipCountError = _chipCountError;
  device.chipsSError = _chipsSError;
  device.hashCountError = _hashCountError;
  if(_speedError||_fanError||_tempError||_chipsSError||_chipCountError||_hashCountError){
    device.status = 'with problems';
  }
  else {
    device.status = 'success';
  }
  debug(subject: 'errors summary', message: 'speed: ${device.speedError}, fan: ${device.fanError},'
      'temp: ${device.tempError}, chipCount: ${device.chipCountError}, chipS: ${device.chipsSError},'
      'hashCount: ${device.hashCountError}, total: ${device.status}', function: 'scanner > handleDevice > analyse');
  return device;
}
result(EventModel? event) async {
    print('got event! ${event?.type}');
  if(event!=null&&!scannedIps.contains(event.ip)) {
    scannedIps.add(event.ip);
    handleDevice(event);
    if(ipsToScan.isNotEmpty){
      Map<String, dynamic> _ = {
        'ip':ipsToScan[0],
        'timeout':10,
        'delay':300,
        'command':'stats', //TODO ad var command
        'isolateIndex': event.isolateIndex
      };
      ipsToScan.removeAt(0);
      eworkers[event.isolateIndex!].sendMessage(_);
    }
  }
//  final e.Worker _ = workers[event!.ip]!;
 // _.dispose();
  //  final e.Worker worker =  await spawn(ip: ipToScan[jobsDone]!, timeout: 10, delay: 300, command: 'stats');
   // workers[ipToScan[jobsDone]!]=worker;
  }
  universalCreate(List<String?>? ips, List<String> commands, {List<dynamic>? addCommands, List<String>? manufactures, String? tag}) async {
    if(ips!=null) {
      finalProgress = ips.length;
      jobsDone = 0;
      Box box = await Hive.openBox('settings');
      int _timeout = box.get('timeout')??10;
      int _delay = box.get('delay')??300;
      int _threads = box.get('max_threads') ?? 20;
      int maxTasks = (ips.length / _threads).ceil();
      List<List<String?>> tasksByThread = [];
      List<List<String?>> commandsByThread = [];
      List<List<dynamic>> addCommandsByThread = [];
      List<List<String>> manufacturesByThread = [];
      List<Map<dynamic,dynamic>> credentials = [{'root':'root'}];
      List<dynamic> _t = box.get('ant_passwords');
      List<Map<dynamic, dynamic>>? _antPasswords;
      _antPasswords = _t.cast<Map>();
      if(_antPasswords.isNotEmpty){
        credentials = _antPasswords;
      }
      tasksByThread = await compute(constructIpsByThread, [_threads, ips]);

      for (int i = 0; i < _threads; i++) {
       // List<String?> _ = ips.skip(i * maxTasks).take(maxTasks).toList();

        if (commands.length > 1) {
          commandsByThread = await compute(constructIpsByThread, [_threads, commands]);
          /*
          List<String> _c = commands.skip(i * maxTasks).take(maxTasks).toList();
          commandsByThread.add(_c);


           */
        }
        else {
          commandsByThread.add(commands);
        }
        if(addCommands!=null){
          List<dynamic> _ac = addCommands.skip(i * maxTasks).take(maxTasks).toList();
          addCommandsByThread.add(_ac);
        }
        if(manufactures!=null){
          List<String> _m = manufactures.skip(i * maxTasks).take(maxTasks).toList();
          manufacturesByThread.add(_m);
        }
        /*
        if (_.isNotEmpty) {
          tasksByThread.add(_);
        }

         */

      }
      stopStream.add(true);
      ipToScan = ips;
      scannedIps = [];
      ipsToScan = ips;
      for(int i = 0; i < eworkers.length; i++){
        if(ipsToScan.isNotEmpty){
          Map<String, dynamic> _ = {
            'ip':ipsToScan[0],
            'timeout':_timeout,
            'delay':_delay,
            'command':'stats', //TODO ad var command
            'isolateIndex': i
          };
          print(_);
          ipsToScan.removeAt(0);
          eworkers[i].sendMessage(_);
        }
      }
      //for(var ip in ips){
     //final e.Worker worker =  await spawn(ip: ip!, timeout: _timeout, delay: _delay, command: 'stats');
     //workers[ip]
   // }
      /*
      for(int i = 0; i < _threads; i++){
        final e.Worker worker = await spawn(ip: ipToScan[i]!, timeout: _timeout, delay: _delay, command: 'stats');
        workers[ipToScan[i]!]=worker;
      }
*/
      for (int i = 0; i < tasksByThread.length; i++) {


        /*
        startScan( tasksByThread[i], commandsByThread[i], isolateStream, stopStream,
            addCommand: addCommands!=null?addCommandsByThread[i]:null,
            company: manufactures!=null?manufacturesByThread[i]:null,
            credentials:  credentials,
            tag: tag,
            timeout: _timeout);
       */
        /*
        startCompute(
            tasksByThread[i], commandsByThread[i], isolateStream, stopStream,
           addCommand: addCommands!=null?addCommandsByThread[i]:null,
            company: manufactures!=null?manufacturesByThread[i]:null,
            credentials:  credentials,
          tag: tag,
          timeout: _timeout,
          delay: _delay
        );


         */
      }
    }
  }
/*
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


 */
 Future<int>newScan({List<IpRangeModel>? scanList, List<String?>? ips, String? tg}) async {
    stopStream.add(true);
    debug(subject: 'new scan', message: 'tag: ${tg}, ips: ${ips}', function: 'scanner > newScan');
    if(0<=progress && progress<1){
      debug(subject: 'new scan', message: 'tag: ${tg}', function: 'scanner > newScan > abort process');
      scanResult.add(EventModel('abort', null, '', '', tag: tag));
      stopStream.add(true);
    }
    tag = tg;
    clearQuery();
    List<String?> _ips = [];
    List<List<String?>> _t = [];

    if(scanList!=null) {
      for(var s in scanList){
        List<String?> _tmp = [s.startIp, s.endIp];
        _t.add(_tmp);
      }
      _ips = await compute<List<List<String?>>, List<String>>(getIpsFromRange, _t);
      /*
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
      */
    }
    if(ips!=null){
      _ips=ips;
    }
    universalCreate(_ips, ['stats'], tag: tg);
    return _ips.length;
  }
clearQuery(){
   // currentIndex = 0;
   // toScan.clear();
    //toChangePool.clear();
    pools.clear();
   // controlPanelController.updateProgress(0.0);
    progressStream.add(0.0);
    finalProgress = 0;
    jobsDone = 0;
    progress = 0;
}
}