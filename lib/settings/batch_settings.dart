import 'package:avalon_tool/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchSettings extends StatelessWidget {
  const BatchSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return Column(
      children: [
        Obx(()=> Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('octet_descr'.tr, style: Theme.of(context).textTheme.bodyText1,),
              Text('1', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 1,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
               Text('2', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 2,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
              Text('3', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 3,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
              Text('4', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 4,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('threads_descr'.tr, style: Theme.of(context).textTheme.bodyText1,),
            Obx(()=> SizedBox(
              width: 50,
              child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.threadsCount.value.toString()),
                  onChanged: (value){controller.setThreadsCount(value);},
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
