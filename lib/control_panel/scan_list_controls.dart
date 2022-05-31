import 'package:AllMinerMonitor/control_panel/control_panel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanListControls extends StatelessWidget {
  const ScanListControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControlPanelController controller = Get.put(ControlPanelController());
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       //   alignment: WrapAlignment.spaceEvenly,
         // crossAxisAlignment: WrapCrossAlignment.center,
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
            /*
            OutlinedButton(
              onPressed: (){controller.onClick(3);},
              child: Text('commands'.tr, overflow: TextOverflow.ellipsis,),
            ),
            */
            OutlinedButton(
              onPressed: (){controller.onClick(4, context);},
              child: Text('settings'.tr, overflow: TextOverflow.ellipsis,),
            ),
            OutlinedButton(
              onPressed: (){controller.goToLayout();},
              child: Text('layout'.tr, overflow: TextOverflow.ellipsis,),
            ),
            PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              iconSize: 20.0,
              onSelected: (String value){controller.addActions(value);},
                itemBuilder: (BuildContext context){
                return {{'1':'command_test'.tr},{'2':'show_scan_log'.tr}}.map((Map<String,String> choice) {
                  return PopupMenuItem<String>(
                  value: choice.keys.first,
                  child: Text(choice.values.first, style: Get.textTheme.bodyText1,),
                  );
                  }).toList();
                }
            )
          ],
        ),
      ),
    );
  }
}
