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

class PlaceController extends GetxController{
  final LayoutController controller = Get.put(LayoutController());
  final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
  Place? place;
  int? placeIndex;
  dynamic device;
  RxBool fanError = false.obs;
  RxBool tempError = false.obs;
  RxBool dhError = false.obs;
  RxBool speedLow = false.obs;
  RxBool noData = true.obs;
  RxBool invalidIp = false.obs;
  //RxInt counter = 0.obs;
  setData(Place _place, int _placeIndex){
    place = _place;
    placeIndex = _placeIndex;
    controller.scanProgressStream.stream.listen((event) {getDevice();});
    update(['text']);
  }
  getDevice(){
//    print('scan complete');
  if(checkIp()) {
    /// get device
    try {
      device = controller.getDevice(place!, placeIndex!);
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
    if (device != null) {
      try {
        tempError.value = analyseResolver.hasErrors('temp_max', device.tMax);
      }
      catch (e) {
        tempError.value = true;
      }
      try {
        dhError.value = analyseResolver.hasErrors('dh', device.dh);
      }
      catch (e) {
        dhError.value = true;
      }
      try {
        fanError.value = analyseResolver.hasErrors('null_list', device.fans);
      }
      catch (e) {
        fanError.value = true;
      }
      try {
        speedLow.value =
            analyseResolver.hasErrors('min_speed', device.currentSpeed);
      }
      catch (e) {
        speedLow.value = true;
      }
    }
  }
  onDoubleTap(){
    if(device!=null) {
    controller.onDoubleTap(device);
    }
    else{
      print('no device');
    }
  }
}