import 'package:avalon_tool/visual_constructor/layout_list_controller.dart';
import 'package:avalon_tool/visual_constructor/wizard_controller.dart';
import 'package:avalon_tool/visual_constructor/wizard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutoWizard extends StatelessWidget {
  const AutoWizard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WizardController controller = Get.put(WizardController());
    final LayoutListController layoutListController = Get.put(LayoutListController());
    final TextEditingController tagController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){Get.back();layoutListController.updateList();},
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vertical direction: '),
              Obx(()=> ToggleButtons(
                    children: <Widget>[
                      Icon(Icons.arrow_downward_outlined),
                      Icon(Icons.arrow_upward_outlined)
                    ],
                    isSelected: controller.hor,
                  onPressed: (int index){controller.onDirectionHorChange(index);},
                ),
              ),
              Text('Vertical direction: '),
              Obx(()=> ToggleButtons(
                children: <Widget>[
                  Icon(Icons.arrow_right_outlined),
                  Icon(Icons.arrow_left_outlined)
                ],
                isSelected: controller.vert,
                onPressed: (int index){controller.onDirectionVertChange(index);},
              ),
              ),
            ],
          ),
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
                  hintText: 'tag',
                  labelText: 'tag',
                  errorText: controller.tagError.value? 'invalid tag' : null,
              ),
            ),
          ),
        ),
        actions: [
          OutlinedButton(onPressed: (){controller.onSaveClick();}, child: Text('Save'))
        ],
      ),
      body: Card(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            GetBuilder<WizardController>(
              id: 'rig_wizard',
                builder: (_){
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.model.rigs!.length,
                    itemBuilder: (BuildContext context, int index){
                      return WizardItem(_.model.rigs![index].id!);
                    }
                );
                }
            ),
            IconButton(onPressed: (){controller.addItem();}, icon: Icon(Icons.add))
          ],
        ),
      ),
    );
  }
  Widget item(BuildContext context, int index){
    return Row(
      children: [
        SizedBox(
          width: 300,
          height: 60,
          child: TextField(
            controller: TextEditingController(),
            onChanged: (value){
            },
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                hintText: 'ip range',
                labelText: 'ip range'
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
            children: [
              Expanded(
                  flex: 7,
                  child: TextField(
                    controller: TextEditingController(),
                    onChanged: (value){},
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        hintText: 'rig count',
                        labelText: 'rig count'
                    ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){}, child: const Text('+')),
                    OutlinedButton(onPressed: (){}, child: const Text('-'))
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
            children: [
              Expanded(
                  flex: 7,
                  child: TextField(
                    controller: TextEditingController(),
                    onChanged: (value){},
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        hintText: 'shelf count',
                        labelText: 'shelf count'
                    ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){}, child: const Text('+')),
                    OutlinedButton(onPressed: (){}, child: const Text('-'))
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
            children: [
              Expanded(
                  flex: 7,
                  child: TextField(
                    controller: TextEditingController(),
                    onChanged: (value){},
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        hintText: 'place count',
                        labelText: 'place count'
                    ),
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OutlinedButton(onPressed: (){}, child: const Text('+')),
                    OutlinedButton(onPressed: (){}, child: const Text('-'))
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
          child: IconButton(onPressed: (){print('del');}, icon: const Icon(Icons.delete)),
        ),
      ],
    );
  }
}
