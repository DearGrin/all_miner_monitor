import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_constructor/shelf_constructor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RigConstructor extends StatelessWidget {
  final Rig rig;
  const RigConstructor(this.rig, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  shelves(controller),
    );
  }
  List<Widget> shelves(ConstructorController controller){
    List<Widget> _tmp = [];
    for(int i = 0; i <rig.shelves!.length; i++)
      {
        _tmp.add(ShelfConstructor(rig.id, rig.shelves![i].id));
      }
    return _tmp;
  }
}
