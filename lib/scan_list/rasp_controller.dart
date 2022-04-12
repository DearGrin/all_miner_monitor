import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/header_defaults.dart';
import 'package:avalon_tool/scan_list/table_header_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class RaspController extends GetxController{
  List<int> sortId = <int>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0].obs;
  RaspberryAva device = RaspberryAva();
  RxBool isexpanded = false.obs;
  RxInt test = 0.obs;
  @override
  onInit() async {
    Box box = await Hive.openBox('settings');
    await Future.delayed(const Duration(seconds: 1)); //a save for init race
    List<dynamic>? _tmp = box.get('headers');
    List<TableHeaderModel> _ =  _tmp?.cast<TableHeaderModel>()??headersDefault;
    for(int i = 0; i < _.length; i++)
    {
     // sortId.add(0);
     // update(['header_$i']);
    }
    super.onInit();
  }

  setData(RaspberryAva data){
   // print('set data');
    device = data;
   // print(device.value.ip);
  }

 onClick(int index, String type){
    sortId[index]==1? sortId[index]=2: sortId[index]=1;
    for(int i = 0; i < sortId.length; i++)
      {
        if(i!=index) {
          sortId[i] = 0;
        }
      }
    sort(type, sortId[index]==1? false:true);
 }
  sort(String type, bool reverse){

    switch(type){
      case 'status':
        device.devices?.sort((a,b)=>a.status!.compareTo(b.status!));
        break;
      case 'ip':
        device.devices?.sort((a,b)=>a.ipInt!.compareTo(b.ipInt!));
        break;
      case 'manufacture':
        device.devices?.sort((a,b)=>a.company!.compareTo(b.company!));
        break;
      case 'model':
        device.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'elapsed':
        device.devices?.sort((a,b)=>a.elapsed!.compareTo(b.elapsed!));
        break;
      case 'Th/s':
        device.devices?.sort((a,b)=>a.currentSpeed!.compareTo(b.currentSpeed!));
        break;
      case 'Th/s avg':
        device.devices?.sort((a,b)=>a.averageSpeed!.compareTo(b.averageSpeed!));
        break;
      case 'tempInput':
        device.devices?.sort((a,b)=>a.tempInput!.compareTo(b.tempInput!));
        break;
      case 'tempMax':
        device.devices?.sort((a,b)=>a.tMax!.compareTo(b.tMax!)); //TODO check for null
        break;
      case 'fans':
        device.devices?.sort((a,b)=>a.fans.toString().compareTo(b.fans.toString()));
        break;
      case 'mm':
        device.devices?.sort((a,b)=>a.mm!.compareTo(b.mm!));
        break;
      case 'errors':
        device.devices?.sort((a,b)=>a.ECMM!.first.id.toString().compareTo(b.ECMM!.first.id.toString())); //TODO check for null
        break;
      case 'ps':
        device.devices?.sort((a,b)=>a.ps.toString().compareTo(b.ps.toString()));
        break;
      case 'net_fail':
        device.devices?.sort((a,b)=>a.netFail.toString().compareTo(b.netFail.toString()));
        break;
      case 'pool1':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'pool2':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'pool3':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker1':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker2':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker3':
      //device?.devices?.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
    }
    if(reverse)
    {
      device.devices = device.devices?.reversed.toList();
    }

    //print('in controller list_${device.ip}');
   // print(device.devices![0].currentSpeed);
    test.value++;
    update(['list_${device.ip}']);
  }
  expand(){
    isexpanded.value = !isexpanded.value;
   // print('expand ${device.ip}');
   update(['list_${device.ip}']);

  }
}