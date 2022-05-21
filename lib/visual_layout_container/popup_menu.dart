import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    return SizedBox(
      width: 250,
      child: Card(
        color: Get.theme.cardTheme.color,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('actions'.tr),
                  IconButton(
                    splashRadius: 5.0,
                      padding: const EdgeInsets.all(0),
                      onPressed: (){controller.closePopup();},
                      icon: const Icon(Icons.close)
                  )
                ],
              ),
             // TextButton(onPressed: (){controller.addSelectedDevice();}, child: Text('select'.tr)),
              //const SizedBox(height: 5.0,),
              TextButton(onPressed: (){controller.openInBrowser();}, child: Text('open_browser'.tr)),
            ],
          ),
        ),
      ),
    );
  }
}
