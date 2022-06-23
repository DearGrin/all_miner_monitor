
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:AllMinerMonitor/scan_list/scanner.dart';
import 'package:easy_isolate/easy_isolate.dart' as e;
import 'package:easy_isolate/easy_isolate.dart';
import 'package:get/get.dart';

import '../pools_editor/device_pool.dart';

Future<e.Worker> spawn({required String ip, required int timeout, required int delay, required String command}) async {
  final worker = e.Worker();
  await worker.init(mainHandler, isolateHandler, queueMode: true);
  Map<String, dynamic> _ = {
    'ip':ip,
    'timeout':timeout,
    'delay':delay,
    'command':command,
  };
  worker.sendMessage(_);
  return worker;
}

Future<void> mainHandler(dynamic rawData, SendPort isolateSendPort) async {

  if(rawData['data']!=null&&rawData['command']=='stats'){
    String data = utf8.decode(rawData['data']);
    Map<String, dynamic> _ = {
      'ip':rawData['ip'],
      'timeout':rawData['timeout'],
      'delay':rawData['delay'],
      'command':'pools',
      'raw':data,
      'isolateIndex': rawData['isolateIndex']
    };
    //print(_);
    isolateSendPort.send(_);
  }
  else if(rawData['data']!=null){
    print(rawData['command']);
   // print(utf8.decode(data['data']));
    try {
      dynamic _device;
      DeviceModel? model;
      EventModel? eventModel;
      Pools? _pools;
      if (rawData['raw'].contains('ID=AVA1')) {
        _device = await AvalonData().fromString(rawData['raw'], rawData['ip']);
        model = await DeviceModel().fromData(_device, rawData['ip']);
        _pools = await Pools().fromString(utf8.decode(rawData['data']));
        model.pools=_pools;
        eventModel = EventModel('device', model, rawData['ip'], rawData['raw'], tag: null, isolateIndex: rawData['isolateIndex']);

      }
      else if (rawData['raw'].contains('ID=AV')) {
        _device = await RaspberryAva().fromStr(rawData['raw'], rawData['ip']);
        model = await DeviceModel().fromData(_device, rawData['ip']);
        _pools = await Pools().fromString(utf8.decode(rawData['data']));
        model.pools=_pools;
        eventModel = EventModel('device', model, rawData['ip'], rawData['raw'], tag: null, isolateIndex: rawData['isolateIndex']);

      }
      else if (rawData['raw'].toLowerCase().contains('antminer')) {
        String _data = rawData['raw'].replaceAll('"', '').replaceAll(':', '=');
        _device = await AntMinerModel().fromString(_data, rawData['ip']);
        model = await DeviceModel().fromData(_device, rawData['ip']);
        _pools = await Pools().fromString(utf8.decode(rawData['data']));
        model.pools=_pools;
        eventModel = EventModel('device', model, rawData['ip'], rawData['raw'], tag: null, isolateIndex: rawData['isolateIndex']);

      }
      else if (rawData['raw'].toLowerCase().contains('whatsminer')) {

      }

   //   _pools = await Pools().fromString(utf8.decode(rawData['data']));
   //   model?.pools=_pools;
   //   eventModel = EventModel('device', model, rawData['ip'], rawData['raw'], tag: null);
      Scanner scanner = Get.find();
    await  scanner.result(eventModel);
    }
    catch(e){
      //
      Scanner scanner = Get.find();
     EventModel eventModel = EventModel('error', e.toString(), rawData['ip'], e.toString(), tag: null, isolateIndex: rawData['isolateIndex']);
      await scanner.result(eventModel);
    }
  }
  else{
   // print(data);
    Scanner scanner = Get.find();
    EventModel eventModel = EventModel('error', 'unknown data', rawData['ip'], 'unknown data', tag: null, isolateIndex: rawData['isolateIndex']);
    await scanner.result(eventModel);
  }
}

Future<void> isolateHandler(dynamic data, SendPort mainSendPort, SendErrorFunction onSendError) async {
  try {
    Socket socket = await Socket.connect(
        data['ip'], 4028, timeout: Duration(seconds: data['timeout']));
    var sub = socket.listen((dynamic event) async {
      try {
        socket.close();
        Map<String, dynamic> _ = {
          'data':event,
          'ip':data['ip'],
          'timeout':data['timeout'],
          'delay':data['delay'],
          'command':data['command'],
          'raw':data['raw']??'',
          'isolateIndex': data['isolateIndex']
        };
        mainSendPort.send(_);
      }
      catch (e) {
       ///
        Map<String, dynamic> _ = {
          'error':e,
          'ip':data['ip'],
          'timeout':data['timeout'],
          'delay':data['delay'],
          'command':data['command'],
          'raw':data['raw']??'',
          'isolateIndex': data['isolateIndex']
        };
        mainSendPort.send(_);
      }
    });
    socket.add(utf8.encode(data['command']));
    await sub.asFuture<void>().timeout(
        Duration(seconds: data['timeout']), onTimeout: () async {
      socket.close();
      ///
      Map<String, dynamic> _ = {
        'error':'timeout',
        'ip':data['ip'],
        'timeout':data['timeout'],
        'delay':data['delay'],
        'command':data['command'],
        'raw':data['raw']??'',
        'isolateIndex': data['isolateIndex']
      };
      mainSendPort.send(_);
    });
  }
  catch(e){
    ///
    Map<String, dynamic> _ = {
      'error':e,
      'ip':data['ip'],
      'timeout':data['timeout'],
      'delay':data['delay'],
      'command':data['command'],
      'raw':data['raw']??'',
      'isolateIndex': data['isolateIndex']
    };
    mainSendPort.send(_);
  }
}