import 'package:avalon_tool/service_record/service_controller.dart';
import 'package:avalon_tool/service_record/tags_color_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordTag extends GetView<ServiceController> {
  final String tg;
  final bool isActive;
  const RecordTag(this.tg, this.isActive, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: (){isActive? controller.addTag(tg):null;},
        child: Text(tg.tr, style: Get.textTheme.bodyText1,),
        style: Get.theme.outlinedButtonTheme.style?.copyWith(backgroundColor:
          MaterialStateProperty.all<Color>(tagColors[tg]!)
        ),
    ).marginAll(10.0);
  }
}
