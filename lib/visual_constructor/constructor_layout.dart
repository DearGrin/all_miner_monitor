import 'package:AllMinerMonitor/visual_constructor/constructor_controller.dart';
import 'package:AllMinerMonitor/visual_constructor/cont_rig_row_controls.dart';
import 'package:AllMinerMonitor/visual_constructor/rig_constructor.dart';
import 'package:AllMinerMonitor/visual_layout/layout_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConstructorLayout extends StatelessWidget {
  final String? tag;
  const ConstructorLayout({this.tag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    final LayoutListController layoutListController = Get.put(LayoutListController());
    controller.setData(tag);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){layoutListController.onBack();},
          icon: const Icon(Icons.arrow_back_ios_outlined),),
        centerTitle: true,
        title: SizedBox(
          width: 300,
          child: TextField(
            controller: TextEditingController(text: tag),
            onChanged: (value){controller.editTag(value);},
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                hintText: 'tag'.tr,
              labelText: 'tag'.tr,
            ),
          ),
        ),
        actions: [
          OutlinedButton(
              onPressed: (){controller.onSaveClick();},
              child: Text('save'.tr),
          ).marginAll(10.0),
        ],
      ),
      body: Column(
        children: [
          const ContRigRowControls(),
          Flexible(
            fit: FlexFit.loose,
            child: GetBuilder<ConstructorController>(
             id: 'stack',
              builder: (_){
                return IndexedStack(
                       index: controller.selectedItem.value,
                       children: controller. layout.value.rigs!.map((element) => RigConstructor(element)).toList(),
                     );


              },
            )
            ),
        ],
      ),
    );
  }
}
