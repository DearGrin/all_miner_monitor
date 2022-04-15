import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:avalon_tool/visual_constructor/cont_rig_row_controls.dart';
import 'package:avalon_tool/visual_constructor/layout_list_controller.dart';
import 'package:avalon_tool/visual_constructor/rig_constructor.dart';
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
        leading: IconButton(onPressed: (){layoutListController.onBack();}, icon: Icon(Icons.arrow_back_ios_outlined),),
        centerTitle: true,
        title: SizedBox(
          width: 300,
          child: TextField(
            controller: TextEditingController(text: tag),
            onChanged: (value){controller.editTag(value);},
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                hintText: 'Tag',
              labelText: 'Tag',
            ),
          ),
        ),
        actions: [
          OutlinedButton(
              onPressed: (){controller.onSaveClick();},
              child: Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          ContRigRowControls(),
          Flexible(
            fit: FlexFit.loose,
            child: GetBuilder<ConstructorController>(
             id: 'stack',
              builder: (_){
                return CustomScrollView(
                 slivers: [
                   SliverFillRemaining(
                     hasScrollBody: false,
                     child: IndexedStack(
                       index: controller.selectedItem.value,
                       children: controller. layout.value.rigs!.map((element) => RigConstructor(element)).toList(),
                     ),
                   )
                 ],
                );
              },
            )
            ),
        ],
      ),
    );
  }
}
