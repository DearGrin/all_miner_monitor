import 'package:avalon_tool/visual_constructor/layout_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTagDialog extends StatelessWidget {
  const EditTagDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutListController controller = Get.put(LayoutListController());
    return Column(
      children: [
        Text('Edit tag', style: Theme.of(context).textTheme.bodyText2,),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 350,
            height: 50,
            child: TextField(
              onChanged: (value){controller.onTagChange(value);},
              controller: TextEditingController(text: controller.oldTag??''),
              style: Theme.of(context).textTheme.bodyText1,
            )
        ),
        SizedBox(height: 30,
          child: Obx(()=>Text(controller.error.value, style: Theme.of(context).textTheme.bodyText1,)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(onPressed: (){Get.back();}, child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1,)),
            OutlinedButton(onPressed: (){controller.editTag();}, child: Text('Save', style: Theme.of(context).textTheme.bodyText1,)),
          ],
        )
      ],
    );
  }
}
