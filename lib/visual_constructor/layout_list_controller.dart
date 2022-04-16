import 'package:avalon_tool/visual_constructor/constructor_layout.dart';
import 'package:avalon_tool/visual_constructor/edit_tag_dialog.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LayoutListController extends GetxController{
  late Box box;
  List<dynamic> tags = [].obs;
  String? oldTag;
  String? newTag;
  RxString error = ''.obs;

  @override
  void onInit() async{
    try {
      box = await Hive.openBox('layouts');
      tags = box.keys.toList();
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
      content: EditTagDialog(),
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
  deleteLayout(String? tag){
    box.delete('$tag');
    tags.remove(tag);
    update(['layout_list']);
  }
  editLayout(String? tag){
    Get.to(()=>ConstructorLayout(tag: tag,));
  }
  newLayout(){
    Get.to(()=>const ConstructorLayout());
  }
}