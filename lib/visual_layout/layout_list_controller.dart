import 'dart:async';

import 'package:AllMinerMonitor/auto_layout/wizard_ui.dart';
import 'package:AllMinerMonitor/debugger/debug_print.dart';
import 'package:AllMinerMonitor/isolates/layout_scanner.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:AllMinerMonitor/ui/desktop_scan_screen.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_layout.dart';
import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout/edit_tag_dialog.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LayoutListController extends GetxController{
  late Box box;
  final LayoutScanner layoutScanner = Get.find();
  List<dynamic> tags = [].obs;
  RxList<Layout> layouts = <Layout>[].obs;
  String? oldTag;
  String? newTag;
  RxString error = ''.obs;
  int currentScanIndex = 0;
  RxInt scanInterval = 15.obs;
  RxString autoValue = 'never'.obs;
  int? periodic;
  Timer? timer;
  String? currentTag;
  bool isManualScanActive = false;
  RxString startScanTag = ''.obs;
  @override
  void onInit() async{
    try {
      box = await Hive.openBox('layouts');
      tags = box.keys.toList();
      for(String t in tags){
        print(t);
        Layout _ = box.get(t);
      //
        //  Get.put(LayoutTileController((_)),tag: t, permanent: false);
      //  Get.putAsync<LayoutTileController>(() async => await LayoutTileController((_)),tag: t, permanent: false);
        layouts.add(box.get(t));
      }
      debug(subject: 'tags in db', message: '$tags', function: 'layout_list_controller > onInit');
      update(['layout_list']);
    }
    catch(e){
      debug(subject: 'catch error', message: '$e', function: 'layout_list_controller > onInit');
    }
    box.watch().listen((event) {handleBoxEvent(event);});
    layoutScanner.isManualScan.listen((event) {setManualScan(event);});
    layoutScanner.nextScan.listen((event) {onScanComplete(false, event);});
   setTimer();
    super.onInit();
  }
  handleBoxEvent(BoxEvent event){
    debug(subject: 'got box event', message: 'key: ${event.key}, value: ${event.value}', function: 'layout_list_controller > handleBoxEvent');
    if(event.value==null){
      for(Layout l in layouts){
        print(l.tag);
      }
     // Get.delete<LayoutTileController>(tag: '${event.key}');
      int? _index = layouts.indexWhere((element) => element.tag==event.key);
      //Layout? _ = layouts.firstWhere((element) => element.tag==event.key);
      //debug(subject: 'delete layout', message: 'layout: $_', function: 'layout_list_controller > handleBoxEvent');
      tags.remove(event.key);
      layouts.removeAt(_index);
      update(['layout_list']);
    }
    else{
      tags.add(event.key);
      Get.put(LayoutTileController((event.value)),tag: event.value.tag, permanent: false);
      layouts.add(event.value);
      LayoutTileController _ = Get.find(tag: event.key);
      print(_);
    }
  }
  onEditTagClick(String? tag){
    oldTag = tag;
    Get.defaultDialog(
      title: '',
      content: const EditTagDialog(),
    );
  }
  startScan() async {
    isManualScanActive = false;
    currentScanIndex = 0;
    await scanSingle();
  }
  scanSingle(){
    if(currentScanIndex<layouts.length) {
      debug(subject: 'scan single', message: 'index: $currentScanIndex, tag: ${layouts[currentScanIndex].tag}', function: 'layout_list_controller > scanSingle');
      startScanTag.value = layouts[currentScanIndex].tag??'';
      startScanTag.value = '';
   /*
      LayoutTileController _controller = Get.find(
          tag: layouts[currentScanIndex].tag);
      currentTag = layouts[currentScanIndex].tag;
      _controller.scan(false);
     */
    }
  }
  onScanComplete(bool abort, String tag){
    if(!isManualScanActive&&tag=='next') {
      debug(subject: 'on scan complete', message: 'abort: $abort, tag: $tag, isManual: $isManualScanActive', function: 'layout_list_controller > onScanComplete');
      currentScanIndex++;
      scanSingle();
    }
  }
  setManualScan(bool isManual){
    debug(subject: 'set manual scan flag', message: 'isManual: $isManual', function: 'layout_list_controller > setManualScan');
    isManualScanActive = isManual;
  }
  onBack() async {
    try {
      tags = box.keys.toList();
      update(['layout_list']);
    }
    catch(e){
      debug(subject: 'catch error', message: '$e', function: 'layout_list_controller > onBack');
    }
    Get.back();
  }
  onTagChange(String value){
    newTag = value;
  }
  bool validateNewTag(){
    if(newTag==null || newTag=='' || tags.contains(newTag)){
      return false;
    }
    else{
      return true;
    }
  }
  editTag(){
    if(validateNewTag()) {

      //Layout layout = box.get('$oldTag');
      Layout layout = layouts.firstWhere((element) => element.tag==oldTag);
      print(layout.tag);
      Layout _ =  Layout(tag: newTag, rigs: layout.rigs, counter: layout.counter, ips: layout.ips);

    //  print(layouts.firstWhere((element) => element.tag==oldTag).tag);
      print(_.tag);
      box.delete('$oldTag');
      box.put(newTag, _);
    //  deleteLayout('$oldTag');

     // layouts.remove(layout);
   //   update(['layout_list']);
    //  layout.tag = newTag;
      //box.delete('$oldTag');
     // tags.remove(oldTag);
   //   box.put(newTag, layout);
     // tags.add(newTag);
      Get.back();
      //update(['layout_list']);
    }
    else{
      error.value = 'Unique and not empty tag is required';
    }
  }
  deleteLayout(String? tag) async{
   box.delete('$tag');
  //  tags.remove(tag);
   // update(['layout_list']);
  }
  editLayout(String? tag){
    Get.to(()=>ConstructorLayout(tag: tag,));
  }
  autoSelect(String value){
    autoValue.value = value;
    if(value!='never'){
      periodic = int.tryParse(value);
    }
    else{
      periodic = null;
    }
    setTimer();
  }
  setTimer(){
    timer?.cancel();
    if(periodic!=null) {
      timer = Timer.periodic(
          Duration(minutes: periodic!), (timer) {
        startScan();
      }
      );
    }
  }
  newLayout(){
    Get.to(()=>const ConstructorLayout());
  }
  newAuto(){
    Get.to(()=>const AutoWizard());
  }

  goToScanList(){
    ScanListController _c = Get.find();
    _c.setActive(true);
    Get.to(()=>const DesktopScanScreen());
  }
}