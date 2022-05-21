import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/content_container.dart';
import 'package:AllMinerMonitor/scan_list/content_container_with_sort.dart';
import 'package:AllMinerMonitor/scan_list/data_row.dart';
import 'package:AllMinerMonitor/scan_list/rasp_content.dart';
import 'package:AllMinerMonitor/scan_list/rasp_controller.dart';
import 'package:AllMinerMonitor/scan_list/resize_controller.dart';
import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RasberryDataRow extends StatefulWidget {
  final int index;
  final DeviceModel data;
 const RasberryDataRow(this.index, this.data, {Key? key}) : super(key: key);
 // final RaspController controller = Get.put(RaspController(), tag: '10.10.10.1');

  @override
  State<RasberryDataRow> createState() => _RasberryDataRowState();
}

class _RasberryDataRowState extends State<RasberryDataRow> {
  late RaspController controller;
 // RxBool isReady = false.obs;
  ///final ValueNotifier<bool> _counter = ValueNotifier<bool>(false);
  @override
  void initState() {
    // TODO: implement initState
 // controller = await Get.putAsync<RaspController>(() async => RaspController(), tag: widget.data.ip);
   controller = Get.put(RaspController(widget.data), tag: widget.data.ip); //TODO pass arguments to avoid set data
  // isReady.value = true;
  // await Future.delayed(Duration(seconds: 1));
   //_counter.value = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   // final RaspController controller = Get.putAsync<RaspController>(() async => await RaspController(), tag: widget.data.ip);
  //  final RaspController controller = Get.put(RaspController(), tag: widget.data.ip);
    final ScanListController scanListController = Get.put(ScanListController());
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 34,
              decoration: BoxDecoration(
                  border: Border.all(),
                color: Theme.of(context).cardTheme.color,
              ),

              child: Obx(() =>
                  Checkbox(
                      value: scanListController.selectedIps.contains(widget.data.ip),
                      onChanged: (value) {
                        scanListController.selectIp(widget.data.ip ?? '', value!);
                      }
                  )
              ),
            ),
            ContentContainerWithSort(0, widget.data.status, widget.data.ip??'', 'status' ),
            ContentContainerWithSort(1, widget.data.ip, widget.data.ip??'', 'ip'),
            ContentContainerWithSort(2, widget.data.manufacture, widget.data.ip??'', 'manufacture'),
            ContentContainerWithSort(3, widget.data.model, widget.data.ip??'', 'model'),
            ContentContainerWithSort(4, widget.data.elapsedString, widget.data.ip??'', 'elapsed'),
            //TODO do like normal format
            ContentContainerWithSort(
                5, widget.data.currentSpeed, widget.data.ip??'', 'Th/s',
                'min_speed'),
            ContentContainerWithSort(6, widget.data.averageSpeed, widget.data.ip??'','Th/s avg','min_speed'),
            ContentContainerWithSort(7, widget.data.tInput, widget.data.ip??'','tempInput','temp_input'),
            ContentContainerWithSort(8, widget.data.tMax, widget.data.ip??'','tepMax','temp_max'),
            ContentContainerWithSort(9, widget.data.fans,widget.data.ip??'','fans', 'null_list'),
            ContentContainerWithSort(10, widget.data.mm,widget.data.ip??'', 'mm'),
            ContentContainerWithSort(11, 'errors',widget.data.ip??'', 'errors'),
            ContentContainerWithSort(12, widget.data.ps,widget.data.ip??'', 'ps'),
            ContentContainerWithSort(13, widget.data.netFail,widget.data.ip??'', 'net_fail'),
            ContentContainerWithSort(14, widget.data.pools?.pools?[0].url,widget.data.ip??'', 'pool1'),
            ContentContainerWithSort(15, widget.data.pools?.pools?[0].worker,widget.data.ip??'','worker1'),
            ContentContainerWithSort(16, widget.data.pools?.pools?[1].url, widget.data.ip??'','pool2'),
            ContentContainerWithSort(17, widget.data.pools?.pools?[1].worker, widget.data.ip??'','worker2'),
            ContentContainerWithSort(18, widget.data.pools?.pools?[2].url, widget.data.ip??'','pool3'),
            ContentContainerWithSort(19, widget.data.pools?.pools?[2].worker, widget.data.ip??'','worker3'),
          ],
        ),
        RaspContent(widget.data.ip??''),
          ],
    );
  }
}
