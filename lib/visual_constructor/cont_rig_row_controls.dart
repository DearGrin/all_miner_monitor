import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContRigRowControls extends StatelessWidget {
  const ContRigRowControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    final ScrollController scrollController = ScrollController();
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text('Rigs:', style: Theme.of(context).textTheme.bodyText2,)),
          Expanded(
            flex: 8,
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: GetBuilder<ConstructorController>(
                id: 'rigs',
                builder: (_){
                 return ReorderableListView.builder(
                      scrollController: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 50, maxHeight: 60,),
                            //width: 110,
                            //height: 50,
                            key: Key('$index'),
                            child: GetBuilder<ConstructorController>(
                              builder: (_){
                                return  OutlinedButton(
                                    style: Theme.of(context).outlinedButtonTheme.style?.
                                    copyWith(backgroundColor: MaterialStateProperty.all<Color>(
                                        controller.selectedRig!=null?
                                        controller.selectedRig!.id==controller. layout.value.rigs![index].id ?Colors.blueGrey:Colors.grey
                                            :Colors.grey)
                                    ),
                                    onPressed: (){controller.rigSelect(index);},
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Rig ${controller. layout.value.rigs![index].id}',overflow: TextOverflow.clip,),
                                            IconButton(
                                              onPressed: (){controller.deleteRig(index);},
                                              icon: const Icon(Icons.delete,),
                                              hoverColor: Colors.transparent,
                                              splashRadius: 1.0,
                                              iconSize: 15,
                                              alignment: Alignment.topCenter,
                                              padding: const EdgeInsets.all(0),
                                            ),
                                          ],
                                        )));
                              },)


                          /*
                        child: ListTile(
                          //key: Key('$index'),
                          leading: Text('Item ${controller.items[index]}'),
                          tileColor: controller.items[index].isOdd ? Colors.red : Colors.green,
                          //title: Text('Item ${controller.items[index]}'),
                        ),


                         */
                        );
                      },
                      itemCount: controller. layout.value.rigs!.length,
                      onReorder: (int oldIndex, int newIndex){
                        controller.reorderRigs(oldIndex, newIndex);
                      }
                  );
                },
              ),
              ),
            ),

          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: (){controller.addRig();},
                icon: Icon(Icons.add)
            ),
          ),
          /*
          Expanded(
            flex: 1,
            child: OutlinedButton(
                onPressed: (){controller.save();},
                child: Text('Save'),
            ),
          ),

           */
        ],
      ),
    );
  }
}
