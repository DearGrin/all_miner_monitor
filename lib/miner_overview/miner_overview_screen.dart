import 'package:AllMinerMonitor/miner_overview/antminer_hashboards.dart';
import 'package:AllMinerMonitor/miner_overview/antminer_info.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_hashboard_display.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_info.dart';
import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:AllMinerMonitor/miner_overview/whatsminer_hashboards.dart';
import 'package:AllMinerMonitor/miner_overview/whatsminer_info.dart';
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
          OutlinedButton(onPressed: (){controller.showTempMap();}, child: const Text('errors by boards')).marginAll(10.0),
          OutlinedButton(onPressed: (){controller.showLog();}, child: const Text('Log')).marginAll(10.0),
          ]
            : controller.device[0].manufacture=='Avalon'?
        [
          OutlinedButton(onPressed: (){controller.showTempMap();}, child: const Text('boards Temp')).marginAll(10.0),
       //   OutlinedButton(onPressed: (){controller.showWorkMap();}, child: const Text('boards Work')).marginAll(10.0),
          OutlinedButton(onPressed: (){controller.showLog();}, child: const Text('Log')).marginAll(10.0),
        ]
            :
            [
              OutlinedButton(onPressed: (){controller.showTempMap();}, child: const Text('boards Temp')).marginAll(10.0),
              OutlinedButton(onPressed: (){controller.showLog();}, child: const Text('Log')).marginAll(10.0),
            ]
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: controller.device[0].manufacture=='Antminer'? const AntminerInfo(): controller.device[0].manufacture=='Avalon'? const AvalonInfo() : const WhatsMinerInfo(),
          ),
          Expanded(
              flex: 7,
              child: Obx(()=>IndexedStack(
                  index: controller.stackIndex.value,
                  children: [
                    ///log screen index 0
                    SizedBox(
                      height: Get.height,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          color: Get.theme.cardTheme.color,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(onPressed: (){controller.saveLog();}, child: Text('save'.tr, style: Get.textTheme.bodyText1,)).marginAll(10)
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      SelectableText('${controller.device[0].data.rawData}')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ///temp screen index 1
                    controller.device[0].manufacture=='Antminer'? const AntminerHashboards() : controller.device[0].manufacture=='Avalon'? const AvalonHashboardDisplay() : const WhatsminerHashboards(),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
