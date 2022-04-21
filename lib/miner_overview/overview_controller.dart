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
}