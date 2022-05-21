import 'dart:async';

//import 'package:avalon_tool/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/miner_overview/miner_overview_screen.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/service_record/service_controller.dart';
import 'package:AllMinerMonitor/service_record/service_screen.dart';
import 'package:AllMinerMonitor/utils/bindings.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../debugger/debug_print.dart';

class PlaceController extends GetxController{
  final LayoutController controller = Get.put(LayoutController());
  //final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
  Place? place;
  int? placeIndex;
  dynamic device;
  RxDouble size = 105.0.obs;
  RxBool noData = true.obs;
  /*
  RxBool fanError = false.obs;
  RxBool tempError = false.obs;
  RxBool dhError = false.obs;
  RxBool speedLow = false.obs;
  RxBool hashCount = false.obs;
  RxBool chipCount = false.obs;


   */
  RxBool invalidIp = false.obs;
  RxString speed = 'speed no data\n'.obs;
  RxString temp = 'temp no data\n'.obs;
  RxString ip = 'ip: '.obs;
  Offset? offset;
  StreamSubscription? sub;
  StreamSubscription? resize;
  RxBool isSelected = false.obs;
  Rx<DeviceModel> currentDevice = DeviceModel(ip: null).obs;
  //RxInt counter = 0.obs;
  @override
  Future<void> onInit() async {
    controller.clearQuery.listen((event) {clearData(event);});
    super.onInit();
  }
  clearData(bool event){
    if(event){
      debug(subject: 'clear data', message: 'event: $event', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > clearData ');
      device = null;
      currentDevice.value = DeviceModel(ip: null);
      noData.value = true;
      speed.value = 'speed no data\n';
      temp.value = 'temp no data\n';
      /*
      fanError.value = false;
      tempError.value = false;
      dhError.value = false;
      speedLow.value = false;
      hashCount.value = false;
      chipCount.value = false;


       */
      //update();
    }
  }
  setData(Place _place, int _placeIndex) async {
    place = _place;
    placeIndex = _placeIndex;
    //sub?? controller.scanProgressStream.stream.listen((event) {getDevice();});
    resize?? controller.resizeStream.stream.listen((event) {resizeIt(event);});
    //controller.newIp.listen((event) async{await getDevice(event); });
    controller.newDevice.listen((device) {handleDevice(device); });
    Box box = await Hive.openBox('settings');
   size.value = box.get('place_size')??50.0;
   if(controller.maxRow*size.value+100>Get.height){
     size.value = (Get.height-100)/controller.maxRow;
   }
   dynamic _device = await controller.getDevice(_place, _placeIndex);
   if(_device!=null){
     currentDevice.value = _device;
     noData.value=false;
   }
   // analyseIt();
    update(['text']);
  }
  resizeIt(String event) async{
    if(event=='in'){
      if(size.value*controller.maxRow<Get.height-100) {
        size.value += 5.0;
      }
    }
    else{
      if(size.value - 5.0 > 55) {
        size.value -= 5.0;
      }
    }
    Box box = await Hive.openBox('settings');
    box.put('place_size', size.value);
  }
  handleDevice(DeviceModel device){
    debug(subject: 'handle device', message: 'ip: ${place?.ip}, placeIndex: $placeIndex', function: 'place_controller tag: ${'${place?.id}/$placeIndex'}> handleDevice ');
    if(place!.type=='miner'&&place!.ip==device.ip){
      currentDevice.value = device;
      print('chip count error is ${currentDevice.value.chipCountError}');
    }
    else if(place!.type!='miner'&&place!.ip==device.ip){
      try {
        final RaspberryAva _rasp = device.data;
        debug(subject: 'handle rasp', message: 'rasp: $_rasp', function: 'place_controller tag: ${'${place?.id}/$placeIndex'}> handleDevice ');
        final _auc = _rasp.devices?.where((element) =>
        element.data.aucN == place?.aucN).toList();
        currentDevice.value = _auc?[placeIndex!]??DeviceModel(); ///TODO RASPBERYY convert AvalonData to DeviceModel
      }
      catch(e){
        debug(subject: 'catch error', message: '$e', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > handleDevice');
      }
    }
    noData.value = false;
  }

  getDevice(String ip)async{
    debug(subject: 'get device', message: 'ip: $ip', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > getDevice(ip) > step 1');
  if(place!.ip!=null && place!.ip==ip) {
    debug(subject: 'get device', message: 'ip: $ip, ip has match with place', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > getDevice(ip) > step 2');
    /// get device
    try {
      ///get device from scan results
      device = await controller.getDevice(place!, placeIndex!);
      debug(subject: 'get device', message: 'device: $device', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > getDevice(ip) > step 3');
      if(device!=null) {
        currentDevice.value = device;
      }
    }
    catch(e){
      debug(subject: 'catch error', message: '$e', function: 'place_controller tag: ${'${place?.id}/$placeIndex'} > getDevice(ip)');
    }
    /// analyse it
   // analyseIt();
    /// update
   // update();
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
  /*
  analyseIt() async {
    noData.value = device == null ? true : false;
    try{
      ip.value = place!.ip!;
    }
    catch(e){
      ip.value = 'no ip';
    }
    print(device==null);
    if (device != null) {
      try {
        tempError.value =await analyseResolver.hasErrors('temp_max', device.tMax);
      }
      catch (e) {
        tempError.value = true;
      }
      try {
        //
        //TODO check hash count
        //TODO check acn_s
        if(device.manufacture=='Antminer') {
          dhError.value =
              await  analyseResolver.hasErrors('acn_s', device.data.chainString);
        }
        else{
          dhError.value = await analyseResolver.hasErrors('dh', device.data.dh);
        }
      }
      catch (e) {
        dhError.value = true;
      }
      try{
        hashCount.value =await analyseResolver.hasErrors('hash_count', device.data.hashCount, device.model);
      }
      catch(e){
        hashCount.value = true;
      }
      try{
        chipCount.value =await analyseResolver.hasErrors('chip_count', device.data.chipPerChain, device.model);
      }
      catch(e){
        chipCount.value = true;
      }
      try {
        fanError.value =await analyseResolver.hasErrors('null_list', device.data.fans);
      }
      catch (e) {
        fanError.value = true;
      }
      try {
        speedLow.value =
            await      analyseResolver.hasErrors('min_speed', device.currentSpeed, device.model);
      }
      catch (e) {
        print(e);
        speedLow.value = true;
      }
      try {
        if (device.isScrypt) {
          speed.value = '${device.currentSpeed.toStringAsFixed(2)} Mh/s\n';
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


   */
  onDoubleTap(){

    if(currentDevice.value!=DeviceModel()) {
      Get.to(()=> const MinerOverviewScreen(), binding: MinerOverviewBinding(), arguments: currentDevice.value);
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
    controller.onSingleTap(offset, currentDevice.value);
  }
  onSecondaryTap(){
    controller.onSingleSecondaryTap(offset, place?.ip);
  }
  onSecondaryLongPress(){
    if(place!=null && place!.ip!=null) {
      Get.put(ServiceController(place!.ip!));
      Get.dialog(const ServiceScreen());
    }
  }
  onLongTapTap() {
    if (currentDevice.value != DeviceModel()) {
      isSelected.value = !isSelected.value;
      if (isSelected.value) {
        controller.selectedDevices.add(currentDevice.value);
      }
      else {
        controller.selectedDevices.remove(currentDevice.value);
      }
    }
  }
}