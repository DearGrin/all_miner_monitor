import 'dart:async';


import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../visual_layout_container/command_dialog.dart';

class LayoutController extends GetxController{
  Rx<Layout> layout = Layout().obs;
  RxList<dynamic> devices = <dynamic>[].obs;
  List<dynamic> selectedDevices = <dynamic>[];
  Offset position = const Offset(0,0);
  dynamic currentDevice;
  //final ScanListController scanListController = Get.find();
 // final Scanner scanner = Get.find();
  final StreamController<String> resizeStream = StreamController<String>.broadcast();
 // StreamSubscription? sub;
  int finalProgress = 0;
  int jobsDone = 0;
  int maxRow = 0;
  Rx<Offset> offset = Offset(0, 0).obs;
  RxInt displayPopup = 0.obs;
  String? currentIp;
//  StreamController scanProgressStream = StreamController<bool>.broadcast();
  RxBool scanIsActive = false.obs;
  RxString lastScan = ''.obs;
  RxString newIp = ''.obs;
  RxBool clearQuery = false.obs;
  Rx<DeviceModel> newDevice = DeviceModel().obs;
  int raspCount = 2;
  late LayoutTileController controller;

  @override
  Future<void> onInit() async {
    layout.value = Get.arguments[0];
    lastScan.value = Get.arguments[1];
    controller = Get.arguments[2];
    //controller = Get.find(tag: layout.value.tag);
    controller.lastScanTime.listen((_lastScan) {lastScan.value=_lastScan; });
    devices = controller.devices;
    controller.newDevice.listen((device) async{await handleDevice(device);});
    scanIsActive.value = controller.isActive.value;
    controller.isActive.listen((event) async {await handleIsActive(event);});
    controller.clearQuery.listen((event) {clearData(event);});
    Box box = await Hive.openBox('settings');
    raspCount = box.get('rasp_count')??5;
    for(var r in layout.value.rigs!){
     if(r.shelves!=null && r.shelves!.length>maxRow){
       maxRow = r.shelves!.length;
     }
    }
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
  handleIsActive(bool _isActive)async{
    debug(subject: 'is scan active', message: 'isActive: $_isActive', function: 'layout_controller > handleIsActive ');
    scanIsActive.value = _isActive;
  }
  handleDevice(DeviceModel _device)async{
    debug(subject: 'got device', message: 'ip: ${_device.ip}', function: 'layout_controller > handleDevice ');
    newDevice.value = _device;
  }

  Future<dynamic>getDevice(Place place, int placeIndex)async{
    debug(subject: 'get device', message: 'ip: ${place.ip}, placeIndex: $placeIndex', function: 'layout_controller > getDevice ');
    dynamic device;
    if(devices.isNotEmpty) {
      if (place.type == 'miner') {
        try {
          device = devices.firstWhere((element) => element.ip == place.ip);
        }
        catch(e){
          debug(subject: 'get device', message: 'error: $e', function: 'layout_controller > getDevice ');
        }
      }
      else {
        try {
          final RaspberryAva _rasp = devices.firstWhere((element) =>
          element.ip == place.ip).data;
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




  onRefresh() async {
    await startScan();
  }
  startScan() async {
    controller.scan(true);
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