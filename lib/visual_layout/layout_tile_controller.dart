import 'dart:async';

import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/utils/bindings.dart';
import 'package:avalon_tool/visual_constructor/constructor_layout.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/container_layout.dart';
import 'package:avalon_tool/visual_layout/layout_list_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LayoutTileController extends GetxController{
  Layout layout;
  LayoutTileController(this.layout);
  final LayoutListController controller = Get.put(LayoutListController());
  final Scanner scanner = Get.put(Scanner());
  RxDouble progress = 0.0.obs;
  RxBool isMenuOpen = false.obs;
  List<dynamic> devices = [];
  int jobsDone = 0;
  RxDouble speedSCRYPT = 0.0.obs;
  RxDouble speedSHA256 = 0.0.obs;
  RxDouble speedAvgSCRYPT = 0.0.obs;
  RxDouble speedAvgSHA256 = 0.0.obs;
  RxInt deviceCountSCRYPT = 0.obs;
  RxInt deviceCountSHA256 = 0.obs;
  StreamSubscription? scanResultSub;
  @override
  void onInit() async{
    ///watch for layout changes
    Box box = await Hive.openBox('layouts');
    box.watch(key: layout.tag).listen((event) {handleLayoutChange(event);});
    ///listen to scan results with tag
    scanResultSub==null? scanResultSub = scanner.scanResult.stream.listen((event) {handleScanResult(event);}) : null;
    super.onInit();
  }
  handleLayoutChange(BoxEvent event){
    layout = event.value;
  }
  handleScanResult(EventModel event){
    if(event.tag!=null && event.tag==layout.tag) {
      jobsDone++;
      progress.value = jobsDone / layout.ips!.length;
      if (event.type == 'device') {
        devices.add(event.data);
        if (event.data.isScrypt == true) {
          deviceCountSCRYPT.value++;
          speedSCRYPT.value += event.data.currentSpeed;
          speedAvgSCRYPT.value = speedSCRYPT.value / deviceCountSCRYPT.value;
        }
        else {
          deviceCountSHA256.value++;
          speedSHA256.value += event.data.currentSpeed;
          speedAvgSHA256.value = speedSHA256.value / deviceCountSHA256.value;
        }
      }
    }
  }
  scan(){
    clearSummary();
    if(layout.ips!.isNotEmpty){
     // scanlistController.clearQuery();
      scanner.newScan(ips: layout.ips, tg: layout.tag);
    }
  }
  clearSummary(){
    jobsDone = 0;
    progress.value = 0.0;
    devices.clear();
    speedSCRYPT.value = 0;
    speedAvgSCRYPT.value = 0;
    speedAvgSHA256.value = 0;
    speedSHA256.value = 0;
    deviceCountSCRYPT.value = 0;
    deviceCountSHA256.value = 0;
  }
  onEditTagClick(){
    controller.onEditTagClick(layout.tag);
  }
  editLayout(){
    Get.to(()=>ConstructorLayout(tag: layout.tag,)); //TODO add bindings
  }
  deleteLayout(){
    controller.deleteLayout(layout.tag);
  }
  openLayout(){
    Get.to(()=> ContainerLayout(), binding: LayoutBinding(), arguments: layout); //TODO adn pass result if ready
  }
  openMenu(){
    isMenuOpen.value=true;
  }
  closeMenu(){
    isMenuOpen.value=false;
  }
}