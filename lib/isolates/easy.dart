
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/isolates/rest_api.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:AllMinerMonitor/scan_list/scanner.dart';
import 'package:easy_isolate/easy_isolate.dart';
import 'package:get/get.dart';
import 'package:AllMinerMonitor/whatsminer/whatminer_sum_devs_model.dart';

import '../pools_editor/device_pool.dart';

Future<DeviceModel>parseAvalon1(String data, String ip)async{
  AvalonData _device = await AvalonData().fromString(data, ip);
  DeviceModel model = await DeviceModel().fromData(_device, ip);
  return model;
}
Future<DeviceModel>parseAvalonRasp(String data, String ip)async{
  AvalonData _device = await RaspberryAva().fromString(data, ip);
  DeviceModel model = await DeviceModel().fromData(_device, ip);
  return model;
}
Future<DeviceModel>parseAntMiner(String data, String ip)async{
  AntMinerModel _device = await AntMinerModel().fromString(data, ip);
  DeviceModel model = await DeviceModel().fromData(_device, ip);
  return model;
}
Future<DeviceModel>parseWhatsminer(String devDetails, String summary, String devs,  String ip)async{
  Map<String,dynamic> jsonModel = jsonDecode(devDetails);
  String deviceModel = jsonModel['DEVDETAILS'][0]['Model'];
  Map<String,dynamic> jsonSummary = jsonDecode(summary);
  Map<String,dynamic> jsonDevs = jsonDecode(devs);
  Map<String,dynamic> jsonCombined = {'summary':[jsonSummary], 'devs':[jsonDevs]};
  WhatsminerModel _device = WhatsminerModel.fromJson(jsonCombined, ip, deviceModel);
  DeviceModel model = await DeviceModel().fromData(_device, ip);
  return model;
}
sendResult({DeviceModel? deviceModel, required String ip, String? error, String? update, required String rawData, required int isolateIndex}){
  Scanner scanner = Get.find();
  EventModel? event;
  if(deviceModel!=null){
    event = EventModel('device', deviceModel, ip, rawData, isolateIndex: isolateIndex);
  }
  else if(error!=null){
    event = EventModel('error', error, ip, rawData, isolateIndex: isolateIndex);
  }
  else if(update!=null){
    event = EventModel('update', update, ip, rawData, isolateIndex: isolateIndex);
  }
  else{
    event = EventModel('error', 'unknown error', ip, '', isolateIndex: isolateIndex);
  }
  scanner.handleResult(event);
}
Future<void> mainHandler(dynamic rawData, SendPort isolateSendPort) async {

  switch(rawData['command']){
    /// save callback and send pools command
    case 'stats':
      String data = utf8.decode(rawData['data']);
      Map<String, dynamic> _;
      ///checking for whatsminer answer
      if(data.toLowerCase().contains('whatsminer')){
        _ = {
          'ip': rawData['ip'],
          'timeout': rawData['timeout'],
          'delay': rawData['delay'],
          'command': 'whatsminer_model',
          'addCommand': '{"cmd":"devdetails"}',
          'raw': data,
          'isolateIndex': rawData['isolateIndex']
        };
        isolateSendPort.send(_);
      }
      else {
         _ = {
          'ip': rawData['ip'],
          'timeout': rawData['timeout'],
          'delay': rawData['delay'],
          'command': 'pools',
          'addCommand': 'pools',
          'raw': data,
          'isolateIndex': rawData['isolateIndex']
        };
      }
      isolateSendPort.send(_);
      break;
    case 'whatsminer_model':
      String data = utf8.decode(rawData['data']);
      Map<String, dynamic> _ = {
        'ip': rawData['ip'],
        'timeout': rawData['timeout'],
        'delay': rawData['delay'],
        'command': 'whatsminer_summary',
        'addCommand': '{"cmd":"summary"}',
        'raw': data,
        'devDetails':data,
        'isolateIndex': rawData['isolateIndex']
      };
      isolateSendPort.send(_);
      break;
    case 'whatsminer_summary':
      String data = utf8.decode(rawData['data']);
      Map<String, dynamic> _ = {
        'ip': rawData['ip'],
        'timeout': rawData['timeout'],
        'delay': rawData['delay'],
        'command': 'whatsminer_devs',
        'addCommand': '{"cmd":"devs"}',
        'raw': '${rawData['devDetails'] + data}',
        'devDetails':rawData['devDetails'],
        'summary': data,
        'isolateIndex': rawData['isolateIndex']
      };
      isolateSendPort.send(_);
      break;
    case 'whatsminer_devs':
      String data = utf8.decode(rawData['data']);
      Map<String, dynamic> _ = {
        'ip': rawData['ip'],
        'timeout': rawData['timeout'],
        'delay': rawData['delay'],
        'command': 'pools',
        'addCommand': '{"cmd":"pools"}',
        'raw': '${rawData['devDetails'] + rawData['summary']+ data}',
        'devDetails':rawData['devDetails'],
        'summary': rawData['summary'],
        'devs': data,
        'isolateIndex': rawData['isolateIndex']
      };
      isolateSendPort.send(_);
      break;
      ///
    case 'pools':
      String data = utf8.decode(rawData['data']);
      Pools? _pools;
      ///checking for whatsminer answer
      if(data.contains('cmd')){ ///its whatsminer
        try {
          _pools = Pools.fromJson(jsonDecode(data));
        }
        catch(e){
          print(e); //ignore if prev data is ok
        }
        DeviceModel deviceModel = await parseWhatsminer(rawData['devDetails'], rawData['summary'], rawData['devs'], rawData['ip']);
        deviceModel.pools = _pools;
        sendResult(deviceModel: deviceModel, ip: rawData['ip'], rawData: rawData['raw'], isolateIndex: rawData['isolateIndex']);
      }
      else{
        try {
          _pools = Pools.fromString(data);
        }
        catch(e){
          print(e); //ignore if prev data is ok
        }
        DeviceModel? deviceModel;
        if(rawData['raw'].contains('ID=AVA1')){
          deviceModel = await parseAvalon1(rawData['raw'], rawData['ip']);
        }
        else if (rawData['raw'].contains('ID=AV')){
          deviceModel = await parseAvalonRasp(rawData['raw'], rawData['ip']);
        }
        else if (rawData['raw'].toLoweerCase().contains('antminer')){
          deviceModel = await parseAntMiner(rawData['raw'], rawData['ip']);
        }
        deviceModel?.pools = _pools;
        sendResult(deviceModel: deviceModel, ip: rawData['ip'], rawData: rawData['raw'], isolateIndex: rawData['isolateIndex']);
      }
      break;
    case 'setpool':
     Map<String,dynamic> _ = {
        'ip': rawData['ip'],
        'timeout': rawData['timeout'],
        'delay': rawData['delay'],
        'command': 'reboot',
        'addCommand': 'reboot',
        'isolateIndex': rawData['isolateIndex']
      };
      isolateSendPort.send(_);
      break;
    case 'reboot':

      break;
    case 'error':
      sendResult(error: rawData['error'], ip: rawData['ip'], rawData: rawData['error'], isolateIndex: rawData['isolateIndex']);
      break;
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
          'addCommand':data['addCommand']??'',
          'raw':data['raw']??'',
          'isolateIndex': data['isolateIndex'],
          'devDetails': data['devDetails']??'',
          'summary': data['summary']??'',
          'devs': data['devs']??'',
          'credentials':data['credentials'],
        };
        mainSendPort.send(_);
      }
      catch (e) {
       ///
        Map<String, dynamic> _ = {
          'error':e.toString(),
          'ip':data['ip'],
          'timeout':data['timeout'],
          'delay':data['delay'],
          'command':'error',
          'addCommand':data['addCommand'],
          'raw':data['raw']??'',
          'isolateIndex': data['isolateIndex']
        };
        mainSendPort.send(_);
      }
    });
    if(data['command']=='reboot'){
      if(data['manufacture'].toLowerCase()=='antminer'){
        socket.close();
        var c = await RestApi().reboot(data['ip'], data['credentials']);
        sendResult(ip: data['ip'], update: c, rawData: c, isolateIndex: data['isolateIndex']);
      }
      else {
        socket.add(utf8.encode(data['addCommand']));
      }
    }
    else if(data['command']=='setpool'){
      if(data['manufacture'].toLowerCase()=='antminer'){
        socket.close();
        var c = await RestApi().setPool(data['ip'], data['addCommand'], data['credentials']);
        sendResult(ip: data['ip'], update: c, rawData: c, isolateIndex: data['isolateIndex']);
      }
      else{
        socket.add(utf8.encode(data['addCommand']));
      }
    }
    else{
      socket.add(utf8.encode(data['addCommand']));
    }
    //socket.add(utf8.encode(data['addCommand']));
    await sub.asFuture<void>().timeout(
        Duration(seconds: data['timeout']), onTimeout: () async {
      socket.close();
      ///
      Map<String, dynamic> _ = {
        'error':'timeout',
        'ip':data['ip'],
        'timeout':data['timeout'],
        'delay':data['delay'],
        'command':'error',
        'addCommand':data['addCommand'],
        'raw':data['raw']??'',
        'isolateIndex': data['isolateIndex']
      };
      mainSendPort.send(_);
    });
  }
  catch(e){
    ///
    Map<String, dynamic> _ = {
      'error':e.toString(),
      'ip':data['ip'],
      'timeout':data['timeout'],
      'delay':data['delay'],
      'command':'error',
      'addCommand':data['addCommand'],
      'raw':data['raw']??'',
      'isolateIndex': data['isolateIndex']
    };
    mainSendPort.send(_);
  }
}