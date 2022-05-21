import 'package:AllMinerMonitor/scan_list/header_defaults.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:AllMinerMonitor/scan_list/table_header_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ResizeController extends GetxController{
  List<double> widths = <double>[].obs;
  List<int> sort = <int>[].obs;
  RxDouble maxWidth = 0.0.obs;
  List<TableHeaderModel> headers = [];
  final ScanListController _listController = Get.put(ScanListController());
  //late Box<TableHeaderModel> box;
  late Box box;
  @override
  onInit() async {
    box = await Hive.openBox('settings');
    await Future.delayed(const Duration(seconds: 1)); //a save for init race
    List<dynamic>? _tmp = box.get('headers');
    List<TableHeaderModel> _ =  _tmp?.cast<TableHeaderModel>()??headersDefault;
      for(int i =0; i < _.length; i++){
        headers.add(_[i]);
      }
    for(int i = 0; i < headers.length; i++)
      {
        widths.add(headers[i].width!);
        sort.add(0);
        update(['header_$i']);
      }
    updateMaxWidth();
    super.onInit();
  }
  onDrag(int index, Offset offset){
      if(widths[index] + offset.dx >20)
        {
          widths[index] += offset.dx;
          headers[index].width = headers[index].width! + offset.dx;
          maxWidth.value += offset.dx;
          box.put('headers', headers);
        }
      updateMaxWidth();
  }
  onClick(int index){
    int _ = sort[index];
    if(_ == 0){
      sort[index] = 1;
    }
    else if(_==1){
      sort[index] = 2;
    }
    else{
      sort[index] = 1;
    }
    for(int i = 0; i < sort.length; i++)
      {
        if(i!=index) {
          sort[i] = 0;
        }
      }
    _listController.sort(headers[index].label.toString(), sort[index]==1?false:true);
  }
  updateHeaders(List<TableHeaderModel> _headers, int changedIndex){
    headers = _headers;
    updateMaxWidth();
    update(['header_$changedIndex', 'content_$changedIndex']);
  }
  updateMaxWidth(){
    maxWidth.value = 0;
    for(int i = 0; i < headers.length; i++)
    {
      if(headers[i].isVisible!) {
        maxWidth.value += widths[i];
      }
    }
    maxWidth.value += 50.0;
    update(['headers']);
  }
}