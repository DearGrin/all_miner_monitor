import 'dart:async';

import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/avalon_10xx/chip_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/isolates/isolate_comand_constructor.dart';
import 'package:AllMinerMonitor/isolates/isolate_service.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LayoutScanner extends GetxController{
  StreamController isolateStream = StreamController<EventModel>();
  StreamController stopStream = StreamController<bool>.broadcast();
  final  AnalyseResolver analyseResolver = Get.find();
  Rx<EventModel> scanResult = EventModel('', null, '', '', tag: '').obs;
  RxString scanCompletedTag = ''.obs;
  String currentTag = '';
  int jobsDone = 0;
  int finalProgress = 0;
  double progress = 0.0;
  RxBool isManualScan = false.obs;
  RxString nextScan = ''.obs;
  @override
  void onInit() {
    isolateStream.stream.listen((event) async{await handleScanResult(event);});
    super.onInit();
  }

  scan({required List<String?> ips,  required String? tag, required bool isManual}) async {
    debug(subject: 'new scan', message: 'ips length: ${ips.length}, tag: $tag', function: 'LayoutScanner > scan');
    isManualScan.value = isManual;
    bool isScanInProgress = await checkScanProgress();
    if(isScanInProgress){
     await abortScan(tag??'', isManual);
    }
    else {
     await clearQuery(); /// just for sure to clear data
    }
    currentTag = tag??'';
    finalProgress = ips.length;
    if(ips.isNotEmpty) {
      Box box = await Hive.openBox('settings');
      int _threads = box.get('max_threads') ?? 20;
     // int maxTasks = (ips.length / _threads).ceil();
      List<List<String?>> tasksByThread = [];
        tasksByThread = await compute(constructCommands, [_threads, ips]);
        /*
      for (int i = 0; i < _threads; i++) {
        List<String?> _ = ips.skip(i * maxTasks).take(maxTasks).toList();
        _.isNotEmpty ? tasksByThread.add(_) : null;
      }


         */
      for (int i = 0; i < tasksByThread.length; i++) {
        startCompute(
            tasksByThread[i], ['stats'],
            isolateStream,
            stopStream,
            addCommand: null,
            company: null,
            credentials: null,
            tag: tag
        );
      }
    }
  }
  handleScanResult(EventModel event)async{
    if(event.tag == currentTag){
      debug(subject: 'got event', message: 'type: ${event.type}, tag: ${event.tag}', function: 'LayoutScanner > handleScanResult');
      if(event.type=='device'){ /// check event type
        dynamic device = event.data;
        if(device.data.manufacture=='Avalon'&&device.data.isRasp) ///case for Avalon Raspberry (8xx and 9xx models)
        {
          List<DeviceModel> _devices = [];
          for(DeviceModel d in device.data.devices){
            _devices.add(await analyseDevice(d));
          }
          device.data.devices = _devices;
        }
        else{
          device = await analyseDevice(event.data);///case for all other devices
        }
        EventModel _event = EventModel('device', device, event.ip, event.rawData, tag: event.tag);
        scanResult.value = _event;
      }
      else{ ///suppose error type mostly
        scanResult.value = event;
      }
      await handleScanProgress(event.tag??'');
    }
  }
 Future<DeviceModel> analyseDevice(DeviceModel device)async{
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
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _speedError');
   }

   try {
     _tempError =
     await  analyseResolver.hasErrors('temp_max', device.tMax, device.model);
   }
   catch(e){
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _tempError');
   }

   try {
     _fanError =
     await  analyseResolver.hasErrors('null_list', device.data.fans, device.model);
   }
   catch(e){
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _fanError');
   }

   try {
     _hashCountError = await analyseResolver.hasErrors(
         'hash_count', device.manufacture == 'Antminer' ? null : device.data
         .hashBoardCount, device.model);
   }
   catch(e){
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _hashCountError');
   }

   try {
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
   catch(e){
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _chipCountError');
   }

   try {
     _chipsSError =
     device.manufacture == 'Antminer' ? await analyseResolver.hasErrors(
         'acn_s', device.data.chainString, device.model) : false;
   }
   catch(e){
     debug(subject: 'catch error', message: '$e', function: 'LayoutScanner > analyseDevice > _chipsSError');
   }
   device.speedError = _speedError;
   device.fanError = _fanError;
   device.tempError = _tempError;
   device.chipCountError = _chipCountError;
   device.chipsSError = _chipsSError;
   device.hashCountError = _hashCountError;
   debug(subject: 'finish analyse', message: 'ip: ${device.ip}'
       'model: ${device.model}, '
       'speedError: $_speedError, '
       'fanError: $_fanError, '
       'tempError: $_tempError, '
       'chipCountError: $_chipCountError, '
       'chipsSError: $_chipsSError, '
       'hashCountError: $_hashCountError',
       function: 'LayoutScanner > analyseDevice');
   return device;
 }
  Future<bool>checkScanProgress()async{
    if(progress<1){
      debug(subject: 'check scan progress', message: 'scan in progress: true', function: 'LayoutScanner > checkScanProgress');
      return true;
    }
    else{
      debug(subject: 'check scan progress', message: 'scan in progress: false', function: 'LayoutScanner > checkScanProgress');
      return false;
    }
  }
  Future<void>abortScan(String tag, bool isManual)async{
    debug(subject: 'abort scan', message: 'tag: $tag', function: 'LayoutScanner > abortScan');
    stopStream.add(true); ///send event to isolates
    scanCompletedTag.value = currentTag;
    scanCompletedTag.value =  '';
    await clearQuery();
  }
  Future<void>handleScanProgress(String tag)async{
    jobsDone++;
    progress = jobsDone/finalProgress;
    debug(subject: 'scan progress', message: 'tag: $tag, progress: $progress', function: 'LayoutScanner > handleScanProgress');
    if(progress>=1){
      scanCompletedTag.value = currentTag; /// send event with tag
      scanCompletedTag.value =  ''; ///clear stream
      nextScan.value = 'next';
      nextScan.value = '';
      await clearQuery();
    }
  }
  Future<void> clearQuery() async{
    jobsDone = 0;
    progress = 0.0;
    finalProgress = 0;
    debug(subject: 'clear query', message: 'jobsDone: $jobsDone, progress: $progress, progress: $progress', function: 'LayoutScanner > clearQuery');
  }
}