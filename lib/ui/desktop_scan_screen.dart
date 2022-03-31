import 'package:avalon_tool/control_panel/control_viewport.dart';
import 'package:avalon_tool/ip_section/ip_ui.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/scan_list/scan_list_screen.dart';
import 'package:avalon_tool/control_panel/scan_list_controls.dart';
import 'package:avalon_tool/control_panel/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopScanScreen extends GetView<ScanListController> {
  const DesktopScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: IpUI(),
                  ),
                  Expanded(
                      flex: 6,
                      child: ControlViewport()
                  ),
                ],
              ),
          ),
         Expanded(
              flex: 7,
              child: ScanListScreen()
          ),
        ],
      ),
    );
  }
}
