import 'package:AllMinerMonitor/auto_layout/wizard_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WizardItem extends StatelessWidget {
  final int id;
  const WizardItem(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WizardItemController controller = Get.put(WizardItemController(), tag: '$id');
    final TextEditingController ipController = TextEditingController(text: controller.ipRange.value);
    final TextEditingController shelfController = TextEditingController();
    final TextEditingController placeController = TextEditingController();
    final TextEditingController gapController = TextEditingController();
    return  Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            height: 60,
            child: Obx(()=>TextField(
              controller: ipController,
                onChanged: (value){
                  controller.editIp(value, id);
                },
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                    hintText: 'ip_range'.tr,
                    labelText: 'ip_range'.tr,
                    errorText: controller.ipError.value? 'invalid_ip_range'.tr :null,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 100,
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 7,
                  child: Obx(()=>TextField(
                     controller: shelfController..text='${controller.shelfCount.value}'
                       ..selection=TextSelection.fromPosition
                         (TextPosition(offset: controller.shelfCount.value.toString().length,
                           affinity: TextAffinity.upstream)
                       ),
                      onChanged: (value){controller.editShelfCount(value, id);},
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                          hintText: 'shelf_count'.tr,
                          labelText: 'shelf_count'.tr
                      ),
                    ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){controller.shelfPlus(id);}, child: const Text('+')),
                    OutlinedButton(onPressed: (){controller.shelfMinus(id);}, child: const Text('-'))
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 100,
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 7,
                  child: Obx(()=>TextField(
                      controller: placeController..text='${controller.placeCount.value}'
                        ..selection=TextSelection.fromPosition(
                            TextPosition(offset: controller.placeCount.value.toString().length,
                                affinity: TextAffinity.upstream)
                        ),
                      onChanged: (value){controller.editPlaceCount(value, id);},
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                          hintText: 'place_count'.tr,
                          labelText: 'place_count'.tr
                      ),
                    ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){controller.placePlus(id);}, child: const Text('+')),
                    OutlinedButton(onPressed: (){controller.placeMinus(id);}, child: const Text('-'))
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 100,
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 7,
                  child: Obx(()=>TextField(
                    controller: gapController..text='${controller.gap.value}'
                      ..selection=TextSelection.fromPosition(
                          TextPosition(offset: controller.gap.value.toString().length,
                              affinity: TextAffinity.upstream)
                      ),
                    onChanged: (value){controller.editGapCount(value, id);},
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        hintText: 'gap'.tr,
                        labelText: 'gap'.tr
                    ),
                  ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){controller.gapPlus(id);}, child: const Text('+')),
                    OutlinedButton(onPressed: (){controller.gapMinus(id);}, child: const Text('-'))
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 50,
          height: 60,
          child: IconButton(onPressed: (){controller.deleteRig(id);}, icon: const Icon(Icons.delete)),
        ),
      ],
    );
  }
}
