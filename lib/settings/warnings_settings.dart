import 'package:AllMinerMonitor/settings/settings_controller.dart';
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
                const SizedBox(height: 10.0,),
                InkWell(
                  onTap: (){controller.showAntSettings();},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('speed_check_ant'.tr, style: Theme.of(context).textTheme.bodyText2,),
                      Obx(()=>Icon(controller.isAntVisible.value?
                        Icons.arrow_drop_up_outlined :
                        Icons.arrow_drop_down_outlined)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0,),
                Obx(()=> Visibility(
                    visible: controller.isAntVisible.value,
                    replacement: Container(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'L3 (Mh/s)'.tr,
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
                              'T19'.tr,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Obx(()=> SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                controller: TextEditingController(text: controller.minHashT19.value.toString()),
                                onChanged: (value){controller.setMinHash(value, 'T19');},
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
                              'S11'.tr,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Obx(()=> SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                controller: TextEditingController(text: controller.minHashS11.value.toString()),
                                onChanged: (value){controller.setMinHash(value, 'S11');},
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
                const SizedBox(height: 10.0,),
                InkWell(
                  onTap: (){controller.showAvalonSettings();},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('speed_check_avalon'.tr, style: Theme.of(context).textTheme.bodyText2,),
                      Obx(()=>Icon(controller.isAvalonVisible.value?
                      Icons.arrow_drop_up_outlined :
                      Icons.arrow_drop_down_outlined)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0,),
                Obx(()=> Visibility(
                      visible: controller.isAvalonVisible.value,
                      replacement: Container(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1047',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash1047.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '1047');},
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
                                '1066',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash1066.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '1066');},
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
                                '11xx',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash11xx.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '11xx');},
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
                                '12xx',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash12xx.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '12xx');},
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
                                '9xx',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash9xx.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '9xx');},
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
                                '8xx',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Obx(()=> SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  controller: TextEditingController(text: controller.minHash8xx.value.toString()),
                                  onChanged: (value){controller.setMinHash(value, '8xx');},
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
                const SizedBox(height: 10.0,),
                InkWell(
                  onTap: (){controller.showWhatsminerSettings();},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('speed_check_whatsminer'.tr, style: Get.textTheme.bodyText2,),
                      Obx(()=>Icon(controller.isWhatsminerVisible.value?
                      Icons.arrow_drop_up_outlined :
                      Icons.arrow_drop_down_outlined)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0,),
                Obx(()=> Visibility(
                    visible: controller.isWhatsminerVisible.value,
                    replacement: Container(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'M20',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Obx(()=> SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                controller: TextEditingController(text: controller.minHashM20.value.toString()),
                                onChanged: (value){controller.setMinHash(value, 'M20');},
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
                              'M31',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Obx(()=> SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                controller: TextEditingController(text: controller.minHashM31.value.toString()),
                                onChanged: (value){controller.setMinHash(value, 'M31');},
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
                              'M32',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Obx(()=> SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                controller: TextEditingController(text: controller.minHashM32.value.toString()),
                                onChanged: (value){controller.setMinHash(value, 'M32');},
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
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
