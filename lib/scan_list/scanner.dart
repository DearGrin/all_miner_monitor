import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:avalon_tool/isolates/isolate_service.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

class Scanner extends GetxController{
  final Api api = Api();
  final CommandConstructor command = CommandConstructor();
  final int threadMax = 10; //TODO should change via settings?
  //bool isFinished = false;
 // int threadsInP = 0;
  //int threadsDone = 0;
 // List<AvalonData?> data = <AvalonData>[];
  StreamController scanResult = StreamController<dynamic>.broadcast();
  StreamController computeStatus = StreamController<String>();
  StreamController progressStream = StreamController<double>();
  StreamController isolateStream = StreamController<EventModel>();
  StreamController stopStream = StreamController<bool>.broadcast();
  int currentIndex = 0;
  List<int> start = [];
  List<int> end = [];
  List<Pool> pools = [];
  //List<dynamic> commands = [];
 // bool canStart = true;
  //List<Function> toScan = [];
  //List<Function> toChangePool = [];
  late StreamSubscription sub;
  int finalProgress = 0;
  int jobsDone = 0;
  @override
  void onInit(){
    sub = computeStatus.stream.listen((event) {
      //nextCompute(event);
      currentIndex++;
      print(currentIndex);
    });
    isolateStream.stream.listen((event) {
      currentIndex++;
      handledevice(event);
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
handledevice(EventModel event){
      jobsDone++;
      double _progress = jobsDone/finalProgress;
      progressStream.add(_progress);
      scanResult.add(event);

}
  universalCreate(List<String?>? ips, List<String> commands) async {
   // commands.clear();
      // await compute(_toDo[i],'');
      //final p = ReceivePort();
    if(ips!=null) {
      finalProgress = ips.length;
      jobsDone = 0;
      Box box = await Hive.openBox('settings');
      int _threads = box.get('max_threads') ?? 20;
      int maxTasks = (ips.length / _threads).ceil();
      List<List<String?>> tasksByThread = [];
      List<List<String>> commandsByThread = [];
      for (int i = 0; i < _threads; i++) {
        List<String?> _ = ips.skip(i * maxTasks).take(maxTasks).toList();
        if (commands.length > 1) {
          List<String> _c = commands.skip(i * maxTasks).take(maxTasks).toList();
          commandsByThread.add(_c);
        }
        else {
          commandsByThread.add(commands);
        }
        if (_.isNotEmpty) {
          tasksByThread.add(_);
        }
      }
      stopStream.add(true);
      for (int i = 0; i < tasksByThread.length; i++) {
        //print(commandsByThread[i]);
        startCompute(
            tasksByThread[i], commandsByThread[i], isolateStream, stopStream);
      }
    }

      //await Isolate.spawn(go, [p.sendPort,_toDo[i]]);
     // String callback = await p.first as String;
     // print(callback);
      /*
      commands.add(
              () async {await compute(_toDo[i],'').whenComplete(() =>
          currentIndex<toScan.length? computeStatus.add('next') : null
          )
          ;}
      );


       */

       /*
      commands.add(
              () async {await compute(_toDo[i],'').then((callback) =>
          currentIndex<toScan.length?
          handleCallback(callback, ips[i])
              : null
          )
          ;}
      );
      */

    //executeCommand();
  }
/*
  executeCommand(){
    clearQuery();
    finalProgress = commands.length;
    for(int i = 0; i < threadMax; i++)
    {

      computeStatus.add('next');
    }
  }


 */
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
/*
  nextCompute(String event){

    if(currentIndex<toScan.length){
      jobsDone++;
    }
    progressStream.add(jobsDone/finalProgress);
    switch(event){
      case 'scan':
        currentIndex<toScan.length? toScan[currentIndex]() : null;
        break;
      case 'pool':
        currentIndex<toChangePool.length? toChangePool[currentIndex]() : null;
        break;
      case 'next':
        currentIndex<commands.length?
        commands[currentIndex]() : null;
        break;
      default :
        break;
    }
  }


 */

  newScan(List<IpRangeModel> scanList) async {
    clearQuery();
   // List<dynamic> _toDo = [];
    List<String> _ips = [];
    for(int i = 0; i < scanList.length; i++)
    {
      List<int>? _start = scanList[i].startIp?.split('.').map((e) => int.tryParse(e)!).toList();
      List<int>? _end = scanList[i].endIp?.split('.').map((e) => int.tryParse(e)!).toList();
      while(_start![3] <= _end![3]) {
        String _ip = _start[0].toString() + '.' + _start[1].toString() + '.' +
            _start[2].toString() + '.' + _start[3].toString();

     //  toScan.add((){createComputeScan(_ip);});

      //_toDo.add(Api.sendCommand(_ip, 4028, command.getStats(), 1));
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
     // List<String> _ = [command.getStats()];
    //  for(var element in _ips){_toDo.add(Api.sendCommand(element, 4028, command.getPools(), 1));}

/*
      finalProgress = toScan.length;

      for(int i = 0; i < threadMax; i++)
      {
        computeStatus.add('scan');
      }


 */
    }
    universalCreate(_ips, ['stats|debug']);
  }
/*
startToChangePools(List<String> ips, List<Pool> _pools){
    clearQuery();
    pools = _pools;
    List<dynamic> _toDo = [];
    List<String> _ips = [];
    List<String> commands = [];
    for(int i = 0; i < ips.length; i++)
      {
        String _ad = _pools[0].addr.toString() + ':'+ _pools[0].port.toString();
        _toDo.add(Api.sendCommand(ips[i], 4028, command.setPools(
            'root', 'root', _ad, _pools[0].worker??'', _pools[0].passwd??''
        ), 1));
        commands.add(command.setPools(
            'root', 'root', _ad, _pools[0].worker??'', _pools[0].passwd??''
        ));
        _ips.add(ips[i]);
      // toChangePool.add(createComputeChangePool(ips[i]));
      }

    universalCreate(_ips, commands);
    /*
    finalProgress = toChangePool.length;
    for(int i = 0; i < threadMax; i++)
    {
      computeStatus.add('pool');
    }
    */
}


 */

/*
createComputeScan(String ip) async {
     await compute(singleScan, ip).whenComplete(() =>
        currentIndex<toScan.length? computeStatus.add('scan') : null);
}
  //Future<AvalonData>
   singleScan(String ip) async{
    AvalonData _device = AvalonData.fromString(mockData, ip);
    //TODO get pool also
    _device.pools = [Pool(addr: 'stratum lala',port: '1883', worker: 'test.13',)];
    String _ = await rootBundle.loadString('lib/assets/log_rasp.txt');
    RaspberryAva _raspDevice = RaspberryAva.fromString(_, ip);
    _raspDevice.pools = [Pool(addr: 'stratum lala',port: '1883', worker: 'test.13',)];
    scanResult.add(_device);
    scanResult.add(_raspDevice);
    //return _device;
  }


 */
  /*
createComputeChangePool(String ip) async{
    await compute(singlePoolChange, ip).whenComplete(() =>
    currentIndex<toChangePool.length? computeStatus.add('pool') : null);
    //TODO callback for status
}
Future<void>singlePoolChange(String ip)async {
    //TODO make a call to api and all the checks
  }


   */






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
/*
  getListToScan() {

    while(start[3] <= end[3]) {
        String _ip = start[0].toString() + '.' + start[1].toString() + '.' +
            start[2].toString() + '.' + start[3].toString();
        ipToScan.add(_ip);
        toScan.add(createCompute(_ip));
        if (start[3] != end[3]) {
          start[3]++;
        }
        else {
          if (start[2] < end[2]) {
            start[3] = 1;
            start[2] ++;
          }
          else {
            start[3]++;
          }
        }
      }
    streamController2.stream.listen((event) {
     // print(event);

     // print(currentIndex.toString());
     // doC(event);
      ipToScan[currentIndex];
      currentIndex++;
    });
      for(int i = 0; i < threadMax; i++)
        {
          streamController2.add(ipToScan[i]);
        //  currentIndex = i+1;
        }
      /*
      while(!isFinished)
        {
         streamController2.add(ipToScan[currentIndex]);
         currentIndex++;
        }
      ipToScan.forEach((element) async {
        threadsInP++;
        if(threadsInP<threadMax)
          {
            AvalonData _ = await compute(singleScan, element);
            data.add(_);
            streamController.add(_);
            threadsInP--;
          }
        else{

        }
        });


       */
    }

   */
/*
addData(AvalonData _data){
    data.add(_data);
    //print(data.length);
}

 */


  /*
  startToScan(String startIp, String endIp){
    isFinished = false;
    start = startIp.split('.').map((e) => int.tryParse(e)!).toList();
    end = endIp.split('.').map((e) => int.tryParse(e)!).toList();
    getListToScan();
   /*
    while(!isFinished)
      {
       // print('is while');
        scan();
      }


    */
  }

   */
  /*
   scan() {
    //print(threads.toString());
    if(start[3]<=end[3] && canStart){
    //  print('done  $threadsDone');
      //print(threadsInP.toString());
      String _ip = start[0].toString() + '.' + start[1].toString() + '.' + start[2].toString() + '.' + start[3].toString();
      if(start[3]!=end[3]) {
        start[3]++;
      }
      else{
        if(start[2]<end[2]) {
          start[3] = 1;
          start[2] ++;
        }
        else{
          start[3]++;
          isFinished = true;
          //print('is fin');
          //print(data.length);
        }
      }
      startCompute(_ip);
     threadsInP ++;
    }
  //  print('start scan');
   // print(validateIp(startIp));
   // List<AvalonData> _tmp = [];
    /*
    if(validateIp(startIp)&&validateIp(endIp))
      {
        List<int> start = startIp.split('.').map((e) => int.tryParse(e)!).toList();

        List<int> end = endIp.split('.').map((e) => int.tryParse(e)!).toList();

        if(end[0]>=start[0]&&end[1]>=start[1]&&end[2]>=start[2]&&end[3]>=start[3])
          {
            print('ok to go');
           // int threads = 0;
            isFinished = false;


          }
      }

     */
  }

   */
  /*
  startCompute(String _ip) async {
    var r = await compute(singleScan, _ip);

    /*
    await compute(singleScan, _ip).then(
            (AvalonData? info) {
            //  print('finished single scan');
          if(info!=null)
          {
            data.add(info);
            //threads --;
          }
          print('smome thins');
          //threads --;
          //print('threads - $threads');
          //threadsDone ++;
        }
    );


     */
    threadsDone ++;
    canStart = threadsInP-threadsDone<threadMax?true:false;
   // print('done  $threadsDone');

  }


   */
}