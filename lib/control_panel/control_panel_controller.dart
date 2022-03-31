import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlPanelController extends GetxController{
  final ScanListController scanListController = Get.put(ScanListController());
  RxInt currentIndex = 0.obs;
  RxDouble progress = 0.0.obs;
  @override
  onInit(){
    scanListController.progress.stream.listen((event) {updateProgress(event);});
    super.onInit();
  }
  onClick(int index, [BuildContext? context]){
    index!=4? currentIndex.value = index : null;
    if(index == 0)
      {
        scanListController.onScanClick();
      }
    else if(index == 4)
      {
        Get.defaultDialog(
          title: 'settings'.tr,
          titleStyle: Theme.of(context!).textTheme.bodyText2,
          content: const SettingsScreen(),
        );
      }
  }
  updateProgress(double value){
    progress.value = value;
  }
}