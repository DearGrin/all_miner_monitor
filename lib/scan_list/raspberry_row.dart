import 'package:avalon_tool/models/device_model.dart';
import 'package:avalon_tool/utils/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/content_container.dart';
import 'package:avalon_tool/scan_list/content_container_with_sort.dart';
import 'package:avalon_tool/scan_list/data_row.dart';
import 'package:avalon_tool/scan_list/rasp_content.dart';
import 'package:avalon_tool/scan_list/rasp_controller.dart';
import 'package:avalon_tool/scan_list/resize_controller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
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
    //controller.setData(widget.data);

      // return RaspContent(widget.data.ip??'', widget.data, controller);
    /*
    return ValueListenableBuilder<bool>(
        valueListenable: _counter,
        builder: (BuildContext context, bool value, Widget? child){
          return value? r(scanListController, controller) : Container();
        }
    );


     */
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
            ContentContainerWithSort(14, widget.data.mm,widget.data.ip??'', 'pool1'),
            //pool1
            ContentContainerWithSort(15, widget.data.mm,widget.data.ip??'','worker1'),
            //worker1
            ContentContainerWithSort(16, widget.data.mm, widget.data.ip??'','pool2'),
            //pool2
            ContentContainerWithSort(17, widget.data.mm, widget.data.ip??'','worker2'),
            //worker2
            ContentContainerWithSort(18, widget.data.mm, widget.data.ip??'','pool3'),
            //pool3
            ContentContainerWithSort(19, widget.data.mm, widget.data.ip??'','worker3'),
            //worker3
          ],
        ),
        RaspContent(widget.data.ip??''),
          ],


    );
   // return r(scanListController, controller);
   // return RaspContent(widget.data.ip??'', widget.data, controller);
    /*
        return Obx(()=> Column(
            children: devices(controller.device.value.devices??[], controller, scanListController),
          ),
        );


     */

/*
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
                    value: scanListController.selectedIps.contains(widget.data.ip),
                    onChanged: (value) {
                      scanListController.selectIp(widget.data.ip ?? '', value!);
                    }
                )
            ),
          ),
          ContentContainerWithSort(0, widget.data.status, widget.data.ip??'', 'status' ),
          ContentContainerWithSort(1, widget.data.ip, widget.data.ip??'', 'ip'),
          ContentContainerWithSort(2, widget.data.company, widget.data.ip??'', 'manufacture'),
          ContentContainerWithSort(3, widget.data.model, widget.data.ip??'', 'model'),
          ContentContainerWithSort(4, widget.data.elapsedString, widget.data.ip??'', 'elapsed'),
          //TODO do like normal format
          ContentContainerWithSort(
              5, widget.data.currentSpeed!.toStringAsFixed(2), widget.data.ip??'', 'Th/s',
              'min_speed_s'),
          ContentContainerWithSort(6, widget.data.averageSpeed != null
              ? widget.data.averageSpeed!.toStringAsFixed(2)
              : null, widget.data.ip??'','Th/s avg','min_speed_s'),
          ContentContainerWithSort(7, widget.data.tempInput, widget.data.ip??'','tempInput','temp_input'),
          ContentContainerWithSort(8, widget.data.tMax, widget.data.ip??'','tepMax','temp_max'),
          ContentContainerWithSort(9, widget.data.fans,widget.data.ip??'','fans', 'null_list'),
          ContentContainerWithSort(10, widget.data.mm,widget.data.ip??'', 'mm'),
          ContentContainerWithSort(11, 'errors',widget.data.ip??'', 'errors'),
          ContentContainerWithSort(12, widget.data.ps,widget.data.ip??'', 'ps'),
          ContentContainerWithSort(13, widget.data.netFail,widget.data.ip??'', 'net_fail'),
          ContentContainerWithSort(14, widget.data.mm,widget.data.ip??'', 'pool1'),
          //pool1
          ContentContainerWithSort(15, widget.data.mm,widget.data.ip??'','worker1'),
          //worker1
          ContentContainerWithSort(16, widget.data.mm, widget.data.ip??'','pool2'),
          //pool2
          ContentContainerWithSort(17, widget.data.mm, widget.data.ip??'','worker2'),
          //worker2
          ContentContainerWithSort(18, widget.data.mm, widget.data.ip??'','pool3'),
          //pool3
          ContentContainerWithSort(19, widget.data.mm, widget.data.ip??'','worker3'),
          //worker3
        ],
      ),
    ];


 */

/*
    for(int i=0; i < widget.data.devices!.length; i++)
      {
        _tmp.add(Obx(()=>controller.isexpanded.value? AvalonDataRow(i,controller.device!.devices![i]) : Container()));
      }


 */





/*
        List<Widget> _tmp2 = [
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
                        value: scanListController.selectedIps.contains(widget.data.ip),
                        onChanged: (value) {
                          scanListController.selectIp(widget.data.ip ?? '', value!);
                        }
                    )
                ),
              ),
              ContentContainerWithSort(0, widget.data.status, widget.data.ip??'', 'status' ),
              ContentContainerWithSort(1, widget.data.ip, widget.data.ip??'', 'ip'),
              ContentContainerWithSort(2, widget.data.company, widget.data.ip??'', 'manufacture'),
              ContentContainerWithSort(3, widget.data.model, widget.data.ip??'', 'model'),
              ContentContainerWithSort(4, widget.data.elapsedString, widget.data.ip??'', 'elapsed'),
              //TODO do like normal format
              ContentContainerWithSort(
                  5, widget.data.currentSpeed!.toStringAsFixed(2), widget.data.ip??'', 'Th/s',
                  'min_speed_s'),
              ContentContainerWithSort(6, widget.data.averageSpeed != null
                  ? widget.data.averageSpeed!.toStringAsFixed(2)
                  : null, widget.data.ip??'','Th/s avg','min_speed_s'),
              ContentContainerWithSort(7, widget.data.tempInput, widget.data.ip??'','tempInput','temp_input'),
              ContentContainerWithSort(8, widget.data.tMax, widget.data.ip??'','tepMax','temp_max'),
              ContentContainerWithSort(9, widget.data.fans,widget.data.ip??'','fans', 'null_list'),
              ContentContainerWithSort(10, widget.data.mm,widget.data.ip??'', 'mm'),
              ContentContainerWithSort(11, 'errors',widget.data.ip??'', 'errors'),
              ContentContainerWithSort(12, widget.data.ps,widget.data.ip??'', 'ps'),
              ContentContainerWithSort(13, widget.data.netFail,widget.data.ip??'', 'net_fail'),
              ContentContainerWithSort(14, widget.data.pools!.isNotEmpty? widget.data.pools![0].addr:'',widget.data.ip??'', 'pool1'),
              //pool1
              ContentContainerWithSort(15, widget.data.pools!.isNotEmpty? widget.data.pools![0].worker:'',widget.data.ip??'','worker1'),
              //worker1
              ContentContainerWithSort(16, widget.data.pools!.length>1? widget.data.pools![1].addr:'', widget.data.ip??'','pool2'),
              //pool2
              ContentContainerWithSort(17, widget.data.pools!.length>1? widget.data.pools![1].addr:'', widget.data.ip??'','worker2'),
              //worker2
              ContentContainerWithSort(18, widget.data.pools!.length>1? widget.data.pools![2].addr:'', widget.data.ip??'','pool3'),
              //pool3
              ContentContainerWithSort(19, widget.data.pools!.length>1? widget.data.pools![2].addr:'', widget.data.ip??'','worker3'),
              //worker3
            ],
          ),
        ];

 */
        /*
        List<Widget> _tmp3 = controller.device!.devices!.map((e) =>
            Obx(()=>controller.isexpanded.value?
            AvalonDataRow(controller.device!.devices!.indexOf(e),e, isRasp: true,)
                : Container())).toList();


         */
    /*
        return Column(
          children: _tmp,
           // children: _tmp.addAll(controller.device!.devices!.map((e) => Obx(()=>controller.isexpanded.value? AvalonDataRow(1,e) : Container())).toList())
        );

     */
         /*
        return Obx(()=> Column(
          children: controller.device!=null&&controller.device!.devices!=null ?
          controller.device!.devices!.map((e) => Obx(()=>controller.isexpanded.value? AvalonDataRow(0,e) : Container())).toList()
          : [Container()],
          //  children: _tmp..addAll(_tmp2),
           // children: [Container()],
           // children: _.device!.devices!.map((e) => Obx(()=>controller.isexpanded.value? AvalonDataRow(0,e) : Container())).toList(),
          ),
        );


          */




    /*
    return Obx(()=>Column(
        children: [

          controller.isexpanded.value? AvalonDataRow(0,data.devices![0]) : Container(),
        ],
      ),
    );


     */
  }
  List<Widget> devices(List<AvalonData> devices, RaspController controller, ScanListController scanListController){
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
              5, widget.data.currentSpeed!.toStringAsFixed(2), widget.data.ip??'', 'Th/s',
              'min_speed_s'),
          ContentContainerWithSort(6, widget.data.averageSpeed != null
              ? widget.data.averageSpeed!.toStringAsFixed(2)
              : null, widget.data.ip??'','Th/s avg','min_speed_s'),
          ContentContainerWithSort(7, widget.data.tInput, widget.data.ip??'','tempInput','temp_input'),
          ContentContainerWithSort(8, widget.data.tMax, widget.data.ip??'','tepMax','temp_max'),
          ContentContainerWithSort(9, widget.data.fans,widget.data.ip??'','fans', 'null_list'),
          ContentContainerWithSort(10, widget.data.mm,widget.data.ip??'', 'mm'),
          ContentContainerWithSort(11, 'errors',widget.data.ip??'', 'errors'),
          ContentContainerWithSort(12, widget.data.ps,widget.data.ip??'', 'ps'),
          ContentContainerWithSort(13, widget.data.netFail,widget.data.ip??'', 'net_fail'),
          ContentContainerWithSort(14, widget.data.mm,widget.data.ip??'', 'pool1'),
          //pool1
          ContentContainerWithSort(15, widget.data.mm,widget.data.ip??'','worker1'),
          //worker1
          ContentContainerWithSort(16, widget.data.mm, widget.data.ip??'','pool2'),
          //pool2
          ContentContainerWithSort(17, widget.data.mm, widget.data.ip??'','worker2'),
          //worker2
          ContentContainerWithSort(18, widget.data.mm, widget.data.ip??'','pool3'),
          //pool3
          ContentContainerWithSort(19, widget.data.mm, widget.data.ip??'','worker3'),
          //worker3
        ],
      ),
    ];
    for(int i = 0; i < devices.length; i++){
      _tmp.add(Obx(()=>controller.isexpanded.value? AvalonDataRow(i,controller.device.devices![i], isRasp: true,) : Container()));
    }
    return _tmp;
  }
  Widget r(ScanListController scanListController, RaspController controller){


          return Column(
            children: devices(controller.device.devices??[], controller, scanListController),
          );


  }
}
