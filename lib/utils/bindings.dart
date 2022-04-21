import 'package:avalon_tool/miner_overview/overview_controller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/layout_list_controller.dart';
import 'package:get/get.dart';

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