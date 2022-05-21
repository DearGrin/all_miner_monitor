import 'package:AllMinerMonitor/command_panel/command_list.dart';
import 'package:AllMinerMonitor/command_panel/command_panel_controller.dart';
import 'package:AllMinerMonitor/command_panel/set_freq_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class CommandPanelUi extends StatelessWidget {
  CommandPanelUi({Key? key}) : super(key: key);
  final CommandPanelController controller = Get.put(CommandPanelController());

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              children: [
                Text('pro_warning'.tr),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30),
              child: TextField(
                  controller: textEditingController,
                  onChanged: (value){controller.onInputChange(value);},
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'raw_command'.tr
                  ),
                ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('select_command'.tr),
                  Obx(()=> DropdownButton<String>(
                        value: controller.command.value,
                        items: getCommands(context),
                        onChanged: (value){
                          controller.onCommandSelect(value);
                          handleCommandChange(textEditingController);
                        }
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 30),
                child: options(context, textEditingController)),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: (){},
                      child: Text('submit_all'.tr)
                  ),
                  OutlinedButton(
                      onPressed: (){},
                      child: Text('submit_selected'.tr)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget options(BuildContext context, TextEditingController _textEditingController){
    return Obx(() {
      switch (controller.command.value) {
        case 'set_freq':
          return SetFreqDialog();
        case 'set_volt':
          return TextField(
            onChanged: (value){
              controller.onVoltChange(value);
              handleCommandChange(_textEditingController);
              },
            decoration: InputDecoration(
                labelText: 'volt_to_set'.tr
            ),
            style: Theme.of(context).textTheme.bodyText1,
          );
        case 'set_temp':
          return TextField(
            onChanged: (value){
              controller.onTempChange(value);
              handleCommandChange(_textEditingController);
              },
            decoration: InputDecoration(
              labelText: 'temp_to_set'.tr
            ),
            style: Theme.of(context).textTheme.bodyText1,
          );
        case 'set_chip_temp':
          return TextField(
            onChanged: (value){
              controller.onChipTempChange(value);
              handleCommandChange(_textEditingController);
            },
            decoration: InputDecoration(
                labelText: 'temp_chip_to_set'.tr
            ),
            style: Theme.of(context).textTheme.bodyText1,
          );
        default:
          return Container();
      }
    }
      );
  }
  handleCommandChange(TextEditingController _textEditingController){
    _textEditingController.text = controller.rawCommand.value;
  }
  List<DropdownMenuItem<String>>getCommands(BuildContext context){
    List<DropdownMenuItem<String>> _tmp = [];
    for(int i = 0; i < commands.length; i ++)
      {
        _tmp.add(DropdownMenuItem(
          value: commands[i].keys.first,
            child: Text(
              commands[i].keys.first.tr,
              style: Theme.of(context).textTheme.bodyText1,
            ),
        )
        );
      }
    return _tmp;
  }
}
