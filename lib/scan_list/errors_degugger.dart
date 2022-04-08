import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorsDebugger extends StatelessWidget {
  const ErrorsDebugger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    return Container(
      width: 500,
      height: 700,
      color: Theme.of(context).cardTheme.color,
      child: SingleChildScrollView(
        child: Obx(()=>Column(
            children: controller.errors.map((e) => Wrap(children:
            [Text(e, style: Theme.of(context).textTheme.bodyText1,)],)).toList(),
          ),
        ),
      ),
    );
  }
}
