import 'package:AllMinerMonitor/command_panel/command_panel_ui.dart';
import 'package:AllMinerMonitor/control_panel/control_panel_controller.dart';
import 'package:AllMinerMonitor/control_panel/progress_bar.dart';
import 'package:AllMinerMonitor/control_panel/reboot_ui.dart';
import 'package:AllMinerMonitor/control_panel/scan_list_controls.dart';
import 'package:AllMinerMonitor/control_panel/summary.dart';
import 'package:AllMinerMonitor/pools_editor/set_pool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlViewport extends StatelessWidget {
  const ControlViewport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControlPanelController controller = Get.put(ControlPanelController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          flex: 2,
            child: ScanListControls()),
        Expanded(
          flex: 8,
          child: Obx(()=>IndexedStack(
              index: controller.currentIndex.value,
              children: [
                const Summary(),
                SetPool(),
                const RebootUI(),
                CommandPanelUi(),
              ],
            ),
          ),
        ),
        const ProgressBar(),
      ],
    );
  }
}
