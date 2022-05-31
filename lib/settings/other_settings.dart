import 'package:AllMinerMonitor/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherSettings extends StatelessWidget {
  const OtherSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'dark_mode'.tr,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Obx(()=> Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (value){controller.setDarkMode(value);},
              trackColor: controller.isDarkMode.value? MaterialStateProperty.all<Color>(Colors.blue):MaterialStateProperty.all<Color>(Colors.grey),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'language'.tr,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Obx(()=> DropdownButton<String>(
                  value: controller.language.value,
                  items: <String>['english', 'русский']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );
                  }).toList(),
                onChanged: (String? value){controller.changeLanguage(value);},
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'rasp_count'.tr,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Obx(()=> SizedBox(
              width: 60,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                controller: TextEditingController(text: controller.raspCount.value.toString())..selection=TextSelection.fromPosition
    (TextPosition(offset:controller.raspCount.value.toString().length,
    affinity: TextAffinity.upstream)),
                onChanged: (value){controller.setRaspCount(value);},
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            ),
          ],
        ),
      ],
    );
  }
}
