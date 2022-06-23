import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:async/async.dart';

import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/pools_editor/device_pool.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';

sendAnswer(SendPort p, EventModel eventModel){
  p.send(eventModel);
}
handler(SendPort p, String data, String command, String ip, String? tag, {String? company, DeviceModel? device, Map<String,dynamic>? prevJson, required int timeout}) async {
  EventModel eventModel = EventModel('error', 'empty event', 'fail', 'event was not initialised', tag: tag);
  dynamic _device;
  DeviceModel? model;
  if(command=='estats'||command=='stats|debug'||command=='stats'){
    try {
      if (data.contains('ID=AVA1')) {
        _device = await AvalonData().fromString(data, ip);
        model = await DeviceModel().fromData(_device, ip);
        eventModel = EventModel('device', model, ip, data, tag: tag);
        sendAnswer(p, eventModel);
    //    socketSendCommand(ip, 'pools', p, device: model, tag: tag, timeout: timeout);
      }
      else if (data.contains('ID=AV')) {
        _device = await RaspberryAva().fromStr(data, ip);
        model = await DeviceModel().fromData(_device, ip);
        eventModel = EventModel('device', model, ip, data, tag: tag);
        sendAnswer(p, eventModel);
     //   socketSendCommand(ip, 'pools', p, device: model, tag: tag, timeout: timeout);
      }
      else if (data.toLowerCase().contains('antminer')) {
        String _data = data.replaceAll('"', '').replaceAll(':', '=');
        _device = await AntMinerModel().fromString(_data, ip);
        model = await DeviceModel().fromData(_device, ip);
        eventModel = EventModel('device', model, ip, data, tag: tag);
        sendAnswer(p, eventModel);
  //      socketSendCommand(ip, 'pools', p, device: model, tag: tag, timeout: timeout);
      }
      else if (data.toLowerCase().contains('whatsminer')) {

      }
      else {
        data = data;
        eventModel =
            EventModel('error', data, ip, data, tag: tag); //TODO unknown device
        sendAnswer(p, eventModel); /// exit on unknown callback
      }
    }
    catch(e){
      eventModel = EventModel('error', e.toString(),ip, data, tag: tag);
      sendAnswer(p, eventModel); /// exit on error
    }
  }
  else if (command.contains('pools')){
    Pools? _pools;
    if(command.contains('cmd')) { ///whatsminer pools
      try {
        _pools = await Pools().fromJson(jsonDecode(data));
      //  device?.pools = _pools;
        eventModel = EventModel('pools', _pools, ip, data, tag: tag);
        sendAnswer(p, eventModel);
      }
      catch (e) {
        eventModel =
            EventModel('error', e.toString(), ip, e.toString(), tag: tag);
      }
    }
    else{
      try {
        _pools = await Pools().fromString(data);
    //    device?.pools = _pools;
        eventModel = EventModel('pools', _pools, ip, data, tag: tag);
        sendAnswer(p, eventModel);
      }
      catch (e) {
        print(e);
        eventModel =
            EventModel('error', e.toString(), ip, e.toString(), tag: tag);
      }
    }
  }
}

socketSendCommand(String ip, String command, SendPort p, {DeviceModel? device,
  dynamic addCommands, String? company, List<Map<dynamic,dynamic>>? credentials,
  String? tag, Map<String,dynamic>? prevJson, required timeout}) async{
  try {
    Socket socket = await Socket.connect(
        ip, 4028, timeout: Duration(seconds: timeout));
    var sub = socket.listen((dynamic event) async {
      try {
        socket.close();
        await Future.delayed(const Duration(milliseconds: 300));
        await handler(p, utf8.decode(event), command, ip, tag, company: company,
            device: device,
            prevJson: prevJson, timeout: timeout);
      }
      catch (err) {
        EventModel eventModel = EventModel(
            'error', '$err', ip, '$err', tag: tag);
        sendAnswer(p, eventModel);
      }
    });
    socket.add(utf8.encode(command));
    await Future.delayed(const Duration(milliseconds: 300));
    await sub.asFuture<void>().timeout(
        Duration(seconds: timeout), onTimeout: () async {
      print('timeout');
      socket.close();
      throw 'timeout';
    });
  }
  catch(e){
    EventModel eventModel = EventModel('error', '$e', ip, '$e', tag: tag);
    sendAnswer(p, eventModel);
  }
}
Future<void> sendCommand(SendPort p) async{
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);
  await for (final message in commandPort) {
    if (message is Map<dynamic,dynamic>) {
      print(message);
      socketSendCommand(message['ip']??'', message['command']??'', p,
          addCommands: message['addCommand'], company: message['company'],
          credentials: message['credentials'], tag: message['tag'],
          timeout: message['timeout']
      );
    } else if (message == null) {
      // Exit if the main isolate sends a null message, indicating there are no
      // more files to read and parse.
      break;
    }
  }
  Isolate.exit();
}
Stream<EventModel> _sendAndReceive(List<String?> ips, List<String?> commands,
    StreamController stopStream, {List<dynamic>? addCommand, List<String>? company,
      List<Map<dynamic,dynamic>>? credentials, String? tag, required int timeout}) async* {

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
    if(toFinish){
      break;
    }
      sendPort.send({
        'ip':'${ips[i]}',
        'command': commands.length>1? commands[i] : commands[0],
        'addCommand': addCommand!=null? addCommand[i]:null,
        'company': '${company!=null? company[i]:null}',
        'credentials': credentials,
        'tag': tag??'',
        'timeout': timeout
      }
      );
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
void startScan(List<String?> f, List<String?> commands,
    StreamController eventStream, StreamController stopStream, {List<dynamic>? addCommand, List<String>? company, List<Map<dynamic,dynamic>>? credentials, String? tag, required int timeout}) async{
  await for (final result in _sendAndReceive(f, commands, stopStream, addCommand: addCommand, company: company, credentials: credentials, tag: tag, timeout: timeout)) {
    eventStream.add(result);
  }
}