import 'dart:async';

import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/mock_data.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/miner_overview/miner_overview_screen.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:AllMinerMonitor/scan_list/scanner.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../visual_layout_container/command_dialog.dart';

class LayoutController extends GetxController{
  Rx<Layout> layout = Layout().obs;
  RxList<dynamic> devices = <dynamic>[].obs;
  List<dynamic> selectedDevices = <dynamic>[];
  Offset position = const Offset(0,0);
  dynamic currentDevice;
  //final ScanListController scanListController = Get.find();
  final Scanner scanner = Get.find();
  final StreamController<String> resizeStream = StreamController<String>.broadcast();
  StreamSubscription? sub;
  int finalProgress = 0;
  int jobsDone = 0;
  int maxRow = 0;
  Rx<Offset> offset = Offset(0, 0).obs;
  RxInt displayPopup = 0.obs;
  String? currentIp;
  StreamController scanProgressStream = StreamController<bool>.broadcast();
  RxBool scanIsActive = false.obs;
  RxString lastScan = ''.obs;
  RxString newIp = ''.obs;
  RxBool clearQuery = false.obs;
  Rx<DeviceModel> newDevice = DeviceModel().obs;
  late LayoutTileController controller;
  @override
  void onClose() {
    // TODO: implement onClose
    sub?.cancel();
    super.onClose();
  }
  @override
  Future<void> onInit() async {
     //TODO get the tag
    layout.value = Get.arguments[0];
    lastScan.value = Get.arguments[1];
    controller = Get.find(tag: layout.value.tag);
    controller.lastScanTime.listen((_lastScan) {lastScan.value=_lastScan; });
    devices = controller.devices;
    scanProgressStream.add(true);
    //controller.devices.listen((_device) {handleDevice(_device);});
   // controller.isActive.listen((scanFinished) {scanFinished? scanProgressStream.add(true) : null;});
    controller.newDevice.listen((device) async{handleDevice(device);});
    scanIsActive.value = controller.isActive.value;
    controller.isActive.listen((event) {handleIsActive(event);});
    controller.clearQuery.listen((event) {clearData(event);});
    for(var r in layout.value.rigs!){
     if(r.shelves!=null && r.shelves!.length>maxRow){
       maxRow = r.shelves!.length;
     }
    }
  // sub == null? sub = scanner.scanResult.stream.listen((event) {handleEvent(event);}):null;

    //TODO start scan - from where should get ip?
    //await startScan();
   // await startScan();
    update(['rigs_builder']);
    super.onInit();
  }
  clearData(bool event){
    print('clear in layout');
    clearQuery.value = event;
    if(event){
      devices.clear();
    }
  }
  handleIsActive(bool _isActive){
    print('handle is $_isActive');
    scanIsActive.value = _isActive;
  }
  handleDevice(DeviceModel _device)async{
    debug(subject: 'got device', message: 'ip: ${_device.ip}', function: 'layout_controller > handleDevice ');
  //  devices.add(_device);
   // newIp.value = _device.ip!;
    newDevice.value = _device;
  }
  /*
  handleEvent(EventModel event){
    if(event.type == 'device'){
        devices.add(event.data);
    }
    jobsDone++;
    if(jobsDone>=finalProgress){
      scanProgressStream.add(true);
      scanIsActive.value = false;
    }
  }
  */

  Future<dynamic>getDevice(Place place, int placeIndex)async{
    debug(subject: 'get device', message: 'ip: ${place.ip}, placeIndex: $placeIndex', function: 'layout_controller > getDevice ');
    dynamic device;
    if(devices.isNotEmpty) {
      if (place.type == 'miner') {
        device = devices.firstWhere((element) => element.ip == place.ip);
      }
      else {
        try {
          final RaspberryAva _rasp = devices.firstWhere((element) =>
          element.ip == place.ip).data;
          print('rasp is $_rasp');
          final _auc = _rasp.devices?.where((element) =>
          element.data.aucN == place.aucN).toList();
          device = _auc ? [placeIndex];
        }
        catch (e) {
          debug(subject: 'catch error',
              message: '$e',
              function: 'layout_controller > getDevice');
        }
      }
      debug(subject: 'get device',
          message: 'ip: ${place.ip}, placeIndex: $placeIndex, device: $device',
          function: 'layout_controller > getDevice ');
    }
    return device;
  }



  /*
  onDoubleTap(dynamic device){
    Get.to(()=>const MinerOverviewScreen(), arguments: device);
    if(device.runtimeType==AvalonData) {
      scanlistController.currentDevice.value = device;
    //  Get.dialog(const OverviewScreen(type: 'avalon',));
    }
    else if(device.runtimeType==AntMinerModel){
      scanlistController.currentAntDevice.value = device;
  //    Get.dialog(const OverviewScreen(type: 'antminer',));
    }
    else{
      //TODO add unknown support
    }
    //scanlistController.currentDevice.value = device;
    //scanlistController.currentDevice.value = AvalonData.fromString(mockData, '10.10');
    //print(scanlistController.currentDevice.value);
    //Get.to(()=>const OverviewScreen());
  }

   */
  onRefresh() async {
    await startScan();
  }
  startScan() async {
   // await Future.delayed(const Duration(seconds: 5));
    controller.scan(true);
    /*
    jobsDone = 0;
    finalProgress = layout.value.ips!.length;
    if(layout.value.ips!.isNotEmpty) {
      print('ip is not empty');
  //    scanListController.clearQuery();
      scanner.newScan(ips: layout.value.ips);
    //  scanner.universalCreate(layout.value.ips, ['estats']);
      scanInProgressStream.add(true);
    }
    else{
      print('need to stop');
      await Future.delayed(Duration(seconds: 3));
      scanInProgressStream.add(false);
    }

     */
   // scanProgressStream.add(true);
  }
  onSingleTap(Offset? _offset, dynamic device){
    displayPopup.value = 0;
    currentDevice = device;
    if(_offset!=null) {
      offset.value = _offset;
    }
  }
  onSingleSecondaryTap(Offset? _offset, String? ip){
    displayPopup.value = 1;
    currentIp = ip;
    if(_offset!=null) {
      offset.value = _offset;
    }
  }
  closePopup(){
    offset.value = const Offset(0, 0);
  }
  zoomIn(){
    resizeStream.add('in');
  }
  zoomOut(){
    resizeStream.add('out');
  }
  onCommandClick(){
    Get.defaultDialog(
      title: '',
      content: const CommandDialog(),
    );
  }
  addSelectedDevice(){
    if(currentIp!=null && devices.isNotEmpty) {
      dynamic _device = devices.firstWhere((element) =>
      element.ip == currentIp!);
      if(_device!=null) {
        if(selectedDevices.contains(_device))
        {
          selectedDevices.remove(_device);
        }
        else{
          selectedDevices.add(_device);
        }
      }
    }
  }
  openInBrowser()async{
    if(currentIp!=null) {
      String _ip = currentIp!;
      final Uri _url = Uri.parse('http://$_ip');
      if (!await launchUrl(_url)) throw 'Could not launch $_ip';
    }
  }
}