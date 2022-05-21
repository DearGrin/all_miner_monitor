import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/scan_list/content_container_with_sort.dart';
import 'package:AllMinerMonitor/scan_list/data_row.dart';
import 'package:AllMinerMonitor/scan_list/rasp_controller.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RaspContent extends StatelessWidget {
  final String ip;

  //final RaspberryAva data;
  //final RaspController controller;
  const RaspContent(this.ip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ScanListController scanListController = Get.put(ScanListController());
    final RaspController controller = Get.find<RaspController>(tag: ip);
    //  print('in ui list_$ip');
    
    return Obx(() =>
         controller.isexpanded.value ?
    Obx(()=> Column(
        //  children: devices(_.device.value.devices??[], _, scanListController),
      //children: [Text('${controller.test.value}')],
        children: devices(controller, controller.test.value),
      ),
    )
        : Container());

/*
    return GetBuilder<RaspController>(
      init: Get.put<RaspController>(RaspController(), tag: ip),
      id: 'list_$ip',
      //tag: 'list',
       // init: Get.lazyPut(() => RaspController(), tag: ip),
        builder: (_){
     //   print('rebuild');
       // print(_.device.ip);
          return Obx(()=> _.isexpanded.value?
              Column(
            //  children: devices(_.device.value.devices??[], _, scanListController),
              children: _.device.devices!.map((e) => AvalonDataRow(_.device.devices!.indexOf(e),e, isRasp: true,)).toList(),
            ) : Container(),
          );
        }
    );
  }

 */
    /*
  List<Widget> devices(List<AvalonData> devices, RaspController controller, ScanListController scanListController){
    List<Widget> _tmp = [

    ];
    for(int i = 0; i < devices.length; i++){
      _tmp.add(Obx(()=>controller.isexpanded.value? AvalonDataRow(i,controller.device.value.devices![i], isRasp: true,) : Container()));
    }
    return _tmp;
  }


   */
  }
  List<Widget> devices(RaspController controller, int test){
    List<Widget> _tmp = [];
   _tmp =  controller.device.devices!.map((e) =>
        AvalonDataRow(
          controller.device.devices!.indexOf(e), e, isRasp: true,)).toList();
    return _tmp;
  }
}

