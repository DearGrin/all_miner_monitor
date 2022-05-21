import 'package:get/get.dart';
import 'package:hive/hive.dart';

class TotalStatsController extends GetxController{
  final String layoutTag;
  TotalStatsController(this.layoutTag);
  RxList<Map<String,Object>> totalSpeedSHA256 = <Map<String,Object>>[].obs;
  RxList<Map<String,Object>> totalSpeedSCRYPT = <Map<String,Object>>[].obs;
  RxList<Map<String,Object>> totalDevices = <Map<String,Object>>[].obs;
  RxList<Map<String,Object>> totalErrors = <Map<String,Object>>[].obs;
  RxInt viewMode = 0.obs;
  @override
  onInit() async {
    Box box = await Hive.openBox('stats_$layoutTag');
    List<dynamic> _ = box.values.toList();
    for(var entry in _){
      parseData(entry);
    }
    box.watch().listen((event) {event.value!=null? parseData(event.value):null;});
    super.onInit();
  }
  parseData(Map<dynamic, dynamic> entry){
    Map<String, Object> y = Map.castFrom<dynamic, dynamic, String, Object>(entry);
    if(y['name']=='speed SHA256') {
      totalSpeedSHA256.add(y);
    }
    else if(y['name']=='speed SCRYPT'){
      totalSpeedSCRYPT.add(y);
    }
    else if(y['name']=='total devices'){
      totalDevices.add(y);
    }
    else{
      totalErrors.add(y);
    }
  }
  toggleViewMode(){
    viewMode.value ==0 ? viewMode.value=1 : viewMode.value=0;
  }
}