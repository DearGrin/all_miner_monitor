import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'place_controller.dart';

class PlaceUI extends StatelessWidget {
  final Place place;
  final int placeIndex;
  const PlaceUI(this.place, this.placeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlaceController controller = Get.put(PlaceController(), tag: '${place.id}/$placeIndex');
    controller.setData(place, placeIndex);
    return Obx(()=>SizedBox(
        width: controller.size.value,
        height: controller.size.value,
        child: MouseRegion(
          onHover: (PointerEvent details){controller.setOffset(details);},
          child: GestureDetector(
            onDoubleTap: (){controller.onDoubleTap();},
            onTap: (){controller.onSingleTap();},
            onSecondaryTap: (){controller.onSecondaryTap();},
            onLongPress: (){controller.onLongTapTap();},
            onSecondaryLongPress: (){controller.onSecondaryLongPress();},
            child: Stack(
              children: [
                Obx(()=>Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      color: controller.noData.value? Colors.grey : controller.currentDevice.value.speedError==null? Colors.grey :
                        controller.currentDevice.value.speedError!? Colors.blueGrey :
                      Colors.green[200],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child:  Obx(()=>RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: '',
                                          children: [
                                            TextSpan(text: '${controller.currentDevice.value.currentSpeed?.toStringAsFixed(2)}\n',),
                                            TextSpan(text: '${controller.currentDevice.value.tMax.toString()}\n'),
                                            TextSpan(text: place.ip),
                                          ]
                                      ),
                                    ),
                                  ),
                                  /*
                                  child: GetBuilder<PlaceController>(
                                    init: Get.put(PlaceController(), tag: '${place.id}/$placeIndex'),
                                    id: 'text',
                                    builder: (_){
                                      return RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: '',
                                            children: [
                                              TextSpan(text: controller.speed.value,),
                                              TextSpan(text: controller.temp.value),
                                              TextSpan(text: controller.ip.value),
                                            ]
                                        ),
                                      );
                                    },
                                  )
*/
                                ),
                              ],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0),
                              child: Obx(()=>Visibility(
                                  replacement: Container(),
                                  visible: !controller.noData.value && controller.currentDevice.value.speedError!=null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FittedBox(
                                        ///dh or acn_s
                                          fit: BoxFit.scaleDown,
                                          child: Obx(()=>Icon(
                                              Icons.error_outline,
                                            color: controller.currentDevice.value.chipsSError!? Colors.red : Colors.transparent,
                                            ),
                                          )
                                      ),
                                     FittedBox(
                                       ///fan
                                         fit: BoxFit.scaleDown,
                                         child: Obx(()=>Icon(
                                             Icons.flip_camera_android_outlined,
                                           color: controller.currentDevice.value.fanError!? Colors.red : Colors.transparent,
                                           ),
                                         )
                                     ),
                                     FittedBox(
                                       ///temp
                                         fit: BoxFit.scaleDown,
                                         child: Obx(()=> Icon(
                                             Icons.ac_unit_outlined,
                                           color: controller.currentDevice.value.tempError!? Colors.red : Colors.transparent,
                                           ),
                                         )
                                     ),
                                      /*
                                      FittedBox(
                                        ///hash count
                                          fit: BoxFit.scaleDown,
                                          child: Obx(()=> Icon(
                                            Icons.book_rounded, size: 10,
                                            color: controller.hashCount.value? Colors.red : Colors.transparent,
                                          ),
                                          )
                                      ),
                                      */
                                      FittedBox(
                                        ///chip count
                                          fit: BoxFit.scaleDown,
                                          child: Obx(()=> Icon(
                                            Icons.details,
                                            color: controller.currentDevice.value.chipCountError!? Colors.red : controller.currentDevice.value.hashCountError!? Colors.red : Colors.transparent,
                                          ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Obx(()=>Visibility(
                    visible: controller.isSelected.value,
                    replacement: Container(),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.check_circle_outline, color: Colors.red,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
