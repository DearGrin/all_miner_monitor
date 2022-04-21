import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            child: Obx(()=>Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  color: controller.noData.value? Colors.grey :
                    controller.speedLow.value? Colors.blueGrey :
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
                                          /*
                                          TextSpan(text: controller.device!=null? '${controller.device.ip??' '}\n' : '${controller.place?.ip??' '}',),
                                          TextSpan(text: controller.device!=null? '${_.device.currentSpeed.toStringAsFixed(2)} Th/s!\n' : ' '),
                                          TextSpan(text: controller.device!=null? '${controller.device.tMax??' '} C': ' '),
                                          */
                                        ]
                                    ),
                                  );
                                },
                              )

                            ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FittedBox(
                                ///dh or acn_s
                                  fit: BoxFit.scaleDown,
                                  child: Obx(()=>Icon(
                                      Icons.error_outline,
                                    color: controller.dhError.value? Colors.red : Colors.transparent,
                                    ),
                                  )
                              ),
                             FittedBox(
                               ///fan
                                 fit: BoxFit.scaleDown,
                                 child: Obx(()=>Icon(
                                     Icons.flip_camera_android_outlined,
                                   color: controller.fanError.value? Colors.red : Colors.transparent,
                                   ),
                                 )
                             ),
                             FittedBox(
                               ///temp
                                 fit: BoxFit.scaleDown,
                                 child: Obx(()=> Icon(
                                     Icons.ac_unit_outlined,
                                   color: controller.tempError.value? Colors.red : Colors.transparent,
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
                                    color: controller.chipCount.value? Colors.red : controller.hashCount.value? Colors.red : Colors.transparent,
                                  ),
                                  )
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
