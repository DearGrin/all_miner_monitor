import 'dart:async';

import 'package:avalon_tool/antminer/antminer_model.dart';
import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/miner_overview/miner_overview_screen.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/command_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController{
  Rx<Layout> layout = Layout().obs;
  List<dynamic> devices = <dynamic>[];
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
  StreamController scanProgressStream = StreamController<bool>.broadcast();
  StreamController scanInProgressStream = StreamController<bool>.broadcast();
  @override
  void onClose() {
    // TODO: implement onClose
    sub?.cancel();
    super.onClose();
  }
  @override
  Future<void> onInit() async {
     //TODO get the tag
    layout.value = Get.arguments;
    for(var r in layout.value.rigs!){
     if(r.shelves!=null && r.shelves!.length>maxRow){
       maxRow = r.shelves!.length;
     }
    }
   sub == null? sub = scanner.scanResult.stream.listen((event) {handleEvent(event);}):null;

    //TODO start scan - from where should get ip?
    //await startScan();
    await startScan();
    update(['rigs_builder']);
    super.onInit();
  }

  handleEvent(EventModel event){
    if(event.type == 'device'){
        devices.add(event.data);
    }
    jobsDone++;
    if(jobsDone>=finalProgress){
      scanProgressStream.add(true);
      scanInProgressStream.add(false);
    }
  }
  getDevice(Place place, int placeIndex){
    dynamic device;
    if(place.type=='miner'){
      device = devices.firstWhere((element) => element.ip==place.ip);
    }
    else{
      try {
        final RaspberryAva _rasp = devices.firstWhere((element) =>
        element.ip == place.ip);
        final _auc = _rasp.devices?.where((element) =>
        element.aucN == place.aucN).toList();
        device = _auc?[placeIndex];
      }
      catch(e){
        print(e);
      }
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
   // scanProgressStream.add(true);
  }
  onSingleTap(Offset? _offset, dynamic device){
    currentDevice = device;
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
  /*
  List<PlaceLayout> getPlacesInRow(int rigIndex, int rowIndex){
    List<PlaceLayout> _tmp = [];
    for(PlaceLayout p in layoutModel.value.places!){
      if(p.rigIndex==rigIndex&&p.rowIndex==rowIndex){
        _tmp.add(p);
      }
    }
    return _tmp;
  }

   */
  /*
  dynamic getDevice(PlaceLayout? place) {
    dynamic _device;
    if (place != null) {
      if (place.aucIndex == null) { // is simple device
        try {
          _device = devices.firstWhere((element) =>
          element.ip == place.ip);
        }
        catch(e){
         print(e);
        }
      }
      else { //is raspberryPi
        try {
          RaspberryAva _rasp = devices.firstWhere((element) =>
          element.ip == place.ip);
          dynamic _auc = _rasp.devices?.where((element) =>
          element.aucN ==
              place.aucIndex); //TODO check index and # it might fail
          if (_auc != null && _auc.length > place.placeIndex) {
             _device = _auc[place.placeIndex];
          }
        }
        catch(e){
          print(e);
        }
      }
    }
    return _device;
  }
  startScan() async {
    await Future.delayed(const Duration(seconds: 5));
    scanProgressStream.add(true);
  }

   */

}