import 'package:avalon_tool/auto_layout/wizard_ui.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/ui/desktop_scan_screen.dart';
import 'package:avalon_tool/visual_constructor/constructor_layout.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/edit_tag_dialog.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LayoutListController extends GetxController{
  late Box box;
  List<dynamic> tags = [].obs;
  List<Layout> layouts = [];
  String? oldTag;
  String? newTag;
  RxString error = ''.obs;

  @override
  void onInit() async{
    try {
      box = await Hive.openBox('layouts');
      tags = box.keys.toList();
      for(String t in tags){
        layouts.add(box.get(t));
      }
      update(['layout_list']);
    }
    catch(e){
      print(e);
    }
    super.onInit();
  }
  onEditTagClick(String? tag){
    oldTag = tag;
    Get.defaultDialog(
      title: '',
      content: const EditTagDialog(),
    );
  }
  onBack() async {
    print('back');
    try {
      box = await Hive.openBox('layouts');
      tags = box.keys.toList();
      update(['layout_list']);
    }
    catch(e){
      print(e);
    }
    Get.back();
  }
  onTagChange(String value){
    newTag = value;
  }
  bool validateNewTag(){
    if(newTag==null || newTag=='' || box.keys.contains(newTag)){
      return false;
    }
    else{
      return true;
    }
  }
  editTag(){
    if(validateNewTag()) {
      final layout = box.get('$oldTag');
      box.delete('$oldTag');
      tags.remove(oldTag);
      box.put(newTag, layout);
      tags.add(newTag);
      Get.back();
      update(['layout_list']);
    }
    else{
      error.value = 'Unique and not empty tag is required';
    }
  }
  deleteLayout(String? tag) async{
    Box _box = await Hive.openBox('layouts');
    _box.delete('$tag');
    tags.remove(tag);
    update(['layout_list']);
  }
  editLayout(String? tag){
    Get.to(()=>ConstructorLayout(tag: tag,));
  }
  newLayout(){
    Get.to(()=>const ConstructorLayout());
  }
  newAuto(){
    //Get.dialog(const AutoWizard());
    Get.to(()=>const AutoWizard());
  }
  updateList() async {
    try {
      box = await Hive.openBox('layouts');
      tags = box.keys.toList();
      update(['layout_list']);
    }
    catch(e){
      print(e);
    }
  }
  goToScanList(){
    ScanListController _c = Get.find();
    _c.setActive(true);
    Get.to(()=>const DesktopScanScreen());
  }
}