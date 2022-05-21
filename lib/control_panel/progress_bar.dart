import 'package:AllMinerMonitor/control_panel/control_panel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControlPanelController controller = Get.put(ControlPanelController());
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Obx(()=>Stack(
        children: [
          SizedBox(
            height: 20,
            child: LinearProgressIndicator(
                value: controller.progress.value,
               // backgroundColor: Get.theme.cardColor,
             //   color: Colors.blue,
              ),
          ),
          Align(
            alignment: Alignment.center,
              child: Text(
                'progress'.trParams({'value':(controller.progress.value*100).toStringAsFixed(2)})
              )
          ),
        ],
      ),
      ),
    );
  }
}
