import 'package:avalon_tool/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningsSettings extends StatelessWidget {
  const WarningsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      isAlwaysShown: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'max_temp_full'.tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Obx(()=> SizedBox(
                      width: 60,
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
                      width: 60,
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
                      width: 60,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        controller: TextEditingController(text: controller.minHashDefault.value.toString()),
                        onChanged: (value){controller.setMinHash(value, 'default');},
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    ),
                  ],
                ),
                Text('Speed check for Antminer', style: Theme.of(context).textTheme.bodyText2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'L3 (Gh/s)'.tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Obx(()=> SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        controller: TextEditingController(text: controller.minHashL3.value.toString()),
                        onChanged: (value){controller.setMinHash(value, 'L3');},
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
                      'S9'.tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Obx(()=> SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        controller: TextEditingController(text: controller.minHashS9.value.toString()),
                        onChanged: (value){controller.setMinHash(value, 'S9');},
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
                      'S19'.tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Obx(()=> SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        controller: TextEditingController(text: controller.minHashS19.value.toString()),
                        onChanged: (value){controller.setMinHash(value, 'S19');},
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
                      'T9'.tr,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Obx(()=> SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        controller: TextEditingController(text: controller.minHashT9.value.toString()),
                        onChanged: (value){controller.setMinHash(value, 'T9');},
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
                      width: 60,
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
                      width: 60,
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
                      width: 60,
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
          ),
        ),
      ),
    );
  }
}
