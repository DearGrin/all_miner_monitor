import 'package:avalon_tool/auto_layout/wizard_controller.dart';
import 'package:get/get.dart';

class WizardItemController extends GetxController{
  RxString? ipRange = ''.obs;
  RxBool ipError = false.obs;
  RxInt shelfCount = 0.obs;
  RxInt placeCount = 0.obs;
  RxInt gap = 0.obs;
  final WizardController controller = Get.put(WizardController());
  editIp(String value, int rigId){
    ipRange?.value = value;
    if(value==''||!value.contains('-')){
      ipError.value = true;
    }
    else{
     final RegExp _startIp = RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$');
     final RegExp _endIp = RegExp(r'\d|\d\.\d');
     if(_startIp.hasMatch(value.split('-')[0]) &&
         _endIp.hasMatch(value.split('-')[1]))
     {
       ipError.value = false;
     }
     else{
       ipError.value = true;
     }
    }
    controller.setIpRang(rigId, value);
  }
  editShelfCount(String value, int rigId) {
    int oldValue = shelfCount.value;
    if (value == '') {
      print('empty');
      shelfCount.value = -1;
      shelfCount.value = 0;
    }
    else {
      try {
        shelfCount.value = int.parse(value);
      }
      catch (e) {
        print(e);
        shelfCount.value = 99;
        shelfCount.value = oldValue;
      }
    }
    controller.setShelfCount(rigId, shelfCount.value);
  }
  shelfPlus(int rigId){
    shelfCount.value++;
    controller.setShelfCount(rigId, shelfCount.value);
  }
  shelfMinus(int rigId){
    if(shelfCount.value==0){
      print('zero');
    }
    else{
    shelfCount.value--;
    controller.setShelfCount(rigId, shelfCount.value);
    }
  }
  editPlaceCount(String value, int rigId) {
    int oldValue = placeCount.value;
    if (value == '') {
      placeCount.value = -1;
      placeCount.value = 0;
    }
    else {
      try {
        placeCount.value = int.parse(value);
      }
      catch (e) {
        print(e);
        placeCount.value = 99;
        placeCount.value = oldValue;
      }
    }
    controller.setPlaceCount(rigId, placeCount.value);
  }
  placePlus(int rigId){
    placeCount.value++;
    controller.setPlaceCount(rigId, placeCount.value);
  }
  placeMinus(int rigId){
    if(placeCount.value==0){
      print('zero');
    }
    else{
      placeCount.value--;
      controller.setPlaceCount(rigId, placeCount.value);
    }
  }
  editGapCount(String value, int rigId) {
    int oldValue = gap.value;
    if (value == '') {
      gap.value = -1;
      gap.value = 0;
    }
    else {
      try {
        gap.value = int.parse(value);
      }
      catch (e) {
        print(e);
        gap.value = 99;
        gap.value = oldValue;
      }
    }
    controller.setGapCount(rigId, gap.value);
  }
  gapPlus(int rigId){
    gap.value++;
    controller.setGapCount(rigId, gap.value);
  }
  gapMinus(int rigId){
    if(gap.value==0){
      print('zero');
    }
    else{
      gap.value--;
      controller.setGapCount(rigId, gap.value);
    }
  }
  deleteRig(int rigId){
    controller.deleteItem(rigId);
  }
}