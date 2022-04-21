import 'dart:async';

import 'package:avalon_tool/antminer/antminer_model.dart';
import 'package:avalon_tool/antminer/mock_ant.dart';
import 'package:avalon_tool/avalon_10xx/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/overview_screen.dart';
import 'package:avalon_tool/avalon_10xx/regexp_parser.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/layout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class PlaceController extends GetxController{
  final LayoutController controller = Get.put(LayoutController());
  final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
  Place? place;
  int? placeIndex;
  dynamic device;
  RxDouble size = 105.0.obs;
  RxBool fanError = false.obs;
  RxBool tempError = false.obs;
  RxBool dhError = false.obs;
  RxBool speedLow = false.obs;
  RxBool noData = true.obs;
  RxBool hashCount = false.obs;
  RxBool chipCount = false.obs;
  RxBool invalidIp = false.obs;
  RxString speed = 'speed no data\n'.obs;
  RxString temp = 'temp no data\n'.obs;
  RxString ip = 'ip: '.obs;
  Offset? offset;
  StreamSubscription? sub;
  StreamSubscription? resize;
  //RxInt counter = 0.obs;
  setData(Place _place, int _placeIndex) async {
    place = _place;
    placeIndex = _placeIndex;
    sub?? controller.scanProgressStream.stream.listen((event) {getDevice();});
    resize?? controller.resizeStream.stream.listen((event) {resizeIt(event);});
    Box box = await Hive.openBox('settings');
   size.value = box.get('place_size')??50.0;
    analyseIt();
    update(['text']);
  }
  resizeIt(String event) async{
    print('resize it');
    if(event=='in'){
      size.value +=5.0;
    }
    else{
      if(size.value - 5.0 > 55) {
        size.value -= 5.0;
      }
    }
    Box box = await Hive.openBox('settings');
    box.put('place_size', size.value);
  }
  getDevice(){
//    print('scan complete');
  if(checkIp()) {
    /// get device
    try {
    //  device = controller.getDevice(place!, placeIndex!);
      device = AntMinerModel.fromString(mockAnt, '10.10.10.10');
    }
    catch(e){
      print(e);
    }
    /// analyse it
    analyseIt();
    /// update
    update();
  //  device = controller.getDevice(place);
    //counter.value++;
  }
  else{
    invalidIp.value = true;
  }
  //update();
  }
  bool checkIp(){
    final RegExp _ip = RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$');
    if(place!=null && place!.ip!= null && _ip.hasMatch(place!.ip!)){
      return true;
    }
    else{
      return false;
    }
  }
  analyseIt() {
    noData.value = device == null ? true : false;
    try{
      ip.value = place!.ip!;
    }
    catch(e){
      ip.value = 'no ip';
    }
    if (device != null) {
      try {
        tempError.value = analyseResolver.hasErrors('temp_max', device.tMax);
      }
      catch (e) {
        tempError.value = true;
      }
      try {
        //
        //TODO check hash count
        //TODO check acn_s
        if(device.company=='Antminer') {
          dhError.value =
              analyseResolver.hasErrors('acn_s', device.chainString);
        }
        else{
          dhError.value = analyseResolver.hasErrors('dh', device.dh);
        }
      }
      catch (e) {
        dhError.value = true;
      }
      try{
        hashCount.value = analyseResolver.hasErrors('hash_count', device.hashCount, device.model);
      }
      catch(e){
        hashCount.value = true;
      }
      try{
        chipCount.value = analyseResolver.hasErrors('chip_count', device.chipPerChain, device.model);
      }
      catch(e){
        chipCount.value = true;
      }
      try {
        fanError.value = analyseResolver.hasErrors('null_list', device.fans);
      }
      catch (e) {
        fanError.value = true;
      }
      try {
        speedLow.value =
            analyseResolver.hasErrors('min_speed', device.currentSpeed, device.model);
      }
      catch (e) {
        print(e);
        speedLow.value = true;
      }
      try {
        if (device.isScrypt) {
          speed.value = '${device.currentSpeed.toStringAsFixed(2)} Gh/s\n';
        }
        else {
        speed.value = '${device.currentSpeed.toStringAsFixed(2)} Th/s\n';
        }
      }
        catch(e){
          speed.value = 'hash no data\n';
        }
        try{
          temp.value = '${device.tMax} C\n';
        }
        catch(e){
        temp.value = 'no temp data\n';
        }
      }
  }
  onDoubleTap(){
    if(device!=null) {
    controller.onDoubleTap(device);
    }
    else{
      print('no device');
      //dynamic _device = AntMinerModel.fromString(mockAnt, '10.10.10.10');
      //dynamic _device = AvalonData.fromString(mockData, '10.10.10.10');
      //print(_device);
      //controller.onDoubleTap(_device);
    }
  }
  setOffset(PointerEvent event){
    offset = event.position;

  }
  onSingleTap(){
    controller.onSingleTap(offset, device);
  }
}