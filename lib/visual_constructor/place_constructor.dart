import 'package:avalon_tool/visual_constructor/constructor_controller.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceConstructor extends StatelessWidget {
  final Place place;
  final int rigId;
  final int shelfId;
  final int placeId;
  const PlaceConstructor(this.rigId, this.shelfId, this.placeId, this.place, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConstructorController controller = Get.put(ConstructorController());
    return Container(
     // height: 50,
      //width: 50,
      child: place.type=='miner'? singlePlace(controller, context):aucPlace(controller, context),
    );
  }
  Widget placeControls(ConstructorController controller, BuildContext context, bool isAuc){
    final TextEditingController textEditingController = TextEditingController(text: place.ip??'');
    final ValueNotifier<String?> _error = ValueNotifier<String?>(null);
    validateIp(place.ip, _error);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: ValueListenableBuilder(
              valueListenable: _error,
              builder: (BuildContext context, String? value, Widget? child){
                return TextField(
                  //controller: TextEditingController(text: place.ip??''),
                  controller: textEditingController,
                  onChanged: (value){
                    validateIp(value, _error);
                    controller.editIp(rigId, shelfId, placeId, value);
                    },
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 10),
                  decoration: InputDecoration(
                    hintText: 'ip',
                    labelText: 'ip',
                    errorText: value,
                    contentPadding: const EdgeInsets.all(0)
                  ),
                );
              },

            ),
          ),
          Visibility(
            replacement: Container(),
              visible: isAuc,
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  Text('auc_N'.tr),
                  const SizedBox(width: 10,),
                  GetBuilder<ConstructorController>(
                      id: '$rigId/$shelfId/$placeId',
                      builder: (_){
                        return DropdownButton<int>(
                            items: <int>[0,1,2,3]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value', style: Theme.of(context).textTheme.bodyText1,),
                              );
                            }).toList(),
                            value: controller.layout.value.rigs?.firstWhere((element) => element.id==rigId).shelves?.firstWhere((element) => element.id==shelfId).places?.firstWhere((element) => element.id==placeId).aucN, //TODO get dynamic value
                            onChanged: (value){controller.editAucNumber(rigId, shelfId, placeId, value);}
                        );
                      }
                  ),
                  const SizedBox(width: 10,),
                ],
              )
          ),
          IconButton(
              onPressed: (){controller.deleteMiner(rigId, shelfId, placeId);},
              icon: const Icon(Icons.delete),
            iconSize: 20,
            padding: const EdgeInsets.all(0),
          ),
        ],
      ),
    );
  }
  Widget singlePlace(ConstructorController controller, BuildContext context){
    return Row(
      children: [
        const SizedBox(width: 2.5,),
        Container(
          width: 134,
          height: 100,
          color: Colors.blueGrey,
          child: placeControls(controller, context, false),
        ),
        const SizedBox(width: 2.5,),
      ],
    );
  }
  Widget aucPlace(ConstructorController controller, BuildContext context){
    return Row(
      children: [
        const SizedBox(width: 5.0,),
        Container(
          width: controller.settings[2]*132 + (controller.settings[2]-1)*8,
          height: 100,
          color: Colors.grey,
          child: placeControls(controller, context, true),
        ),
        const SizedBox(width: 5.0,),
      ],
    );
  }
  validateIp(String? value, ValueNotifier error){
    final RegExp _ip = RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$');
    if(value!=null && _ip.hasMatch(value)){
      error.value = null;
    }
    else{
      error.value = 'invalid ip';
    }
  }
}
