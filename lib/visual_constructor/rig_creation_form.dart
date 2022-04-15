import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RigCreationForm extends StatelessWidget {
  const RigCreationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Set layout max values. You can edit it anytime on the next steps',
            style: Theme.of(context).textTheme.bodyText2,
          ),
         const SizedBox(height: 20,),
         SizedBox(
           height: 40,
           width: 200,
           child: TextField(
                controller: TextEditingController(text: '${controller.settings[0]}'),
                onChanged: (value){controller.onRigCountChange(value);},
                decoration: const InputDecoration(
                  hintText: 'rig count',
                  labelText: 'rig count',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
           ),
          const SizedBox(height: 20,),
          SizedBox(
            height: 40,
            width: 200,
            child: TextField(
                controller: TextEditingController(text: '${controller.settings[1]}'),
                onChanged: (value){controller.onRowCountChange(value);},
                decoration: const InputDecoration(
                  hintText: 'row count',
                  labelText: 'row count',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          const SizedBox(height: 20,),
          SizedBox(
            height: 40,
            width: 200,
            child: TextField(
                controller: TextEditingController(text: '${controller.settings[2]}'),
                onChanged: (value){controller.onMinerPerAucChange(value);},
                decoration: const InputDecoration(
                  hintText: 'miner per auc',
                  labelText: 'miner per auc',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          const SizedBox(height: 20,),
          OutlinedButton(
              onPressed: (){controller.onNextClick();},
              child: const Text('next',)
          ),
        ],
      ),
    );
  }
}
