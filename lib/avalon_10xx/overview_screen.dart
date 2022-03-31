import 'package:avalon_tool/avalon_10xx/controller_avalon.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/ui/hashboard_display.dart';
import 'package:avalon_tool/ui/miner_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mock_data.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final AvalonController controller = Get.put(AvalonController('10.10.10.10', 1111));
    final ScanListController controller = Get.put(ScanListController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.currentDevice.value.ip??''),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
          onPressed: (){Get.back();},
        ),
        actions: [
          IconButton(
            onPressed: (){controller.onModeSwitch(0);},
            icon: Icon(Icons.title),
            tooltip: 'temp_map'.tr,
          ),
          IconButton(
            onPressed: (){controller.onModeSwitch(1);},
            icon: Icon(Icons.work),
            tooltip: 'work_map'.tr,
          ),
        ],
      ),
      body: Card(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [

                  Expanded(
                    flex: 3,
                      child: MinerInfo()
                  ),
                 Expanded(
                    flex: 7,
                      child: HashboardDisplay(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
