import 'package:avalon_tool/analyzator/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/content_container.dart';
import 'package:avalon_tool/scan_list/rasp_controller.dart';
import 'package:avalon_tool/scan_list/resize_controller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvalonDataRow extends StatelessWidget {
  final int index;
  final dynamic data;
  final bool? isRasp;
  const AvalonDataRow(this.index, this.data, {Key? key, this.isRasp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    return MouseRegion(
      onHover: (event){controller.saveOffset(event);},
      child: GestureDetector(
            onDoubleTap: (){controller.onDoubleTap(data);},
            onTap: (){controller.selectByClick(index);},
            onSecondaryTap: (){controller.showPopup(index);},
            child: Stack(
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

                      child:isRasp==null?

                      GetBuilder<ScanListController>(
                          id: 'ips',
                          builder: (_){
                            return Checkbox(
                                value: _.selectedIps.contains(data.ip),
                                onChanged: (value) {
                                  _.selectIp(data.ip ?? '', value!);
                                }
                            );
                          }
                      )

                          : GetBuilder<RaspController>(
                        init: Get.find<RaspController>(tag: data.ip),
                        id: 'rasp_$index',
                        builder: (_){
                          return IndexedStack(
                            index: _.device.devices![index].led,
                            children: [
                              IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.lightbulb_outline, size: 15,)
                              ),
                              IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.lightbulb, size: 15,)
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ContentContainer(0, isRasp==null? data.status : 'auc ' +data.aucN.toString(),),
                    ContentContainer(1, data.ip),
                    ContentContainer(2, data.manufacture,),
                    ContentContainer(3, data.model,),
                    ContentContainer(4, data.elapsedString,),
                    //TODO do like normal format
                    ContentContainer(5, data.currentSpeed, 'min_speed', data.model),
                    ContentContainer(6, data.averageSpeed, 'min_speed', data.model),
                    ContentContainer(7, data.tInput, 'temp_input'),
                    ContentContainer(8, data.tMax, 'temp_max'),
                    ContentContainer(9, data.fans,'null_list'),
                    ContentContainer(10, data.mm,),
                    ContentContainer(11, data.errors,),
                    ContentContainer(12, data.ps,),
                    ContentContainer(13, data.netFail,),
                    ContentContainer(14, isRasp==null? data.pools!=null? data.pools!.pools![0].url:'':'',),
                    //pool1
                    ContentContainer(15, isRasp==null? data.pools!=null? data.pools!.pools[0].worker:'':'',),
                    //worker1
                    ContentContainer(16, isRasp==null? data.pools!=null? data.pools!.pools.length>1? data.pools.pools![1].url:'' :'':'',),
                    //pool2
                    ContentContainer(17, isRasp==null? data.pools!=null? data.pools!.pools.length>1? data.pools.pools![1].worker:'':'':'',),
                    //worker2
                    ContentContainer(18, isRasp==null? data.pools!=null? data.pools!.pools.length>2? data.pools.pools![2].url:'':'':'',),
                    //pool3
                    ContentContainer(19, isRasp==null?data.pools!=null? data.pools!.pools.length>2? data.pools.pools![2].worker:'':'':'',),
                    //worker3
                  ],
                ),
               GetBuilder<ScanListController>(
                 id: 'mouse',
                   builder: (_){
                 return  Positioned(
                   left: _.mousePosition.value-15,
                   child: GetBuilder<ScanListController>(
                     id: 'popup',
                     builder: (_){
                       return Visibility(
                           replacement: Container(),
                           visible: _.isPopupVisible.value==index?true:false,
                           child: MouseRegion(
                             onExit: (value){controller.showPopup(-1);},
                             child: SizedBox(
                               width: 200,
                               height: 50,
                               child: Card(
                                 //color: Get.theme.cardTheme.color,
                                 color: Colors.grey,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10.0),
                                       child: InkWell(
                                           onTap: (){controller.openInBrowser(index);},
                                           child: Text('open_browser'.tr, textAlign: TextAlign.start,)),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           )
                       );
                     },
                   )
                   );

               }
                 )
              ],
            ),
          ),
    );
  }
}
