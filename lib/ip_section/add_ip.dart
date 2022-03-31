import 'package:avalon_tool/ip_section/ip_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddIp extends StatelessWidget{
  const AddIp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final IpManagementController controller = Get.put(IpManagementController());
    return Container(
      width: 500,
      height: 200,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ip_range'.tr,
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: (ip){controller.onNewIpChange(ip);},
                  controller: TextEditingController(text: controller.newIp),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'comment'.tr
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: TextEditingController(text: controller.newComment),
                  onChanged: (comment){controller.onNewCommentChange(comment);},
                ),
              ),
            ],
          ),

          Text(
            'example'.tr,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(()=> OutlinedButton(
                    onPressed: controller.isNewIpValid.value ?
                        (){controller.onSaveNewIp();} : null,
                    child: Text('save'.tr)
                ),
              ),
              OutlinedButton(
                  onPressed: (){controller.onCancelNewIp();},
                  child: Text('cancel'.tr)
              ),
            ],
          )
        ],
      ),
    );
  }
}
