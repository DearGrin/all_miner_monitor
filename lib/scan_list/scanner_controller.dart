import 'dart:async';

import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/avalon_10xx/chip_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/ip_section/ip_range_model.dart';
import 'package:AllMinerMonitor/isolates/isolate_construct_ips_by_threads.dart';
import 'package:AllMinerMonitor/isolates/isolate_iprange_to_ip_list.dart';
import 'package:AllMinerMonitor/isolates/isolate_scan.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ScannerController extends GetxController{
  final  AnalyseResolver analyseResolver = Get.find();
  StreamController isolateScanStream = StreamController<EventModel>();
  StreamController isolatePoolStream = StreamController<EventModel>();
  StreamController stopStream = StreamController<bool>.broadcast();
  RxList<DeviceModel> devices = <DeviceModel>[].obs;
  Rx<DeviceModel> device = DeviceModel().obs;
  int finalProgress = 0;
  int jobsDone = 0;
  RxDouble progress = 0.0.obs;
  String? tag;
  @override
  void onInit(){
    isolateScanStream.stream.listen((event) async{
      await handleDevice(event);
    });
    isolatePoolStream.stream.listen((event) async{
      await handlePools(event);
    });
    super.onInit();
  }
  scan({List<IpRangeModel>? scanList, List<String?>? ips, String? tg}) async {
    if(await scanInProgress()){
      ///scan in progress send abort event
      abortScan();
    }
    await clearQuery();
    List<String?> _ips = [];
    List<List<String?>> _t = [];

    if(scanList!=null) {
      for (var s in scanList) {
        List<String?> _tmp = [s.startIp, s.endIp];
        _t.add(_tmp);
      }
      _ips =
      await compute<List<List<String?>>, List<String>>(getIpsFromRange, _t);
    }
    if(ips!=null){
      _ips=ips;
    }
    finalProgress = _ips.length*2;
    print('final progress is $finalProgress');
    createCommand(_ips, ['stats'], isolateScanStream, tag: tg);
  }
  Future<bool> scanInProgress()async{
    if(progress>0 && progress<1){
      return true;
    }
    else{
      return false;
    }
  }
  abortScan(){
    stopStream.add(true);
  }
  createCommand(List<String?>? ips, List<String> commands, StreamController _isolateStream, {List<dynamic>? addCommands, List<String>? manufactures, String? tag}) async {
    if(ips!=null) {
      Box box = await Hive.openBox('settings');
      int _timeout = box.get('timeout')??10;
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
        if (commands.length > 1) {
          commandsByThread = await compute(constructIpsByThread, [_threads, commands]);
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
      }
      for (int i = 0; i < tasksByThread.length; i++) {
        startScan( tasksByThread[i],
            commandsByThread[i],
            _isolateStream,
            stopStream,
            addCommand: addCommands!=null?addCommandsByThread[i]:null,
            company: manufactures!=null?manufacturesByThread[i]:null,
            credentials:  credentials,
            tag: tag,
            timeout: _timeout);
      }
    }
  }
  startPools()async{
    List<String?> ips = [];
    List<String> commands = [];
    for(DeviceModel d in devices){
      ips.add(d.ip);
      d.manufacture != 'whatsminer'? commands.add('pools') : commands.add('{"cmd":"pools"}');
    }
    jobsDone += ((finalProgress/2).floor() - ips.length); ///add dif to progress
    createCommand(ips, commands, isolatePoolStream, tag: tag);
  }
  checkProgress()async{
    print('check progress: ${progress.value}');
    if(progress.value>=0.5){
      startPools();
    }
  }
  clearQuery()async{
    finalProgress = 0;
    jobsDone = 0;
    progress.value = 0.0;
    devices.clear();
  }
  handleDevice(EventModel event)async{
    if(event.type == 'device') {
      dynamic _device = event.data;
      print(_device);
      if(_device.data.manufacture=='Avalon'&&_device.data.isRasp)
      {
        List<DeviceModel> _devices = [];
        for(DeviceModel d in _device.data.devices){
          _devices.add(await analyseDevice(d));
        }
        _device.data.devices = _devices;
      }
      else{
        _device = await analyseDevice(event.data);
      }
      EventModel _event = EventModel('device', _device, event.ip, event.rawData, tag: event.tag);
     devices.add(_device);
     device.value = _device;
    }
    else {

    }
    jobsDone ++;
    progress.value = jobsDone/finalProgress;
   await  checkProgress();
  }
  handlePools(EventModel event)async{
    if(event.type=='pools'){
      DeviceModel? _ = devices.firstWhere((element) => element.ip==event.ip);
      _.pools = event.data;
    }
    else{

    }
    jobsDone++;
    progress.value = jobsDone/finalProgress;
    print('${jobsDone} and ${progress.value} of ${finalProgress}');
  }
  analyseDevice(DeviceModel device) async{
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
}