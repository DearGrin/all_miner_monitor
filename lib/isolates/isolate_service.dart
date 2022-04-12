import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/avalon_10xx/mock_rasp.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:hive/hive.dart';

//var filenames = [];

void startCompute(List<String> f, List<String> commands,
    StreamController eventStream, StreamController stopStream) async{
  //filenames = f;
  /*
  Box box = await Hive.openBox('settings');
  int _threads =  box.get('max_threads')??20;
  int maxTasks = (f.length/_threads).ceil();
  List<List<String>> tasksByThread = [];
  for(int i = 0; i < _threads; i++)
  {
    List<String> _ = f.skip(i*maxTasks).take(maxTasks).toList();
    if(_.length>0){
    tasksByThread.add(_);
    }
  }
  print(tasksByThread.length);
  for(int i =0; i < tasksByThread.length; i++)
  {
    await for (final jsonData in _sendAndReceive(tasksByThread[i])) {
      print('Received JSON $i with ${jsonData.toString()} keys');
  }

   */
  await for (final result in _sendAndReceive(f, commands, stopStream)) {
   // print('Received JSON with ${jsonData.toString()} keys');
    eventStream.add(result);
  }
}
Stream<EventModel> _sendAndReceive(List<String> filenames, List<String> commands,
    StreamController stopStream) async* {



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

  stopStream.stream.listen((event){
    toFinish = true;
  });

  for(int i = 0; i < filenames.length; i++){
    // Send the next filename to be read and parsed
    if(toFinish){
      break;
    }
    if(commands.length>1) {
      sendPort.send({'${filenames[i]}': '${commands[i]}'});
    }
    else{
      sendPort.send({'${filenames[i]}': '${commands[0]}'});
    }
    // Receive the parsed JSON
    EventModel message = await events.next;

    // Add the result to the stream returned by this async* function.
    yield message;
  }
  /*
  for (var filename in filenames) { //TODO get data here
    // Send the next filename to be read and parsed
    sendPort.send({'$filename':commands[0]});

    // Receive the parsed JSON
    String message = await events.next;

    // Add the result to the stream returned by this async* function.
    yield message;
  }

   */

  // Send a signal to the spawned isolate indicating that it should exit.
  sendPort.send(null);

  // Dispose the StreamQueue.
  await events.cancel();
}
Future<void> sendCommand(SendPort p) async{
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);
  EventModel eventModel = EventModel('error', 'empty event', 'fail', 'event was not initialised');
  dynamic device;
  /*
  handleCallback(SendPort p, EventModel eventModel){
    p.send(eventModel);
  }

   */
  handler2(SendPort p, String data, String ip, dynamic device){
    //Pool pool = Pool.fromString(data);

    eventModel = EventModel('device', device, ip, data); //TODO
  }
  handler(SendPort p, String data, String command, String ip) async {



    if(command=='estats'){

      if(data.contains('ID=AVA1')) {
        try{
          device = AvalonData.fromString(data, ip);
       //   eventModel = EventModel('device', device, ip, data);
        }
        catch(e){
          eventModel = EventModel('error', e.toString(),ip, data);
        }
        //   AvalonData device = AvalonData.fromString(data, ip);
        //data.pools = [Pool.fromString(_call2)];
        //eventModel = EventModel('device', device, ip);
      }
      else if (data.contains('ID=AV')){
        try {
          device = RaspberryAva.fromString(data, ip);
     //     eventModel = EventModel('device', device, ip, data);
        }
        catch(e){
          eventModel = EventModel('error', e.toString(),ip, data);
        }
        //data.pools = [Pool.fromString(_call2)];
        //  eventModel = EventModel('device', data, ip);
      }
      else{
        data = data;
        eventModel = EventModel('error', data,ip, data); //TODO unknown device
      }
    //  RaspberryAva device = RaspberryAva.fromString(mockRasp, ip);

      //eventModel = EventModel('device', device, ip);

      try {
        Socket socket = await Socket.connect(
            ip, 4028, timeout: const Duration(seconds: 5));
        socket.listen((dynamic event) {
          //handleCallback(event.toString());
          // handleCallback(p, EventModel('error', utf8.decode(event), message.keys.first));
          handler2(p, utf8.decode(event), ip, device);
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
    }
    else{
      if(data.contains('STATUS=')) {
        eventModel = EventModel('update', data, ip, data);
      }
      else{
        eventModel = EventModel('error', data, ip, data);
      }
    }
    p.send(eventModel);
  }
  await for (final message in commandPort) {
    if (message is Map<String,String>) {
      // TODO do the logic here
      dynamic data;
      EventModel? eventModel;
      try {
        Socket socket = await Socket.connect(
            message.keys.first, 4028, timeout: const Duration(seconds: 5));
        socket.listen((dynamic event) {
          //handleCallback(event.toString());
         // handleCallback(p, EventModel('error', utf8.decode(event), message.keys.first));
          handler(p, utf8.decode(event), message.values.first,  message.keys.first);
          data = utf8.decode(event);
         // eventModel = EventModel('error', data, message.keys.first);
          //   eventStream.add(event.toString());
         // data = event.toString();
          socket.close();
        });
        socket.add(utf8.encode(message.values.first));
      }
      catch(err){
        data = '$err';
        eventModel = EventModel('error', data, message.keys.first, data);
        handler(p, mockRasp, message.values.first,  message.keys.first);
        //p.send(eventModel);
        // callback = mockData;
      }
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
      //TODO than parse
      //print(message);
      //Future.delayed(Duration(seconds: 1));
      // Send the result to the main isolate.
     // await Future.delayed(Duration(seconds: 5));
     // p.send(eventModel);
    } else if (message == null) {
      // Exit if the main isolate sends a null message, indicating there are no
      // more files to read and parse.
      break;
    }

  }
  Isolate.exit();
}