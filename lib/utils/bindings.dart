import 'package:avalon_tool/utils/analyse_resolver.dart';
import 'package:avalon_tool/control_panel/control_panel_controller.dart';
import 'package:avalon_tool/ip_section/ip_management_controller.dart';
import 'package:avalon_tool/miner_overview/overview_controller.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/layout_list_controller.dart';
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