import 'package:AllMinerMonitor/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RebootUI extends StatelessWidget {
  const RebootUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('reboot_descr'.tr),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: (){controller.rebootAll();},
                  child: Text('reboot_all'.tr)
              ),
              const SizedBox(width: 20,),
              OutlinedButton(
                  onPressed: (){controller.rebootSelected();},
                  child: Text('reboot_selected'.tr)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
