import 'package:avalon_tool/settings/batch_settings.dart';
import 'package:avalon_tool/settings/info_settings.dart';
import 'package:avalon_tool/settings/other_settings.dart';
import 'package:avalon_tool/settings/settings_controller.dart';
import 'package:avalon_tool/settings/view_settings.dart';
import 'package:avalon_tool/settings/warnings_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return SizedBox(
      width: 700,
      height: 500,
      child: Column(
        children: [
          SizedBox(
              height: 40,
              child: Obx(()=>Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: (){controller.onClick(0);},
                      child: Text('view'.tr),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            controller.currentIndex.value==0?
                            Colors.blue: Colors.white)
                      ),
                    ),
                    OutlinedButton(
                      onPressed: (){controller.onClick(1);},
                      child: Text('warnings'.tr),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              controller.currentIndex.value==1?
                              Colors.blue: Colors.white)
                      ),
                    ),
                    OutlinedButton(
                      onPressed: (){controller.onClick(2);},
                      child: Text('batch'.tr),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              controller.currentIndex.value==2?
                              Colors.blue: Colors.white)
                      ),
                    ),
                    OutlinedButton(
                      onPressed: (){controller.onClick(3);},
                      child: Text('other'.tr),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              controller.currentIndex.value==3?
                              Colors.blue: Colors.white)
                      ),
                    ),
                    OutlinedButton(
                      onPressed: (){controller.onClick(4);},
                      child: Text('info'.tr),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              controller.currentIndex.value==4?
                              Colors.blue: Colors.white)
                      ),
                    ),
                  ],
                ),
              ),
          ),
          Expanded(
            flex: 1,
            child: Obx(()=> IndexedStack(
                index: controller.currentIndex.value,
                children: const [
                  ViewSettings(),
                  WarningsSettings(),
                  BatchSettings(),
                  OtherSettings(),
                  InfoSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
