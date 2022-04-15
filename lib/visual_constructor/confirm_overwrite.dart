import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmOverwrite extends StatelessWidget {
  const ConfirmOverwrite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('This tag already exists. Are you sure want to overwrite layout data?',
        style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: (){Get.back();},
                child: Text('Cancel')
            ),
            OutlinedButton(
                onPressed: (){controller.save();
                  Get.back();
                  },
                child: Text('Overwrite')
            ),
          ],
        ),
      ],
    );
  }
}
