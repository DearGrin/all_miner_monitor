import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:avalon_tool/visual_constructor/place_constructor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShelfConstructor extends StatelessWidget {
  final int rigId;
  final int shelfId;
  final int index;
  const ShelfConstructor(this.rigId, this.shelfId, this.index,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
        child: Card(
          color: Get.theme.cardTheme.color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('shelf'.trParams({'value':'$index'})),
                  IconButton(onPressed: (){controller.deleteShelf(rigId, shelfId);},
                      icon: const Icon(Icons.delete))
                ],
              ),
             const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
                      onPressed: (){controller.addMiner(rigId, shelfId);},
                      child: Text('add_miner'.tr)
                  ),
                  OutlinedButton(
                    style: Theme.of(context).outlinedButtonTheme.style?.copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                      onPressed: (){controller.addAuc(rigId, shelfId);},
                      child: Text('add_auc'.tr),
                  ),
                ],
              ),
             const SizedBox(
               width: 5,
             ),
             GetBuilder<ConstructorController>(
               id: '$rigId/$shelfId',
                 builder: (_){
                 final ScrollController scrollController = ScrollController();
                 return Expanded(
                   flex: 1,
                   child: Scrollbar(
                     controller: scrollController,
                     isAlwaysShown: true,
                     child: ReorderableListView.builder(
                       padding: const EdgeInsets.only(bottom: 10.0),
                       scrollController: scrollController,
                         scrollDirection: Axis.horizontal,
                         itemBuilder: (BuildContext context, int index){
                           return PlaceConstructor(rigId, shelfId, _.getPlace(rigId, shelfId)[index].id, _.getPlace(rigId, shelfId)[index], key: Key('$index'),);
                         },
                         itemCount: _.getPlace(rigId, shelfId).length,
                         onReorder: (int oldIndex, int newIndex){
                           _.reorderPlaces(oldIndex, newIndex, rigId, shelfId);
                         }
                     ),
                   ),
                 );
                 /*
                  return Row(
                     children: _.getPlace(rigId, shelfId).map((e) => PlaceConstructor(rigId, shelfId, e.id, e)).toList(),
                   );


                  */
                 }
             ),

            ],
          ),
        ),
      ),
    );
  }
}
