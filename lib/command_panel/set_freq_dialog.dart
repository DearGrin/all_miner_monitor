import 'package:avalon_tool/command_panel/freq_set_contoller.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../avalon_10xx/freq_list.dart';

class SetFreqDialog extends StatelessWidget {
  const SetFreqDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FreqSetController controller = Get.put(FreqSetController());
    controller.setInitFreq(1);
    return Row(
      children: [
        drop(0,0, controller),
        drop(1,1, controller),
        drop(2,2, controller),
      ],
    );
  }
  Widget drop(int index, int hashBoard, FreqSetController controller){
    return Obx(()=>DropdownButton<int>(
      value: controller.freqs[index], // TODO get from controller
      items: freq.map((e) => DropdownMenuItem<int>(
        value: e,
        child: Text(e.toString()), //TODO watch for style
      )).toList(),
      onChanged: (int? value){controller.setFreq(value!, index, hashBoard);},
    ));
  }

}
