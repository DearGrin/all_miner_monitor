import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class PoolsEditorController extends GetxController{
  late ScanListController scanListController;
  late Box<Pool> box;
  List<Pool?> pools = [Pool(), Pool(), Pool()];
  List<int> suffixMode = [0,0,0].obs; // 0 - no change; 1 - by ip;
  @override
  Future<void> onInit() async {
    scanListController = Get.put(ScanListController());
    box = await Hive.openBox<Pool>('pools');
    getDataFromSettings();
    super.onInit();
  }
  getDataFromSettings(){
    for(int i = 0; i < box.values.length; i++)
      {
        pools[i] = box.getAt(i);
      }
  }
  submitAll(){
    scanListController.submitPoolsAll(pools, suffixMode);
  }
  submitSelected(){
    scanListController.submitPoolsSelected(pools, suffixMode);
  }
  onAddrChange(int index, String? value){
    pools[index]!.addr = value;
  }
  onPortChange(int index, String? value){
    pools[index]!.port = value;
  }
  onPasswdChange(int index, String? value){
    pools[index]!.passwd = value;
  }
  onWorkerChange(int index, String? value){
    pools[index]!.worker = value;
  }
  suffixSelect(int index, int? value){
    suffixMode[index] = value??0;
  }
  /*
  constructWorker(int index){
    if(pools[index]?.addr!=null || pools[index]?.addr!='')
      {
        String _suffix = '';
        if(suffixMode[index] == 1)
          {

          }
        String _worker = pools[0]?.worker??'';
        pools[0]?.worker = _worker + '.' + _suffix;
      }
  }

   */
}