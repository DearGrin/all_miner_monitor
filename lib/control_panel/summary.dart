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
                        Text('devices'.trParams({'value':controller.summary.count.toString()})),
                        Text('total'.trParams({'value':controller.summary.totalHash.toStringAsFixed(2)})),
                        Text('average'.trParams({'value':(controller.summary.averageHash/controller.summary.count).toStringAsFixed(2)})),
                      ],
                    );
                  }
                ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('with_errors'.trParams({'value':controller.summary.count.toString()})),
                    Text('max_temp'.trParams({'value':controller.summary.count.toString()})),
                    const Text(''),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
