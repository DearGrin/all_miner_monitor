import 'package:avalon_tool/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningsSettings extends StatelessWidget {
  const WarningsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'max_temp_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.maxTemp.value.toString()),
                  onChanged: (value){controller.setMaxTemp(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'max_temp_input_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.maxTempInput.value.toString()),
                  onChanged: (value){controller.setMaxTempInput(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'min_hash_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.minHash.value.toString()),
                  onChanged: (value){controller.setMinHash(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'vol_req_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.volReq.value.toString()),
                  onChanged: (value){controller.setMinVol(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dh_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.maxDh.value.toString()),
                  onChanged: (value){controller.setMaxDh(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'k_work_full'.tr,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Obx(()=> SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.kWork.value.toString()),
                  onChanged: (value){controller.setKWork(value);},
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
