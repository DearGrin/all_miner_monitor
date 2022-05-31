import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class OverviewController extends GetxController{
  RxList<dynamic> device = <dynamic>[].obs;
  RxInt stackIndex = 0.obs;
  RxInt displayMode = 0.obs;
  @override
  void onInit() {
    device.add(Get.arguments);
    super.onInit();
  }
  showLog(){
    stackIndex.value = 0;
  }
  showTempMap(){
    stackIndex.value = 1;
    displayMode.value = 0;
  }
  showWorkMap(){
    stackIndex.value = 1;
    displayMode.value = 1;
  }
  saveLog()async{
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    if(!Directory('$appDocumentsPath/All Miner/logs').existsSync()) {
      Directory('$appDocumentsPath/All Miner/logs').create();
    }
    String filePath = '$appDocumentsPath/All Miner/logs/all_miner_log_${DateTime.now().month}${DateTime.now().day}_${DateTime.now().hour}_${DateTime.now().minute}${DateTime.now().millisecond}.txt';
    File file = File(filePath); // 1
    file.writeAsString(device[0].data.rawData); // 2
    String _path = filePath.replaceAll('\\', '/');
    Get.snackbar('Save complete', _path,);
  }
}