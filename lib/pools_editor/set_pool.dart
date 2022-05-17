import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/pools_editor/pools_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetPool extends StatelessWidget{
  SetPool({Key? key}) : super(key: key);
  final PoolsEditorController controller = Get.put(PoolsEditorController());
  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(flex: 1, child: poolField(0, context)),
            const SizedBox(height: 5,),
            Expanded(flex: 1, child: poolField(1, context),),
            const SizedBox(height: 5,),
            Expanded(flex: 1, child: poolField(2, context)),
            const SizedBox(height: 5,),
            Expanded(flex: 1, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: submitAll,
                  child: Text('submit_all'.tr),
                ),
                OutlinedButton(
                  onPressed: submitSelected,
                  child: Text('submit_selected'.tr),
                ),
              ],)),
            /*

            const SizedBox(height: 10,),
            poolField(0, context),
            const SizedBox(height: 10,),
            poolField(1, context),
            const SizedBox(height: 10,),
            poolField(2, context),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: submitAll,
                    child: const Text('submit ALL'),
                ),
                OutlinedButton(
                  onPressed: submitSelected,
                  child: const Text('submit SELECTED'),
                ),
              ],
            ),


             */
          ],
        ),
      ),
    );
  }
  Widget poolField(int index, BuildContext context){
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            flex: 5,
              child: TextField(
                controller: TextEditingController(text: controller.pools[index].addr??''),
                onChanged: (value){changePoolAddr(value, index);},
                decoration: const InputDecoration(
                  hintText: 'pool',
                  labelText: 'pool',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
          ),
          const SizedBox(width: 5,),
          Expanded(
              flex: 1,
              child: TextField(
                controller: TextEditingController(text: controller.pools[index].port??''),
                onChanged: (value){changePoolPort(value, index);},
                decoration: const InputDecoration(
                  hintText: 'port',
                  labelText: 'port',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
          ),
          const SizedBox(width: 5,),
          Expanded(
            flex: 3,
            child: TextField(
              controller: TextEditingController(text: controller.pools[index].worker??''),
              onChanged: (value){changeWorker(value, index);},
              decoration: const InputDecoration(
                hintText: 'worker',
                labelText: 'worker',
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          const SizedBox(width: 5,),
          Expanded(
            flex: 1,
              child: TextField(
                controller: TextEditingController(text: controller.pools[index].passwd??''),
                onChanged: (value){changePoolPasswd(value, index);},
                decoration: const InputDecoration(
                  hintText: 'password',
                  labelText: 'password',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
          ),
          Expanded(
            flex: 3,
            child: Obx(() => Row(
                children: [
                  const SizedBox(width: 5,),
                  Flexible(child: Text('empty'.tr)),
                  Radio<int>(value: 0, groupValue: controller.suffixMode[index],
                 onChanged: (int? value){controller.suffixSelect(index, value);}),
                  Flexible(child: Text('add_ip'.tr, overflow: TextOverflow.clip,)),
                  Radio<int>(value: 1, groupValue: controller.suffixMode[index],
                      onChanged: (int? value){controller.suffixSelect(index, value);}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  changePoolAddr(String addr, int index){
    controller.onAddrChange(index, addr);
  }
  changePoolPort(String port, int index){
    controller.onPortChange(index, port);
  }
  changePoolPasswd(String passwd, int index){
    controller.onPasswdChange(index, passwd);
  }
  changeWorker(String worker, int index){
    controller.onWorkerChange(index, worker);
  }
  submitAll(){
    controller.submitAll();
  }
  submitSelected(){
    controller.submitSelected();
  }
}
