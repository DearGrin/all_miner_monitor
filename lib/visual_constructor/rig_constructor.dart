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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ListView.builder(
                  shrinkWrap: true,
                    controller: ScrollController(),
                    itemCount: _.layout.value.rigs?.firstWhere((element) => element.id==rig.id).shelves?.length??0,
                    itemBuilder: (BuildContext context, int index){
                      return ShelfConstructor(rig.id, _.layout.value.rigs?.firstWhere((element) => element.id==rig.id).shelves?[index].id??0);
                    }
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(onPressed: (){controller.addShelf(rig.id);}, icon: const Icon(Icons.add)))
            ],
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
  List<Widget> shelves(ConstructorController controller){
    List<Widget> _tmp = [];
    for(int i = 0; i <rig.shelves!.length; i++)
      {
        _tmp.add(ShelfConstructor(rig.id, rig.shelves![i].id));
      }
    return _tmp;
  }
}
