import 'dart:async';

import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/graphic_section/total_stats.dart';
import 'package:AllMinerMonitor/isolates/layout_scanner.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:AllMinerMonitor/utils/bindings.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_layout.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout/layout_list_controller.dart';
import 'package:AllMinerMonitor/visual_layout/more_dialog.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../visual_layout_container/container_layout.dart';

class LayoutTileController extends GetxController with GetSingleTickerProviderStateMixin{
  Layout layout;
  LayoutTileController(this.layout);
  late AnimationController animationController;
  late final Animation<double> _animation;
  final LayoutListController controller = Get.find();
  final LayoutScanner layoutScanner = Get.find();
//  final Scanner scanner = Get.put(Scanner());
  RxDouble progress = 0.0.obs;
  RxBool isMenuOpen = false.obs;
  RxList<dynamic> devices = [].obs;
  int jobsDone = 0;
  RxDouble speedSCRYPT = 0.0.obs;
  RxDouble speedSHA256 = 0.0.obs;
  RxDouble speedAvgSCRYPT = 0.0.obs;
  RxDouble speedAvgSHA256 = 0.0.obs;
  RxInt deviceCountSCRYPT = 0.obs;
  RxInt deviceCountSHA256 = 0.obs;
//  StreamSubscription? scanResultSub;
  int _counter = 0;
  RxInt scannedDevices = 0.obs;
  RxInt withProblems = 0.obs;
  StreamController scanInProgressStream = StreamController<int>();
  RxBool isActive = false.obs;
  RxList<String> totalErrors = <String>[].obs;
  RxList<String> speedErrors = <String>[].obs;
  RxList<String> fanErrors = <String>[].obs;
  RxList<String> tempErrors = <String>[].obs;
  RxList<String> chipCountErrors = <String>[].obs;
  RxList<String> hashCountErrors = <String>[].obs;
  RxList<String> chipsSErrors = <String>[].obs;
  RxInt viewMode = 0.obs;
  RxString lastScanTime = ''.obs;
  bool isManualScan = false;
  Rx<DeviceModel> newDevice = DeviceModel().obs;
  RxBool clearQuery = false.obs;
  late Box boxLayouts;
  late Box boxStats;
  @override
  void onInit() async{
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.stop();
    ///watch for layout changes
    boxLayouts = await Hive.openBox('layouts');
    boxStats = await Hive.openBox('stats_${layout.tag}');
    print(boxStats);
    boxLayouts.watch(key: layout.tag).listen((event) {handleLayoutChange(event);});
    ///listen to scan results with tag
   // scanResultSub==null? scanResultSub = scanner.scanResult.stream.listen((event) async {await handleScanResult(event);}) : null;

    layoutScanner.scanResult.listen((event) async{await handleScanResult(event);});
    layoutScanner.scanCompletedTag.listen((tag) async{await handleScanComplete(tag);});
    controller.startScanTag.listen((tag) async{await handleStartScan(tag);});
    super.onInit();
  }
  handleLayoutChange(BoxEvent event){
    debug(subject: 'box event', message: 'key: ${event.key}, content: ${event.value}', function: 'layout_tile > handleLayoutChange ');
    if(event.value!=null) {
      layout = event.value;
    }
  }
  handleStartScan(String tag) async{
    if(tag == layout.tag) {
      await scan(false);
    }
  }
  handleScanComplete(String tag) async{
    if(tag == layout.tag) {
      debug(subject: 'scan completed', message: 'tag: $tag, progress: ${progress.value}', function: 'layout_tile > handleScanComplete ');
      isActive.value = false;
      animationController.stop();
      if (progress.value >= 1.0){

    //    scanInProgressStream.add(_counter);
     //   _counter++;
        DateFormat dateFormat = DateFormat.Hm()
            .add_yMd();
        String date = dateFormat.format(DateTime.now());
        lastScanTime.value = date;
        await writeToLog();
        debug(subject: 'call on scan complete',
            message: 'isManual: $isManualScan',
            function: 'layout_tile > handleScanResult > progress>=1');

     //   controller.onScanComplete(true, layout.tag!);
        /*
        if (tag.values.first) {
          controller.onScanComplete(true, layout.tag!);
        }
        else {
          //   await Future.delayed(const Duration(seconds: 1));
          controller.onScanComplete(false, layout.tag!);
        }


         */
      }
    }
  }
  handleScanResult(EventModel event)  async {
    if(event.tag!=null && event.tag==layout.tag) {
      if (event.type == 'device') {
        debug(subject: 'got device', message: 'ip: ${event.ip}', function: 'layout_tile > handleScanResult ');
        devices.add(event.data);
        newDevice.value = event.data;
        scannedDevices.value++;
        ///count errors
        try {
          if (event.data.speedError) {
            speedErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
          if (event.data.fanError) {
            fanErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
          if (event.data.tempError) {
            tempErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
          if (event.data.chipCountError) {
            chipCountErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
          if (event.data.hashCountError) {
            hashCountErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
          if (event.data.chipsSError) {
            chipsSErrors.add(event.data.ip);
            !totalErrors.contains(event.data.ip) ? totalErrors.add(
                event.data.ip) : null;
          }
        }
        catch(e){
          debug(subject: 'catch error', message: '$e', function: 'layout_tile > handleScanResult > count errors');
        }
        /// summary
        if (event.data.isScrypt == true) {
          deviceCountSCRYPT.value++;
          speedSCRYPT.value += event.data.currentSpeed;
          speedAvgSCRYPT.value = speedSCRYPT.value / deviceCountSCRYPT.value;
        }
        else {
          deviceCountSHA256.value++;
          speedSHA256.value += event.data.currentSpeed;
          speedAvgSHA256.value = speedSHA256.value / deviceCountSHA256.value;
        }
      }
/*
      else if(event.type=='abort'){
        if(isActive.value) {
          debug(subject: 'got abort',
              message: 'tag: ${event.tag}',
              function: 'layout_tile > handleScanResult');
          Get.snackbar('ABORT', "next scan command");
          scanInProgressStream.add(_counter);
          _counter++;
          isActive.value = false;
          await Future.delayed(const Duration(seconds: 1));
          controller.onScanComplete(true, layout.tag!);
        }



      }
 */
  //    await Future.delayed(const Duration(seconds: 1));
      jobsDone++;
      progress.value = jobsDone / layout.ips!.length;
      debug(subject: 'scan progress', message: 'progress: ${progress.value}', function: 'layout_tile > handleScanResult');


      /*
      if(isActive.value) {
        if (progress.value >= 1.0) {
          scanInProgressStream.add(_counter);
          _counter++;
          DateFormat dateFormat = DateFormat.Hm()
              .add_yMd();
          String date = dateFormat.format(DateTime.now());
          lastScanTime.value = date;
          await writeToLog();
          debug(subject: 'call on scan complete',
              message: 'isManual: $isManualScan',
              function: 'layout_tile > handleScanResult > progress>=1');
          if (isManualScan) {
            controller.onScanComplete(true, layout.tag!);
          }
          else {
            await Future.delayed(const Duration(seconds: 1));
            controller.onScanComplete(false, layout.tag!);
          }
       //   isActive.value = false;
        }
      }


       */


    }

  }
  writeToLog()  async{
    Map<String,Object> _total ={'date': lastScanTime.value, 'name':'total devices', 'value': scannedDevices.value};
    Map<String,Object> _speedSHA ={'date': lastScanTime.value, 'name':'speed SHA256', 'value':  speedSHA256.value};
    Map<String,Object> _speedScrypt ={'date': lastScanTime.value, 'name':'speed SCRYPT', 'value': (speedSCRYPT.value/1000).toPrecision(2)};
    Map<String,Object> _totalErrors ={'date': lastScanTime.value, 'name':'total errors', 'value': totalErrors.length};
    Map<String,Object> _tempErrors ={'date': lastScanTime.value, 'name':'temp errors', 'value': tempErrors.length};
    Map<String,Object> _fanErrors ={'date': lastScanTime.value, 'name':'fan errors', 'value': fanErrors.length};
    Map<String,Object> _speedErrors ={'date': lastScanTime.value, 'name':'speed errors', 'value': speedErrors.length};
    Map<String,Object> _chipErrors ={'date': lastScanTime.value, 'name':'chip errors', 'value': chipCountErrors.length};
    Map<String,Object> _hashErrors ={'date': lastScanTime.value, 'name':'hashboard errors', 'value': hashCountErrors.length};

    boxStats.add(_total);
    boxStats.add(_speedSHA);
    boxStats.add(_speedScrypt);
    boxStats.add(_totalErrors);
    boxStats.add(_tempErrors);
    boxStats.add(_fanErrors);
    boxStats.add(_speedErrors);
    boxStats.add(_chipErrors);
    boxStats.add(_hashErrors);
  }

  scan(bool _isManual) async {
  //  await Future.delayed(Duration(milliseconds: 500));
    if(!isActive.value) {
      isActive.value = true;
      debug(subject: 'start scan',
          message: 'tag: ${layout.tag}, isManual: $_isManual, ips: ${layout.ips}',
          function: 'layout_tile > scan');
      await clearSummary();

      isManualScan = _isManual;

      animationController.repeat();
     // scanInProgressStream.add(_counter);
     // _counter++;

      if (layout.ips!.isNotEmpty) {
        // scanlistController.clearQuery();
        await layoutScanner.scan(ips: layout.ips!, tag: layout.tag, isManual: _isManual);
        // await scanner.newScan(ips: layout.ips, tg: layout.tag,);
      }
    }
  }
  clearSummary()async{
    clearQuery.value = true;
    _counter = 0;
    jobsDone = 0;
    progress.value = 0.0;
    devices.clear();
    scannedDevices.value = 0;
    speedSCRYPT.value = 0;
    speedAvgSCRYPT.value = 0;
    speedAvgSHA256.value = 0;
    speedSHA256.value = 0;
    deviceCountSCRYPT.value = 0;
    deviceCountSHA256.value = 0;
    totalErrors.clear();
    speedErrors.clear();
    fanErrors.clear();
    tempErrors.clear();
    hashCountErrors.clear();
    chipCountErrors.clear();
    chipsSErrors.clear();
    clearQuery.value = false;
   // await Future.delayed(const Duration(seconds: 1));
    debug(subject: 'clear data', message: 'finish clear', function: 'layout_tile > clearSummary');
  }
  switchMode(){
    viewMode.value==0? viewMode.value = 1 : viewMode.value = 0;
  }
  showMore(){
    List<List<String>> _tmp =[
      tempErrors,
      fanErrors,
      speedErrors,
      hashCountErrors,
      chipCountErrors,
      chipsSErrors
    ];

    Get.defaultDialog(
      title: 'ip_list'.tr,
      content: MoreDialog(_tmp, layout.tag??''),
    );
  }
  onEditTagClick(){
    controller.onEditTagClick(layout.tag);
  }
  editLayout(){
    Get.to(()=>ConstructorLayout(tag: layout.tag,)); //TODO add bindings
  }
  deleteLayout(){
    controller.deleteLayout(layout.tag);
  }
  openLayout(){
    Get.to(()=> const ContainerLayout(), binding: LayoutBinding(), arguments: [layout, lastScanTime.value]); //TODO adn pass result if ready
  }
  openMenu(){
    isMenuOpen.value=true;
  }
  closeMenu(){
    isMenuOpen.value=false;
  }
  showGraphs(){
  //  TotalStatsController totalStatsController = Get.put(TotalStatsController(layout.tag!), tag: layout.tag);
    Get.dialog(TotalStats(layout.tag!));
  }
}