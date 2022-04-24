import 'package:avalon_tool/miner_overview/antminer_hashboards.dart';
import 'package:avalon_tool/miner_overview/antminer_info.dart';
import 'package:avalon_tool/miner_overview/avalon_hashboard_display.dart';
import 'package:avalon_tool/miner_overview/avalon_info.dart';
import 'package:avalon_tool/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinerOverviewScreen extends StatelessWidget {
  const MinerOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverviewController controller = Get.put(OverviewController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.device[0].ip),
        actions: controller.device[0].manufacture=='Antminer'?
         [
          OutlinedButton(onPressed: (){controller.showTempMap();}, child: const Text('boards Temp')),
          OutlinedButton(onPressed: (){controller.showLog();}, child: const Text('Log')),
          ]
            :
        [
          OutlinedButton(onPressed: (){controller.showTempMap();}, child: const Text('boards Temp')),
          OutlinedButton(onPressed: (){controller.showWorkMap();}, child: const Text('boards Work')),
          OutlinedButton(onPressed: (){controller.showLog();}, child: const Text('Log')),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: controller.device[0].manufacture=='Antminer'? const AntminerInfo():const AvalonInfo(),
          ),
          Expanded(
              flex: 7,
              child: Obx(()=>IndexedStack(
                  index: controller.stackIndex.value,
                  children: [
                    ///log screen index 0
                    Card(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            SelectableText('${controller.device[0].data.rawData}')
                          ],
                        ),
                      ),
                    ),
                    ///temp screen index 1
                    controller.device[0].manufacture=='Antminer'? const AntminerHashboards() : const AvalonHashboardDisplay(),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
