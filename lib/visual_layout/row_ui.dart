import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/place_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RowUI extends StatelessWidget {
  final int rigIndex;
  final int rowIndex;
  const RowUI(this.rigIndex, this.rowIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: places(controller),
      ),
    );
  }
  List<Widget> places(LayoutController  controller){
    List<Widget> _tmp = [
      SizedBox(
          width: 10,
          child: Text('${rowIndex+1}',)),
    ];
    int _placeIndex = 0;
    if(controller.layout.value.rigs![rigIndex].shelves![rowIndex].places!=null) {
      for (int i = 0; i <
          controller.layout.value.rigs![rigIndex].shelves![rowIndex].places!
              .length; i++) {
        Place _place = controller.layout.value.rigs![rigIndex]
            .shelves![rowIndex].places![i];
        if (_place.type == 'miner') {
          _tmp.add(PlaceUI(_place, _placeIndex),);
          _placeIndex++;
        }
        else {
          for (int c = 0; c < 5; c++) {
            _tmp.add(PlaceUI(_place, _placeIndex + c));
          }
          _placeIndex += 5; //TODO get from setttings
        }
      }
    }
    return _tmp;
  }
}
