import 'dart:async';

import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/utils/bindings.dart';
import 'package:avalon_tool/visual_constructor/constructor_layout.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/container_layout.dart';
import 'package:avalon_tool/visual_layout/layout_list_controller.dart';
import 'package:avalon_tool/visual_layout/more_dialog.dart';
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
  int _counter = 0;
  RxInt scannedDevices = 0.obs;
  RxInt withProblems = 0.obs;
  StreamController scanInProgressStream = StreamController<int>();
  RxBool isActive = false.obs;
  RxList<String> totalErrors = <String>[].obs;
  RxList<String> speedErrors = <String>[].obs;
  RxList<String> fanErrors = <String>[].obs;
  RxList<String> tempErrors = <String>[].obs;
  RxList<String> chipCountErrors = <String>[].obs;
  RxList<String> hashCountErrors = <String>[].obs;
  RxList<String> chipsSErrors = <String>[].obs;
  RxInt viewMode = 0.obs;
  @override
  void onInit() async{

    ///watch for layout changes
    Box box = await Hive.openBox('layouts');
    box.watch(key: layout.tag).listen((event) {handleLayoutChange(event);});
    ///listen to scan results with tag
    scanResultSub==null? scanResultSub = scanner.scanResult.stream.listen((event) {handleScanResult(event);}) : null;
    print(layout.ips?.length);
    super.onInit();
  }
  handleLayoutChange(BoxEvent event){
    layout = event.value;
  }
  handleScanResult(EventModel event){
    if(event.tag!=null && event.tag==layout.tag) {
      if (event.type == 'device') {
        devices.add(event.data);
        scannedDevices.value++;
        jobsDone++;
        progress.value = jobsDone / layout.ips!.length;
        ///count errors
        if(event.data.speedError){
          speedErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        if(event.data.fanError){
          fanErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        if(event.data.tempError){
          tempErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        if( event.data.chipCountError){
          chipCountErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        if(event.data.hashCountError){
          hashCountErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        if( event.data.chipsSError){
          chipsSErrors.add(event.data.ip);
          !totalErrors.contains(event.data.ip)? totalErrors.add(event.data.ip) : null;
        }
        ///
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
      else if(event.type=='abort'){
        scanInProgressStream.add(_counter);
        _counter++;
        isActive.value = false;
      }
      else{
        jobsDone++;
        progress.value = jobsDone / layout.ips!.length;
      }
    }
    if(progress>=1){
      scanInProgressStream.add(_counter);
      _counter++;
      isActive.value = false;
    }
  }
  scan() async {
    clearSummary();
    scanInProgressStream.add(_counter);
    _counter++;
    if(layout.ips!.isNotEmpty){
     // scanlistController.clearQuery();
     await scanner.newScan(ips: layout.ips, tg: layout.tag);
    }
    isActive.value = true;
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
    totalErrors.clear();
    speedErrors.clear();
    fanErrors.clear();
    tempErrors.clear();
    hashCountErrors.clear();
    chipCountErrors.clear();
    chipsSErrors.clear();
  }
  switchMode(){
    viewMode.value==0? viewMode.value = 1 : viewMode.value = 0;
  }
  showMore(){
    List<List<String>> _tmp =[
      tempErrors,
      fanErrors,
      speedErrors,
      hashCountErrors,
      chipCountErrors,
      chipsSErrors
    ];
    for(String e in _tmp[5]){
      print(e);
    }
    Get.defaultDialog(
      title: 'ip_list'.tr,
      content: MoreDialog(_tmp),
    );
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
    Get.to(()=> const ContainerLayout(), binding: LayoutBinding(), arguments: layout); //TODO adn pass result if ready
  }
  openMenu(){
    isMenuOpen.value=true;
  }
  closeMenu(){
    isMenuOpen.value=false;
  }
}