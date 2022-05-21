import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorsDebugger extends StatelessWidget {
  const ErrorsDebugger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    return Container(
      width: 700,
      height: Get.height*0.8,
      color: Theme.of(context).cardTheme.color,
      child: SingleChildScrollView(
        child: Obx(()=>Column(
            children: controller.errors.map((e) => Wrap(children:
            [SelectableText(e, style: Theme.of(context).textTheme.bodyText1,)],)).toList(),
          ),
        ),
      ),
    );
  }
}
