import 'dart:math';

import 'package:avalon_tool/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchSettings extends GetView<SettingsController> {
  const BatchSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final SettingsController controller = Get.put(SettingsController());
    return Column(
      children: [
        Obx(()=> Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('octet_descr'.tr, style: Theme.of(context).textTheme.bodyText1,),
              Text('1', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 1,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
               Text('2', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 2,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
              Text('3', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 3,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
              Text('4', style: Theme.of(context).textTheme.bodyText1,),
              Radio<int>(
                  value: 4,
                  groupValue: controller.octetCount.value,
                  onChanged: (value){controller.setOctetCount(value!);}
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('threads_descr'.tr, style: Theme.of(context).textTheme.bodyText1,),
            Obx(()=> SizedBox(
              width: 50,
              child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  controller: TextEditingController(text: controller.threadsCount.value.toString()),
                  onChanged: (value){controller.setThreadsCount(value);},
                style: Theme.of(context).textTheme.bodyText1,
                ),
            ),
            ),
          ],
        ),
        const SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('passwords'.tr, style: Get.textTheme.bodyText2, textAlign: TextAlign.center,),
            const SizedBox(width: 10.0,),
            Obx(()=>
                IconButton(
                  splashRadius: 1.0,
                  onPressed: (){controller.showPasswords();},
                  icon: Icon(controller.isObscured.value? Icons.visibility_outlined : Icons.visibility_off_outlined)
              ),
            ),
            const SizedBox(width: 10.0,),
            IconButton(
                splashRadius: 1.0,
                onPressed: (){controller.addField('antminer');},
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(height: 10.0,),
        Expanded(
          child: Obx(()=>ListView.separated(
           shrinkWrap: true,
            padding: const EdgeInsets.only(right: 10.0),
            itemBuilder: (BuildContext context, int index){
              final TextEditingController login = TextEditingController();
              final TextEditingController password = TextEditingController();
              return SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: Obx(()=>TextField(
                            //controller: TextEditingController(text: controller.antPasswords[index].keys.first),
                            controller: login..text = controller.antPasswords[index].keys.first..selection=TextSelection.fromPosition
                              (TextPosition(offset: controller.antPasswords[index].keys.first.length,
                                affinity: TextAffinity.upstream)
                            ),
                            onChanged: (value){controller.editLogin(value, index, 'antminer');},
                            //obscureText: controller.isObscured.value,
                            style: Get.textTheme.bodyText1,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'login',
                              hintText: 'login'
                            ),
                          ),
                        )
                    ),
                    const SizedBox(width: 5.0,),
                    Expanded(
                        child: Obx(()=>TextField(
                            controller: password..text = controller.antPasswords[index].values.first..selection=TextSelection.fromPosition
              (TextPosition(offset: controller.antPasswords[index].values.first.length,
              affinity: TextAffinity.upstream)
              ),
                            onChanged: (value){controller.editPassword(value, index, 'antminer');},
                            style: Get.textTheme.bodyText1,
                            obscureText: controller.isObscured.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'password',
                              hintText: 'password'
                            ),
                          ),
                        )
                    ),
                    const SizedBox(width: 5.0,),
                    IconButton(
                        splashRadius: 1.0,
                        onPressed: (){controller.deleteField(index, 'antminer');},
                       icon: const Icon(Icons.delete)
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index){
              return const Divider();
            },
            itemCount: controller.antPasswords.length,
          )
          ),
        ),
      ],
    );
  }
}
