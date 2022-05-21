import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:AllMinerMonitor/visual_layout_container/row_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RigUI extends StatelessWidget {
  final int rigIndex;
  const RigUI(this.rigIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    return Container(
      decoration: BoxDecoration(
        border: Border.all()
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: rows(controller),
      ),
    );
  }
  List<Widget> rows(LayoutController  controller){
    List<Widget> _tmp = [
      Text('rig'.trParams({'value':'${rigIndex+1}'})),
    ];
    if(controller.layout.value.rigs![rigIndex].shelves!=null) {
      for (int i = 0; i <
          controller.layout.value.rigs![rigIndex].shelves!.length; i++) {
        _tmp.add(RowUI(rigIndex, i));
      }
    }
    return _tmp;
  }
}
