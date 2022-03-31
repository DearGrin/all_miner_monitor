import 'package:avalon_tool/control_panel/control_panel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanListControls extends StatelessWidget {
  const ScanListControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControlPanelController controller = Get.put(ControlPanelController());
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Wrap(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton(
                onPressed: (){controller.onClick(0);},
                child: Text('scan'.tr, overflow: TextOverflow.ellipsis,),
            ),
            OutlinedButton(
              onPressed: (){controller.onClick(1);},
              child: Text('set_pool'.tr, overflow: TextOverflow.ellipsis,),
            ),
            OutlinedButton(
              onPressed: (){controller.onClick(2);},
              child: Text('reboot'.tr, overflow: TextOverflow.ellipsis,),
            ),
            OutlinedButton(
              onPressed: (){controller.onClick(3);},
              child: Text('commands'.tr, overflow: TextOverflow.ellipsis,),
            ),
            OutlinedButton(
              onPressed: (){controller.onClick(4, context);},
              child: Text('settings'.tr, overflow: TextOverflow.ellipsis,),
            ),
          ],
        ),
      ),
    );
  }
}
