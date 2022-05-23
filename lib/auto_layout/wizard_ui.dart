import 'package:AllMinerMonitor/auto_layout/wizard_controller.dart';
import 'package:AllMinerMonitor/auto_layout/wizard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutoWizard extends StatelessWidget {
  const AutoWizard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WizardController controller = Get.put(WizardController());
    final TextEditingController tagController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){Get.back();},
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),

        centerTitle: true,
        title: SizedBox(
          width: 400,
          height: 50,
          child: Obx(()=>TextField(
              controller: tagController,
              onChanged: (value){controller.onEditTag(value);},
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                  hintText: 'tag'.tr,
                  labelText: 'tag'.tr,
                  errorText: controller.tagError.value? 'invalid_tag'.tr : null,
              ),
            ),
          ),
        ),
        actions: [
          OutlinedButton(onPressed: (){controller.onSaveClick();}, child: Text('save'.tr)).marginAll(10.0)
        ],
      ),
      body: Card(
        color: Theme.of(context).cardColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('vertical_direction'.tr),
                    const SizedBox(width: 5),
                    Obx(()=> OutlinedButton(onPressed: (){controller.onDirectionVertChange(0);}, child: Text('from_top'.tr),
                        style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                controller.vert[0]? Colors.blueGrey: Colors.transparent)),
                    ),
                    ),
                    const SizedBox(width: 5),
                    Obx(()=> OutlinedButton(onPressed: (){controller.onDirectionVertChange(1);}, child: Text('from_bottom'.tr),
                      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.vert[1]? Colors.blueGrey: Colors.transparent)),
                    ),
                    ),
                    const SizedBox(width: 20),
                    Text('horizontal_direction'.tr),
                    const SizedBox(width: 5),
                    Obx(()=> OutlinedButton(onPressed: (){controller.onDirectionHorChange(0);}, child: Text('from_left'.tr),
                      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.hor[0]? Colors.blueGrey: Colors.transparent)),
                    ),
                    ),
                    const SizedBox(width: 5),
                    Obx(()=> OutlinedButton(onPressed: (){controller.onDirectionHorChange(1);}, child: Text('from_right'.tr),
                      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.hor[1]? Colors.blueGrey: Colors.transparent)),
                    ),
                    ),
                  const SizedBox(width: 5),
                  IconButton(onPressed: (){controller.addItem();}, icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: GetBuilder<WizardController>(
                id: 'rig_wizard',
                  builder: (_){
                  return Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: _.model.rigs!.length,
                        itemBuilder: (BuildContext context, int index){
                          return WizardItem(_.model.rigs![index].id!);
                        }
                    ),
                  );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
