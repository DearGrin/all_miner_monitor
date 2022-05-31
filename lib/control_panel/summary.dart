import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Summary extends GetView<ScanListController> {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScanListController controller = Get.put(ScanListController());
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      splashRadius: 25.0,
                      onPressed: (){controller.showProblemList();},
                      icon: const Icon(Icons.loupe_outlined),
                      tooltip: 'problems_to_list'.tr,
                  ),
                  IconButton(
                      splashRadius: 25.0,
                      onPressed: (){controller.switchViewSummaryMode();},
                      icon: Icon(controller.summaryViewMode==0? Icons.list_alt_outlined : Icons.settings_overscan_outlined),
                      tooltip: 'toggle_view'.tr,
                  )
                ],
              ),
            ),
            GetBuilder<ScanListController>(
                id: 'summary_view',
                builder: (_){
             return IndexedStack(
               index: controller.summaryViewMode,
               children: [
                 Row(
                   children: [
                     Expanded(
                       flex: 1,
                       child: GetBuilder<ScanListController>(
                           id: 'summary',
                           builder: (_) {
                             return Column(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text('SHA256'),
                                 Text('devices'.trParams({'value':controller.summary.countSHA256.toString()})),
                                 Text('total'.trParams({'value':controller.summary.totalHashSHA256.toStringAsFixed(2)})),
                                 Text('average'.trParams({'value':(controller.summary.averageHashSHA256/(controller.summary.countSHA256==0?1:controller.summary.countSHA256)).toStringAsFixed(2)})),
                               ],
                             );
                           }
                       ),
                     ),
                     Expanded(
                       flex: 1,
                       child: GetBuilder<ScanListController>(
                         id: 'summary',
                         builder: (_){
                           return Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text('SCRYPT'),
                               Text('devicesGH'.trParams({'value':controller.summary.countSCRYPT.toString()})),
                               Text('totalGH'.trParams({'value':(controller.summary.totalHashSCRYPT/1000).toStringAsFixed(2)})),
                               Text('averageGH'.trParams({'value':((controller.summary.averageHashSCRYPT/(controller.summary.countSCRYPT==0?1:controller.summary.countSCRYPT))).toStringAsFixed(2)})),
                             ],
                           );
                         },
                       ),
                     ),
                   ],
                 ),
                 Row(
                   children: [
                     Expanded(
                       flex: 1,
                       child: GetBuilder<ScanListController>(
                           id: 'summary',
                           builder: (_) {
                             return Column(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('scan_res'.trParams({'value':'${controller.devices.length}/${controller.summary.totalProgress}'})),
                                 Text('speed_error'.trParams({'value':'${controller.summary.speedErrors.length}'})),
                                 Text('temp_error'.trParams({'value':'${controller.summary.tempErrors.length}'})),
                                 Text('fan_error'.trParams({'value':'${controller.summary.fanErrors.length}'})),
                               ],
                             );
                           }
                       ),
                     ),
                     Expanded(
                       flex: 1,
                       child: GetBuilder<ScanListController>(
                         id: 'summary',
                         builder: (_){
                           return Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('error_count'.trParams({'value':'${controller.summary.withErrors}'})),
                               Text('hash_count_error'.trParams({'value':'${controller.summary.hashCountErrors.length}'})),
                               Text('chip_count_error'.trParams({'value':'${controller.summary.chipCountErrors.length}'})),
                               Text('chip_s_error'.trParams({'value':'${controller.summary.chipsSErrors.length}'})),
                             ],
                           );
                         },
                       ),
                     ),
                   ],
                 ),
               ],
             );
            }
            )
          ],
        ),
      ),
    );
  }
}
