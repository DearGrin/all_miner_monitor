import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupDetails extends StatelessWidget {
  const PopupDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    if(controller.currentDevice!=null && controller.currentDevice.manufacture=='Antminer') {
      return SizedBox(
        width: 500,
        child: Card(
          color: Get.theme.cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        splashColor: Colors.transparent,
                        splashRadius: 1.0,
                        onPressed: () {
                          controller.closePopup();
                        },
                        icon: const Icon(Icons.close, size: 20,)
                    )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text('ip: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.ip : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('speed: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.currentSpeed : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temp: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.tMax : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hashboards: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.hashCount : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chips: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.chipPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.fans : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('freq: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.freqs : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('volt: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.volt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('watt: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.watt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hw: '.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.data.hwPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chip status: '.tr),
                        chainString(controller.currentDevice != null ? controller
                            .currentDevice.data.chainString : null),
                       // Text('${controller.currentDevice != null ? controller
                       //     .currentDevice.chainString : ''}')
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return SizedBox(
        width: 500,
        child: Card(
          color: Theme
              .of(context)
              .cardColor,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        splashColor: Colors.transparent,
                        splashRadius: 1.0,
                        onPressed: () {
                          controller.closePopup();
                        },
                        icon: const Icon(Icons.close, size: 20,)
                    )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Text('ip: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.ip : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('speed'.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.currentSpeed : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temp'.tr),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.tMax : ''}')
                      ],
                    ),
                    /*
                    Wrap(
                      children: [
                        Text('hashboards: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.hashCount : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chips: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.chipPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.fans : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('freq: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.freqs : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('volt: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.volt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('watt: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.watt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hw: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.hwPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chip status: '),
                        Text('${controller.currentDevice != null ? controller
                            .currentDevice.chainString : ''}')
                      ],
                    ),
                    */
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  Widget chainString(List<String?>? _chainString){
    String _ = '';
    if(_chainString!=null) {
      for (String? s in _chainString) {
        String _new = '$_ $s\n';
        _ = _new;
      }
    }
    return Text(_);
  }
}
