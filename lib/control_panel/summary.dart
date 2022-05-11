import 'package:avalon_tool/scan_list/scan_list_controller.dart';
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
        child: Row(
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
                        Text('SHA256'),
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
                        Text('SCRYPT'),
                        Text('devicesGH'.trParams({'value':controller.summary.countSCRYPT.toString()})),
                        Text('totalGH'.trParams({'value':(controller.summary.totalHashSCRYPT/1000).toStringAsFixed(2)})),
                        Text('averageGH'.trParams({'value':((controller.summary.averageHashSCRYPT/(controller.summary.countSCRYPT==0?1:controller.summary.countSCRYPT))/1000).toStringAsFixed(2)})),
                      ],
                    );
                  },
                ),
                ),
          ],
        ),
      ),
    );
  }
}
