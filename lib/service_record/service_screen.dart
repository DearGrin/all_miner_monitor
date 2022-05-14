import 'package:avalon_tool/service_record/record_card.dart';
import 'package:avalon_tool/service_record/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceScreen extends GetView<ServiceController> {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.ip, style: Get.textTheme.bodyText1,),
        actions: [
          IconButton(
            onPressed: (){controller.openNewRecordDialog();},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Scrollbar(
            controller: scrollController,
            isAlwaysShown: true,
            child: Obx(()=>ListView.separated(
              reverse: true,
              shrinkWrap: true,
              controller: scrollController,
              padding: const EdgeInsets.only(right: 10.0),
                  itemBuilder: (BuildContext context, int index){
                    return RecordCard(controller.records[index]);
                  },
                  separatorBuilder: (BuildContext context, int index){
                    return const Divider();
                  },
                  itemCount: controller.records.length
              ),
            ),
          )
        ],
      ),
    );
  }
}
