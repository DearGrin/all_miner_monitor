import 'dart:async';

import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/overview_screen.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LayoutController extends GetxController{
  String? tag;
  final layout = Layout().obs;
  List<dynamic> devices = <dynamic>[];
  Offset position = const Offset(0,0);
  dynamic currentDevice;
  final ScanListController scanlistController = Get.put(ScanListController());
  final Scanner scanner = Get.put(Scanner());
  StreamSubscription? sub;
  int finalProgress = 0;
  int jobsDone = 0;
  /*
  final LayoutModel testModel = LayoutModel(
    tag: 'test cont',
    rigCount: 1,
    rowCount: 1,
    places: [
      PlaceLayout(ip: '10.10.10.1', rigIndex: 0, rowIndex: 0, placeIndex: 0),
      PlaceLayout(ip: '10.10.10.2', rigIndex: 0, rowIndex: 0, placeIndex: 1),
      PlaceLayout(ip: '10.10.10.3', rigIndex: 0, rowIndex: 0, placeIndex: 2),
    ],
  );
  final layoutModel = LayoutModel().obs;
  List<dynamic> devices = <dynamic>[
    AvalonData.fromString(mockData,  '10.10.10.1'),
    AvalonData.fromString(mockData,  '10.10.10.2'),
    AvalonData.fromString(mockData,  '10.10.10.3'),
  ];


   */
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
   sub == null? sub = scanner.scanResult.stream.listen((event) {handleEvent(event);}):null;


    //layoutModel.value = testModel; // TODO get from data base

    //TODO start scan - from where should get ip?
    //await startScan();
    super.onInit();
  }

  handleEvent(EventModel event){
    print(event.data);
    if(event.type == 'device'){
        devices.add(event.data);
    }
    jobsDone++;
    if(jobsDone>=finalProgress){
      scanProgressStream.add(true);
      scanInProgressStream.add(false);
    }
  }
  setData(String _tag) async {
    print('set data');
    tag = _tag;
    Box box = await Hive.openBox('layouts');
    layout.value = box.get(_tag);
    box.close(); //TODO check for errors on close
    await startScan();
    update(['rigs_builder']);
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
  onDoubleTap(dynamic device){
    scanlistController.currentDevice.value = device;
    Get.to(()=>const OverviewScreen());
  }
  onRefresh() async {
    await startScan();
  }
  startScan() async {
   // await Future.delayed(const Duration(seconds: 5));
    jobsDone = 0;
    finalProgress = layout.value.ips!.length;
    if(layout.value.ips!.isNotEmpty) {
      print('ip is not empty');
      scanner.universalCreate(layout.value.ips, ['estats']);
      scanInProgressStream.add(true);
    }
    else{
      print('need to stop');
      await Future.delayed(Duration(seconds: 3));
      scanInProgressStream.add(false);
    }
   // scanProgressStream.add(true);
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