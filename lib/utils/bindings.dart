import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/control_panel/control_panel_controller.dart';
import 'package:AllMinerMonitor/ip_section/ip_management_controller.dart';
import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:AllMinerMonitor/scan_list/resize_controller.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:AllMinerMonitor/scan_list/scanner.dart';
import 'package:AllMinerMonitor/visual_layout/layout_list_controller.dart';
import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ScanListController(), fenix: true);
    Get.lazyPut(() => Scanner(), fenix: true);
    Get.lazyPut(() => LayoutListController(), fenix: true);
    Get.lazyPut(() => AnalyseResolver(), fenix: true);
    Get.lazyPut(() => ControlPanelController());
    Get.lazyPut(() => IpManagementController());
    Get.lazyPut(() => ResizeController());
  }
}
class LayoutBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LayoutController());
  }
}
class LayoutListBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LayoutListController());
  }
}
class ScanListBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ScanListController());
  }
}
class MinerOverviewBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(OverviewController());
  }
}