import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutTile extends StatelessWidget {
 final String layoutTag;

  const LayoutTile(this.layoutTag, {Key? key}) : super(key: key);
 @override
 Widget build(BuildContext context) {
   final LayoutTileController controller = Get.find(tag: layoutTag);
   return SizedBox(
     width: 350,
     child: Card(
       color: Theme.of(context).cardColor,
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             SizedBox(
               height: 50,
               child: Stack(
                 children: [
                   Align(
                       alignment: Alignment.center,
                       child: Text('${controller.layout.tag}', style: Theme.of(context).textTheme.bodyText2,)),
                   Positioned(
                     left: -5,
                     top: -10,
                     child: GetBuilder<LayoutTileController>(
                       init: controller,
                       id: 'anim_$layoutTag',
                       builder: (_){
                         return  RotationTransition(
                             turns: controller.animation,
                             child: IconButton(
                                 onPressed: (){controller.scan(true);},
                                 icon: const Icon(Icons.refresh)));
                       },
                     ),


                     /*
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){controller.scan();},
                          icon: const Icon(Icons.refresh,)
                      ),
                      */
                   ),
                   Positioned(
                     right: 60,
                     top: -10,
                     child: IconButton(
                       padding: const EdgeInsets.all(0),
                       iconSize: 20,
                       splashRadius: 1.0,
                       onPressed: (){controller.showGraphs();},
                       icon:  const Icon(Icons.stacked_line_chart_outlined),
                       tooltip: 'graphs'.tr,
                     ),

                   ),
                   Positioned(
                     right: 30,
                     top: -10,
                     child: Obx(()=>IconButton(
                       padding: const EdgeInsets.all(0),
                       iconSize: 20,
                       splashRadius: 1.0,
                       onPressed: (){controller.switchMode();},
                       icon:  Icon(controller.viewMode.value==0? Icons.list_alt_outlined : Icons.settings_overscan_outlined),
                       tooltip: 'toggle_view'.tr,
                     ),
                     ),
                   ),
                   Positioned(
                     right: -5,
                     top: -10,
                     child: IconButton(
                         padding: const EdgeInsets.all(0),
                         iconSize: 20,
                         splashRadius: 1.0,
                         onPressed: (){controller.openMenu();},
                         icon: const Icon(Icons.more_vert_outlined,)
                     ),
                   ),
                   Obx(()=>controller.isMenuOpen.value? Align(
                     alignment: Alignment.topCenter,
                     child: MouseRegion(
                       onExit: (event){controller.closeMenu();},
                       child: Card(
                         color: Theme.of(context).cardColor,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               OutlinedButton(onPressed: (){controller.onEditTagClick();}, child: Text('rename'.tr)),
                               OutlinedButton(onPressed: (){controller.editLayout();}, child: Text('edit'.tr)),
                               OutlinedButton(onPressed: (){controller.deleteLayout();}, child: Text('delete'.tr))
                             ],
                           ),
                         ),
                       ),
                     ),
                   ) : Container(),
                   ),
                 ],
               ),
             ),
             const SizedBox(
               height: 10,
             ),
             Obx(()=>IndexedStack(
               index: controller.viewMode.value,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Obx(()=> Text('scan_res'.trParams({'value':'${controller.scannedDevices.value}/${controller.layout.ips?.length}'}))),
                             const Divider(),
                             const Text('SHA256'),
                             Obx(()=>Text('devices'.trParams({'value':'${controller.deviceCountSHA256}'})),),
                             Obx(()=>Text('total'.trParams({'value':(controller.speedSHA256).toStringAsFixed(2)}))),
                             Obx(()=>Text('average'.trParams({'value':(controller.speedAvgSHA256).toStringAsFixed(2)}))),
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Obx(()=>Text('with_problems'.trParams({'value':'${controller.totalErrors.length}'})),),
                             const Divider(),
                             const Text('SCRYPT'),
                             Obx(()=>Text('devicesGH'.trParams({'value':'${controller.deviceCountSCRYPT}'})),),
                             Obx(()=>Text('totalGH'.trParams({'value':(controller.speedSCRYPT/1000).toStringAsFixed(2)}))),
                             Obx(()=>Text('averageGH'.trParams({'value':(controller.speedAvgSCRYPT).toStringAsFixed(2)}))),
                           ],
                         ),
                       ],
                     ),
                   ],
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Obx(()=>Text('speed_error'.trParams({'value':'${controller.speedErrors.length}'})),),
                             Obx(()=>Text('temp_error'.trParams({'value':'${controller.tempErrors.length}'}))),
                             Obx(()=>Text('fan_error'.trParams({'value':'${controller.fanErrors.length}'})),),
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Obx(()=>Text('hash_count_error'.trParams({'value':'${controller.hashCountErrors.length}'})),),
                             Obx(()=>Text('chip_count_error'.trParams({'value':'${controller.chipCountErrors.length}'}))),
                             Obx(()=>Text('chip_s_error'.trParams({'value':'${controller.chipsSErrors.length}'})),),
                           ],
                         ),
                       ],
                     ),
                     const SizedBox(height: 5.0,),
                     OutlinedButton(
                         onPressed: (){controller.showMore();},
                         child: Text('more'.tr)
                     ).marginAll(10.0)
                   ],
                 ),
               ],
             ),
             ),
             const  SizedBox(
               height: 10,
             ),
             Row(
               children: [
                 Expanded(child: OutlinedButton(onPressed: (){controller.openLayout();}, child: Text('details'.tr))),
               ],
             ),
             const SizedBox(
               height: 5,
             ),
             Obx(()=> LinearProgressIndicator(
               value: controller.progress.value,
             ),
             ),
             Obx(()=>Text('last_scan'.trParams({'value':controller.lastScanTime.value}))),
           ],
         ),
       ),
     ),
   );
 }

}

