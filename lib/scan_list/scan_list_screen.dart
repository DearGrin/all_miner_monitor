import 'package:avalon_tool/antminer/antminer_model.dart';
import 'package:avalon_tool/avalon_10xx/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/data_row.dart';
import 'package:avalon_tool/scan_list/errors_degugger.dart';
import 'package:avalon_tool/scan_list/rasberry_row.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanListScreen extends StatelessWidget{
  ScanListScreen({Key? key}) : super(key: key);
  final ScanListController controller = Get.put(ScanListController());
  final ResizeController resizeController = Get.put(ResizeController());
  final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        actions: [
          OutlinedButton(
              onPressed: (){Get.defaultDialog(
                title: 'Errors',
                content: const ErrorsDebugger(),
              );},
              child: Text('show errors', style: Theme.of(context).textTheme.bodyText1,)
          )
        ],
      ),
      body: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Obx(()=>Container(
              padding: const EdgeInsets.all(8.0),
                  width: resizeController.maxWidth.value,
                  child: Column(
                    children: [
                      tableHeader(context),
                      GetBuilder<ScanListController>(
                        id: 'list',
                        builder: (_) {
                          return Expanded(
                            child: ListView.separated(
                                itemCount: _.devices.length,
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                                itemBuilder: (BuildContext context, int index){
                                  return
                                    infoRow(
                                      index,
                                      context,
                                      controller.devices[index],
                                  );
                                }
                              ),
                          );
                        }
                      ),
                    ],
                  )
                  ),
            )
            ),
      )
      );
  }
  Widget infoRow(int index, BuildContext context, dynamic data) {
    if (data.runtimeType == AvalonData)
    {
      return AvalonDataRow(index, data);
      /*
      return Row(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all()
            ),
            child: Obx(() =>
                Checkbox(
                    value: controller.selectedIps.contains(data.ip),
                    onChanged: (value) {
                      controller.selectIp(data.ip ?? '', value!);
                    }
                )
            ),
          ),
          contentContainer(0, data.status, index, context),
          contentContainer(1, data.ip, index, context),
          contentContainer(2, data.company, index, context),
          contentContainer(3, data.model, index, context),
          contentContainer(4, data.elapsedString, index, context),
          //TODO do like normal format
          contentContainer(
              5, data.currentSpeed!.toStringAsFixed(2), index, context,
              'min_speed_s'),
          contentContainer(6, data.averageSpeed != null
              ? data.averageSpeed!.toStringAsFixed(2)
              : null, index, context, 'min_speed_s'),
          contentContainer(7, data.tempInput, index, context, 'temp_input'),
          contentContainer(8, data.tMax, index, context, 'temp_max'),
          contentContainer(9, data.fans, index, context, 'null_list'),
          contentContainer(10, data.mm, index, context),
          contentContainer(11, 'errors', index, context),
          contentContainer(12, data.ps, index, context),
          contentContainer(13, data.netFail, index, context),
          contentContainer(14, data.mm, index, context),
          //pool1
          contentContainer(15, data.mm, index, context),
          //worker1
          contentContainer(16, data.mm, index, context),
          //pool2
          contentContainer(17, data.mm, index, context),
          //worker2
          contentContainer(18, data.mm, index, context),
          //pool3
          contentContainer(19, data.mm, index, context),
          //worker3
        ],
      );


       */
  }
    else if (data.runtimeType == RaspberryAva){
      RaspberryAva rasp = data;
      return RasberryDataRow(index, data);
    }
    else if (data.runtimeType == AntMinerModel){
      return AvalonDataRow(index, data);
    }
    else{
      return Container();
    }

  }
  Widget contentContainer(int index, dynamic value, rowIndex, BuildContext context, [String? type]){

    return GetBuilder<ResizeController>(
      id: 'content_$index',
      builder: (_) {
        if(_.headers[index].isVisible??true) {
          return Obx(() =>
              Container(
                height: 40,
                width: resizeController.widths[index],
                decoration: BoxDecoration(border: Border.all()),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: analyseResolver.getColor(type, value)),// TODO get different values
                ),
              ),
          );
        }
        else{
          return Container();
        }
      }
    );
  }
  Widget tableContainer(int index, String? value, BuildContext context ){
    String _value = '$value'.tr;
      return GetBuilder<ResizeController>(
        id: 'header_$index',
        builder: (_) {
          if(_.headers[index].isVisible??true) {
            return Obx(() =>
                InkWell(
                  onTap: () {
                    resizeController.onClick(index);
                  },
                  child: Container(
                      height: 50,
                      width: resizeController.widths[index],
                      decoration: BoxDecoration(border: Border.all(), color: Theme.of(context).cardTheme.color,),
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              _value, overflow: TextOverflow.ellipsis,),
                          ),
                          Obx(() =>
                              Positioned(
                                right: 5,
                                top: 10,
                                child: IndexedStack(
                                  index: resizeController.sort[index],
                                  children: [
                                    Container(),
                                    const Icon(Icons.arrow_downward_outlined),
                                    const Icon(Icons.arrow_upward_outlined)
                                  ],
                                ),
                              ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeColumn,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (var value) {
                                  resizeController.onDrag(index, value.delta);
                                },
                                child: Container(
                                  width: 10,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ),
            );
          }
          else{
            return Container();
          }
        }
      );


  }
  Widget tableHeader(BuildContext context){
    List<Widget> _tmp = [
      Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(), color: Theme.of(context).cardTheme.color,
        ),
        child: GetBuilder<ScanListController>(
            id: 'header',
            builder: (controller) =>Checkbox(
                value: controller.isSelected,
                onChanged: (value){controller.selectAll(value!);}
            )
        ),
      ),
    ];
    for(int i =0; i < resizeController.headers.length; i++ ){
      _tmp.add(tableContainer(i, resizeController.headers[i].label, context
          ));
    }
   return Row(
     children: _tmp,
    );
  }
}
