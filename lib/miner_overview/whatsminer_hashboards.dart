import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsminerHashboards extends StatelessWidget {
  const WhatsminerHashboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverviewController controller = Get.put(OverviewController());
    final ScrollController scrollController = ScrollController();
    List<Widget> boards = [];
    for(var b in controller.device[0].data.devs[0].devs){
      boards.add(
          Card(
            color: Get.theme.cardTheme.color,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    children: [
                      Text('ASC: ${b.aSC}'),
                      const SizedBox(width: 10.0,),
                      Text('Status: ${b.status}'),
                      const SizedBox(width: 10.0,),
                      Text('Enabled: ${b.enabled}'),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Wrap(
                    children: [
                      Text('Chips: ${b.effectiveChips}'),
                      const SizedBox(width: 10.0,),
                      Text('Chip freq: ${b.chipFrequency}'),
                      const SizedBox(width: 10.0,),
                      Text('Hardware Errors: ${b.hardwareErrors}'),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Wrap(
                    children: [
                      Text('Temp min: ${b.chipTempMin}'),
                      const SizedBox(width: 10.0,),
                      Text('Temp avg: ${b.chipTempAvg}'),
                      const SizedBox(width: 10.0,),
                      Text('Temp max: ${b.chipTempMax}'),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Wrap(
                    children: [
                      Text('Speed 5s: ${(b.mHS5s/1000000).toStringAsFixed(2)} TH/s'),
                      const SizedBox(width: 10.0,),
                      Text('Speed 15m: ${(b.mHS15m/1000000).toStringAsFixed(2)} TH/s'),
                      const SizedBox(width: 10.0,),
                      Text('Speed avg: ${(b.mHSAv/1000000).toStringAsFixed(2)} TH/s'),
                    ],
                  ),
                ],
              ),
            ),
          )
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: boards,
          ),
        ),
      ),
    );
  }
}
