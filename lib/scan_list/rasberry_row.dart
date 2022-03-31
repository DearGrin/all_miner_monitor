import 'package:avalon_tool/avalon_10xx/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/content_container.dart';
import 'package:avalon_tool/scan_list/content_container_with_sort.dart';
import 'package:avalon_tool/scan_list/data_row.dart';
import 'package:avalon_tool/scan_list/rasp_controller.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RasberryDataRow extends StatelessWidget {
  final int index;
  final RaspberryAva data;
  const RasberryDataRow(this.index, this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RaspController controller = Get.put(RaspController(), tag: data.ip);
    final ScanListController scanListController = Get.put(ScanListController());
    controller.setData(data);
    List<Widget> _tmp = [
      Row(
        children: [
          Container(
            height: 40,
            width: 34,
            decoration: BoxDecoration(
                border: Border.all()
            ),

            child: Obx(() =>
                Checkbox(
                    value: scanListController.selectedIps.contains(data.ip),
                    onChanged: (value) {
                      scanListController.selectIp(data.ip ?? '', value!);
                    }
                )
            ),
          ),
          ContentContainerWithSort(0, data.status, data.ip??'', 'status' ),
          ContentContainerWithSort(1, data.ip, data.ip??'', 'ip'),
          ContentContainerWithSort(2, data.company, data.ip??'', 'manufacture'),
          ContentContainerWithSort(3, data.model, data.ip??'', 'model'),
          ContentContainerWithSort(4, data.elapsedString, data.ip??'', 'elapsed'),
          //TODO do like normal format
          ContentContainerWithSort(
              5, data.currentSpeed!.toStringAsFixed(2), data.ip??'', 'Th/s',
              'min_speed_s'),
          ContentContainerWithSort(6, data.averageSpeed != null
              ? data.averageSpeed!.toStringAsFixed(2)
              : null, data.ip??'','Th/s avg','min_speed_s'),
          ContentContainerWithSort(7, data.tempInput, data.ip??'','tempInput','temp_input'),
          ContentContainerWithSort(8, data.tMax, data.ip??'','tepMax','temp_max'),
          ContentContainerWithSort(9, data.fans,data.ip??'','fans', 'null_list'),
          ContentContainerWithSort(10, data.mm,data.ip??'', 'mm'),
          ContentContainerWithSort(11, 'errors',data.ip??'', 'errors'),
          ContentContainerWithSort(12, data.ps,data.ip??'', 'ps'),
          ContentContainerWithSort(13, data.netFail,data.ip??'', 'net_fail'),
          ContentContainerWithSort(14, data.mm,data.ip??'', 'pool1'),
          //pool1
          ContentContainerWithSort(15, data.mm,data.ip??'','worker1'),
          //worker1
          ContentContainerWithSort(16, data.mm, data.ip??'','pool2'),
          //pool2
          ContentContainerWithSort(17, data.mm, data.ip??'','worker2'),
          //worker2
          ContentContainerWithSort(18, data.mm, data.ip??'','pool3'),
          //pool3
          ContentContainerWithSort(19, data.mm, data.ip??'','worker3'),
          //worker3
        ],
      ),
    ];
    for(int i=0; i < data.devices!.length; i++)
      {
        _tmp.add(Obx(()=>controller.isexpanded.value? AvalonDataRow(i,controller.device!.devices![i]) : Container()));
      }
    return GetBuilder<RaspController>(
      init: Get.find<RaspController>(tag: data.ip),
      id: 'list',
      builder: (_){
        List<Widget> _tmp = [
          Row(
            children: [
              Container(
                height: 40,
                width: 34,
                decoration: BoxDecoration(
                    border: Border.all()
                ),

                child: Obx(() =>
                    Checkbox(
                        value: scanListController.selectedIps.contains(data.ip),
                        onChanged: (value) {
                          scanListController.selectIp(data.ip ?? '', value!);
                        }
                    )
                ),
              ),
              ContentContainerWithSort(0, data.status, data.ip??'', 'status' ),
              ContentContainerWithSort(1, data.ip, data.ip??'', 'ip'),
              ContentContainerWithSort(2, data.company, data.ip??'', 'manufacture'),
              ContentContainerWithSort(3, data.model, data.ip??'', 'model'),
              ContentContainerWithSort(4, data.elapsedString, data.ip??'', 'elapsed'),
              //TODO do like normal format
              ContentContainerWithSort(
                  5, data.currentSpeed!.toStringAsFixed(2), data.ip??'', 'Th/s',
                  'min_speed_s'),
              ContentContainerWithSort(6, data.averageSpeed != null
                  ? data.averageSpeed!.toStringAsFixed(2)
                  : null, data.ip??'','Th/s avg','min_speed_s'),
              ContentContainerWithSort(7, data.tempInput, data.ip??'','tempInput','temp_input'),
              ContentContainerWithSort(8, data.tMax, data.ip??'','tepMax','temp_max'),
              ContentContainerWithSort(9, data.fans,data.ip??'','fans', 'null_list'),
              ContentContainerWithSort(10, data.mm,data.ip??'', 'mm'),
              ContentContainerWithSort(11, 'errors',data.ip??'', 'errors'),
              ContentContainerWithSort(12, data.ps,data.ip??'', 'ps'),
              ContentContainerWithSort(13, data.netFail,data.ip??'', 'net_fail'),
              ContentContainerWithSort(14, data.pools!.isNotEmpty? data.pools![0].addr:'',data.ip??'', 'pool1'),
              //pool1
              ContentContainerWithSort(15, data.pools!.isNotEmpty? data.pools![0].worker:'',data.ip??'','worker1'),
              //worker1
              ContentContainerWithSort(16, data.pools!.length>1? data.pools![1].addr:'', data.ip??'','pool2'),
              //pool2
              ContentContainerWithSort(17, data.pools!.length>1? data.pools![1].addr:'', data.ip??'','worker2'),
              //worker2
              ContentContainerWithSort(18, data.pools!.length>1? data.pools![2].addr:'', data.ip??'','pool3'),
              //pool3
              ContentContainerWithSort(19, data.pools!.length>1? data.pools![2].addr:'', data.ip??'','worker3'),
              //worker3
            ],
          ),
        ];
        List<Widget> _tmp2 = _.device!.devices!.map((e) =>
            Obx(()=>controller.isexpanded.value?
            AvalonDataRow(_.device!.devices!.indexOf(e),e, isRasp: true,)
                : Container())).toList();
        return Column(
          children: _tmp..addAll(_tmp2),
         // children: _.device!.devices!.map((e) => Obx(()=>controller.isexpanded.value? AvalonDataRow(0,e) : Container())).toList(),
        );
      },
    );
    /*
    return Obx(()=>Column(
        children: [

          controller.isexpanded.value? AvalonDataRow(0,data.devices![0]) : Container(),
        ],
      ),
    );


     */
  }
}
