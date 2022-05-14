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
    return GetBuilder<ConstructorController>(
      id: 'rig_${rig.id}',
        builder: (_){
          return ListView.builder(
            padding: const EdgeInsets.only(right: 10.0),
            shrinkWrap: true,
              controller: ScrollController(),
              itemCount: _.layout.value.rigs?.firstWhere((element) => element.id==rig.id).shelves?.length??0,
              itemBuilder: (BuildContext context, int index){
                return ShelfConstructor(rig.id, _.layout.value.rigs?.firstWhere((element) => element.id==rig.id).shelves?[index].id??0, (index+1));
              }
          );
       /*
        return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  shelves(controller),
          );


        */
        }
    );
  }
}
