import 'package:AllMinerMonitor/debugger/debugger_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebuggerScreen extends StatelessWidget {
  const DebuggerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DebuggerController controller = Get.put(DebuggerController());
    return Scaffold(
      appBar: AppBar(
      ),
      body: SizedBox(
        height: Get.height*0.8,
        child: SingleChildScrollView(
          child: Card(
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    onChanged: (value){controller.editIp(value);},
                    style: Get.textTheme.bodyText1,
                    decoration: const InputDecoration(
                      labelText: 'ip'
                    ),
                    controller: TextEditingController(),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: 400,
                  child: TextField(
                    onChanged: (value){controller.editCommand(value);},
                    style: Get.textTheme.bodyText1,
                    decoration: InputDecoration(
                        labelText: 'command'.tr
                    ),
                    controller: TextEditingController(),
                  ),
                ),
                const SizedBox(height: 10,),
                OutlinedButton(onPressed: (){controller.sendCommand();}, child: Text('send'.tr)),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: [
                      Obx(()=>SelectableText('${controller.data}')),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
