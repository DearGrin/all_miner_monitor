import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/layout_model.dart';
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
    return SizedBox(
      width: 50,
      height: 50,
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
                      flex: 3,
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
                                  text: TextSpan(
                                      text: '',
                                      children: [
                                        TextSpan(text: controller.device!=null? '${controller.device.ip??' '}\n' : '${controller.place?.ip??' '}',),
                                        TextSpan(text: controller.device!=null? '${_.device.currentSpeed.toStringAsFixed(2)} Th/s!\n' : ' '),
                                        TextSpan(text: controller.device!=null? '${controller.device.tMax??' '} C': ' '),
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
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Obx(()=>Icon(
                                        Icons.error_outline, size: 15,
                                      color: controller.dhError.value? Colors.red : Colors.transparent,
                                      ),
                                    )
                                )
                            ),
                           Align(
                               alignment: Alignment.center,
                               child: FittedBox(
                                   fit: BoxFit.scaleDown,
                                   child: Obx(()=>Icon(
                                       Icons.flip_camera_android_outlined, size: 15,
                                     color: controller.fanError.value? Colors.red : Colors.transparent,
                                     ),
                                   )
                               )
                           ),
                           Align(
                               alignment: Alignment.centerRight,
                               child: FittedBox(
                                   fit: BoxFit.scaleDown,
                                   child: Obx(()=> Icon(
                                       Icons.hot_tub_outlined, size: 15,
                                     color: controller.tempError.value? Colors.red : Colors.transparent,
                                     ),
                                   )
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
    );
  }

}
