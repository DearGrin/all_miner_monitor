import 'package:avalon_tool/service_record/add_record.dart';
import 'package:avalon_tool/service_record/record_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ServiceController extends GetxController{
  final String ip;
  ServiceController(this.ip);
  Box? box;
  RxList<RecordModel> records = <RecordModel>[].obs;
  Rx<RecordModel> newRecord = RecordModel(date: '',comment: '', tags: []).obs;
  @override
  Future<void> onInit() async {
    box = await Hive.openBox('service_record_$ip');
    print(box?.keys);
    if(box!=null && box!.isNotEmpty) {
      List<dynamic> _tmp = box!.values.toList();
     records.value = _tmp.cast<RecordModel>();
    }
    box?.watch().listen((event) {handleEvent(event);});
    super.onInit();
  }
  handleEvent(BoxEvent event){
  records.add(event.value);
  }
  submitRecord(){
    String _date = '${DateTime.now().day}''.${DateTime.now().month}''.${DateTime.now().year}\n'
        '${DateTime.now().hour}'':${DateTime.now().minute}';
    newRecord.value.date=_date;
   try {
     box!.add(newRecord.value);
     Get.back();
     Get.snackbar('save_complete'.tr, '');
   }
   catch(e){
     Get.snackbar('error'.tr, e.toString());
   }
  }
  addTag(String tag){
    if(newRecord.value.tags!.contains(tag)){
     newRecord.value.tags!.remove(tag);
    }
    else {
      newRecord.value.tags!.add(tag);
    }
    update();
  }
  clearNewRecord(){
    newRecord.value = RecordModel(date: '',comment: '', tags: []);
  }
  openNewRecordDialog(){
  Get.dialog(const AddRecord());
  }
  cancelNewRecord(){
    Get.back();
    clearNewRecord();
  }
}