import 'package:avalon_tool/service_record/record_tag.dart';
import 'package:avalon_tool/service_record/service_controller.dart';
import 'package:avalon_tool/service_record/tags_color_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRecord extends GetView<ServiceController> {
  const AddRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){controller.cancelNewRecord();},
            icon: const Icon(Icons.arrow_back_ios)
        ),
        title: Text('new_record'.tr, style: Get.textTheme.bodyText1,),
        actions: [
          OutlinedButton(
              onPressed: (){controller.submitRecord();},
              child: Text('save'.tr, style: Get.textTheme.bodyText1,)
          ).marginAll(10.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GetBuilder<ServiceController>(
                builder: (_){
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: _.newRecord.value.tags!.map((e) => RecordTag(e, true)).toList(),
                  );
                }
            ),

            SizedBox(
              height: 150,
              child: TextField(
                onChanged: (value){controller.newRecord.value.comment=value;},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: 'comment'.tr,
                  labelText: 'comment'.tr,
                ),
                style: Get.textTheme.bodyText1,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 40.0,),
            Text('select_tags'.tr, style: Get.textTheme.bodyText2, textAlign: TextAlign.center,),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: tagColors.keys.map((e) => RecordTag(e, true)).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
