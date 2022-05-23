import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/isolates/rest_api.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/pools_editor/device_pool.dart';
import 'package:AllMinerMonitor/pools_editor/pool_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';


void startCompute(List<String?> f, List<String> commands,
    StreamController eventStream, StreamController stopStream, {List<dynamic>? addCommand, List<String>? company, List<Map<dynamic,dynamic>>? credentials, String? tag}) async{
  await for (final result in _sendAndReceive(f, commands, stopStream, addCommand: addCommand, company: company, credentials: credentials, tag: tag)) {
    eventStream.add(result);
  }
}

Stream<EventModel> _sendAndReceive(List<String?> ips, List<String> commands,
    StreamController stopStream, {List<dynamic>? addCommand, List<String>? company, List<Map<dynamic,dynamic>>? credentials, String? tag}) async* {

  final p = ReceivePort();
  await Isolate.spawn(sendCommand, p.sendPort);

  // Convert the ReceivePort into a StreamQueue to receive messages from the
  // spawned isolate using a pull-based interface. Events are stored in this
  // queue until they are accessed by `events.next`.
  final events = StreamQueue<dynamic>(p);
  bool toFinish = false;
  // The first message from the spawned isolate is a SendPort. This port is
  // used to communicate with the spawned isolate.
  SendPort sendPort = await events.next;

  stopStream.stream.listen((event) async {
    toFinish = true;
    sendPort.send(null);
  });

  for(int i = 0; i < ips.length; i++){
    // Send the next filename to be read and parsed
    if(toFinish){
      break;
    }
  //print(addCommand![0].runtimeType);


    if(commands.length>1) {
      sendPort.send({
        'ip':'${ips[i]}',
        'command':commands[i],
        'addCommand': addCommand!=null? addCommand[i]:null,
        'company': '${company!=null? company[i]:null}',
        'credentials': credentials,
        'tag': tag??''
      }
      );
    }
    else{
      sendPort.send({
        'ip':'${ips[i]}',
        'command':commands[0],
        'addCommand': addCommand!=null? addCommand[i]:null,
        'company': '${company!=null? company[i]:null}',
        'credentials': credentials,
        'tag' : tag??''
      }
      );
    }
    // Receive the parsed JSON
    EventModel message = await events.next;

    // Add the result to the stream returned by this async* function.
    yield message;
  }
  // Send a signal to the spawned isolate indicating that it should exit.
  sendPort.send(null);

  // Dispose the StreamQueue.
  await events.cancel();
}
sendAnswer(SendPort p, EventModel eventModel){
  p.send(eventModel);
}
socketSendCommand(String ip, String command, SendPort p, {DeviceModel? device, dynamic addCommands, String? company, List<Map<dynamic,dynamic>>? credentials, String? tag}) async{
  dynamic data;
  print(addCommands);
  try {
    switch(command){
      case 'pools':
        Socket socket = await Socket.connect(
            ip, 4028, timeout: const Duration(seconds: 5));
        socket.listen((dynamic event) {
          poolHandler(p, utf8.decode(event), device!, ip, tag);
          data = utf8.decode(event);
          socket.close();
        });
        socket.add(utf8.encode(command));
        break;
      case 'setpool':
        print('case set pool and $company');
        EventModel? eventModel;
        if(company!.contains('Antminer'))
          {
            print('contains ant');
           // RestApi _api = RestApi();
            print(ip);
            print(addCommands);
          //  _api.test(ip, addCommands!);
          var callback = await RestApi().test(ip, addCommands!,credentials);
      //    var c = await  RestApi().setPool(ip, addCommands!);
            eventModel = EventModel('update', callback, ip, callback, tag: tag);
          }
        else{
          Socket socket = await Socket.connect(
              ip, 4028, timeout: const Duration(seconds: 5));
          socket.listen((dynamic event) {
            handler(p, utf8.decode(event), command,  ip, tag);
            data = utf8.decode(event);
            socket.close();
          });
          socket.add(utf8.encode(addCommands!));
          eventModel = EventModel('update', 'set pool', ip, 'set pool', tag: tag);
        }
        sendAnswer(p, eventModel);
        break;
      case 'aging':
        if(device!=null && device.manufacture?.toLowerCase()=='avalon' && device.model!.startsWith('1'))
          {
            Socket socket = await Socket.connect(
                ip, 4028, timeout: const Duration(seconds: 5));
            socket.listen((dynamic event) {
              handler(p, utf8.decode(event), command,  ip, tag);
              data = utf8.decode(event);
              socket.close();
            });
            socket.add(utf8.encode(command));
          }
        else{
          EventModel eventModel = EventModel('update', 'skip', ip, 'skip', tag: tag);
          sendAnswer(p, eventModel);
        }
        break;
      case 'reboot':
        print('case reboot');
        EventModel? eventModel;
        if(company!.contains('Antminer'))
          {
            print('case ant');
           var c = await RestApi().reboot(ip, credentials);
           eventModel = EventModel('update', c, ip, c, tag: tag);
          }
        else
        {
          Socket socket = await Socket.connect(
              ip, 4028, timeout: const Duration(seconds: 5));
          socket.add(utf8.encode(command));
          socket.close();
          eventModel = EventModel('update', 'reboot', ip, 'reboot', tag: tag);
        }
       //  eventModel = EventModel('update', 'reboot', ip, 'reboot');
        sendAnswer(p, eventModel);
        break;
      default:
        Socket socket = await Socket.connect(
            ip, 4028, timeout: const Duration(seconds: 5));
        var sub = socket.listen((dynamic event) {
          handler(p, utf8.decode(event), command,  ip, tag);
         // data = utf8.decode(event);
          socket.close();
        });
        socket.add(utf8.encode(command));
        await Future.delayed(const Duration(milliseconds: 300));
        await sub.asFuture<void>().timeout(const Duration(seconds: 7), onTimeout: () async {print('timeout');throw 'timeout';});
    }
  }
  catch(err){
    data = '$err';
    EventModel eventModel = EventModel('error', '$err', ip, '$err', tag: tag);
    sendAnswer(p, eventModel);
    //p.send(eventModel);
  }
}
poolHandler(SendPort p, String data, DeviceModel device, String ip, String? tag) async {
  EventModel eventModel = EventModel('error', 'empty event in pool handler', 'fail', 'event was not initialised - pool handler',tag: tag);
  Pools? _pools;
  try{
     _pools = Pools.fromString(data);
  }
  catch(e){
    print(e);
    eventModel = EventModel('error', e.toString(),ip, e.toString(), tag: tag);
  }
  if(_pools!=null){
    device.pools = _pools;
    eventModel = EventModel('device', device, ip, data, tag: tag);
  }
  else{
    eventModel = EventModel('device', device, ip, data, tag: tag);
  }
sendAnswer(p, eventModel);
}
handler(SendPort p, String data, String command, String ip, String? tag) async {
  EventModel eventModel = EventModel('error', 'empty event', 'fail', 'event was not initialised', tag: tag);
 // dynamic device;
  DeviceModel? model;
  if(command=='estats'||command=='stats|debug'||command=='stats'){

    if(data.contains('ID=AVA1')) {
      try{
        var _device = AvalonData.fromString(data, ip);
        var device = DeviceModel.fromData(_device, ip);
        model = device;
      //  eventModel = EventModel('device', device, ip, data);
      }
      catch(e){
        eventModel = EventModel('error', e.toString(),ip, data, tag: tag);
        sendAnswer(p, eventModel);
      }
    }
    else if (data.contains('ID=AV')){
      try {
        var _device = RaspberryAva.fromString(data, ip);
        var device = DeviceModel.fromData(_device, ip);
        model = device;
      //  eventModel = EventModel('device', device, ip, data);
      }
      catch(e){
        eventModel = EventModel('error', e.toString(),ip, data, tag: tag);
        sendAnswer(p, eventModel);
      }
    }
    else if(data.toLowerCase().contains('antminer')){
      try {
        String _data = data.replaceAll('"', '').replaceAll(':', '=');
        var _device = AntMinerModel.fromString(_data, ip);
        var device = DeviceModel.fromData(_device, ip);
        model = device;
      //  eventModel = EventModel('device', device, ip, data);
      }
      catch(e){
        eventModel = EventModel('error', e.toString(),ip, data, tag: tag);
        sendAnswer(p, eventModel);
      }
    }
    else{
      data = data;
      eventModel = EventModel('error', data,ip, data, tag: tag); //TODO unknown device
      sendAnswer(p, eventModel);
    }
    if(model!=null){
      socketSendCommand(ip, 'pools', p, device: model, tag: tag);
    }
/*
      try {
        Socket socket = await Socket.connect(
            ip, 4028, timeout: const Duration(seconds: 5));
        socket.listen((dynamic event) {
          //handleCallback(event.toString());
          // handleCallback(p, EventModel('error', utf8.decode(event), message.keys.first));
          handler2(p, utf8.decode(event), ip, device, data);
          data = utf8.decode(event);
          // eventModel = EventModel('error', data, message.keys.first);
          //   eventStream.add(event.toString());
          // data = event.toString();
          socket.close();
        });
        socket.add(utf8.encode('pools'));
      }
      catch(err){
        data = '$err';
        eventModel = EventModel('error', data, ip, data);
      //  handler2(p, mockRasp, ip , device);
        //p.send(eventModel);
        // callback = mockData;
      }


 */
  }
  else{
    if(data.contains('STATUS=')) {
      eventModel = EventModel('update', data, ip, data, tag: tag);
    }
    else{
      eventModel = EventModel('error', data, ip, data, tag: tag);
    }
    sendAnswer(p, eventModel);
  }
  //sendAnswer(p, eventModel);
  //p.send(eventModel);
}
Future<void> sendCommand(SendPort p) async{
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);

  /*
  handleCallback(SendPort p, EventModel eventModel){
    p.send(eventModel);
  }

   */
  /*
  handler2(SendPort p, String data, String ip, dynamic device, String prevRawData){
    //Pool pool = Pool.fromString(data);
    String actualRawData = 'prevRawData \n data';
   //eventModel = EventModel('device', device, ip, actualRawData); //TODO
  }


   */
  await for (final message in commandPort) {
    if (message is Map<dynamic,dynamic>) {
      print(message);
      print(message['addCommand']);
      // TODO do the logic here
      socketSendCommand(message['ip']??'', message['command']??'', p,
          addCommands: message['addCommand'], company: message['company'],
        credentials: message['credentials'], tag: message['tag']
      );
      /*
      dynamic data;
      EventModel? eventModel;
      try {
        Socket socket = await Socket.connect(
            message.keys.first, 4028, timeout: const Duration(seconds: 5));
        socket.listen((dynamic event) {
          handler(p, utf8.decode(event), message.values.first,  message.keys.first);
          data = utf8.decode(event);
          socket.close();
        });
        socket.add(utf8.encode(message.values.first));
      }
      catch(err){
        data = '$err';
        eventModel = EventModel('error', '$err', message.keys.first, '$err');
        sendAnswer(p, eventModel);
        //p.send(eventModel);
      }
      */
    //  eventModel = EventModel('error', data, message.keys.first);
      /*
      if(message.values.first=='estats'){
        String _call = await Api.sendCommand(message.keys.first, 4028, message.values.first, 10);
        //String _call2 = await Api.sendCommand(message.keys.first, 4028, 'pools', 1);
        if(_call.contains('ID=AVA')) {
         // data = AvalonData.fromString(_call, message.keys.first);
          //data.pools = [Pool.fromString(_call2)];
          eventModel = EventModel('error', _call, message.keys.first);
        }
        else if (_call.contains('ID=AV')){
          //data = RaspberryAva.fromString(_call, message.keys.first);
         //data.pools = [Pool.fromString(_call2)];
          eventModel = EventModel('error', _call, message.keys.first);
        }
        else{
          data = _call;
          eventModel = EventModel('error', _call, message.keys.first);
        }
      //  Pool pool = Pool.fromString(_call2); //TODO do regexp
        //parse data
        //return event device
      }
      else {
        String _call = await Api.sendCommand(
            message.keys.first, 4028, message.values.first, 10);
        if(_call.contains('STATUS=')) {
          eventModel = EventModel('error', _call, message.keys.first);
        }
        else{
          eventModel = EventModel('error', _call, message.keys.first);
        }
        //parse data
        //return event
      }

       */
    } else if (message == null) {
      // Exit if the main isolate sends a null message, indicating there are no
      // more files to read and parse.
      break;
    }

  }
  Isolate.exit();
}