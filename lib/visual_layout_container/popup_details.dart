import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupDetails extends StatelessWidget {
  final DeviceModel? currentDevice;
  const PopupDetails(this.currentDevice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    if(currentDevice!=null && currentDevice!.manufacture=='Antminer') {
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
                        Text('${currentDevice != null ? controller
                            .currentDevice.ip : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('manufacture'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.manufacture : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('model'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.model : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('speed: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.currentSpeed.toStringAsFixed(2) : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temp: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.tMax : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hashboards: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.hashCount : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chips: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.chipPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.fans : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('freq: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.freqs : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('volt: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.volt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('watt: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.watt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hw: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.hwPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chip status: '.tr),
                        chainString(currentDevice != null ? controller
                            .currentDevice.data.chainString : null),
                       // Text('${currentDevice != null ? controller
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
    else if(currentDevice!=null && currentDevice!.manufacture=='Avalon'){
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
                        const Text('ip: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.ip : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('manufacture'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.manufacture : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('model'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.model : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('speed'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.currentSpeed.toStringAsFixed(2) : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('frequency'.tr),
                        Text('${currentDevice != null ? currentDevice!.data.freq ?? '':''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temp'.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.tMax : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('work_mode'.tr),
                        Text('${currentDevice != null ? currentDevice!.data.workMode ?? '':''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans'.tr),
                        Text(currentDevice != null ? currentDevice!.data.fans.toString() ?? '':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('board_count'.tr),
                        Text(currentDevice != null ? currentDevice!.data.hashBoardCount.toString() ?? '':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temps_by_boards'.tr),
                        Text(currentDevice != null ? currentDevice!.data.tMaxByHashBoard.toString() ?? '':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hard_errors'.tr),
                        Text(currentDevice != null ? '${currentDevice!.data.dh ??''}%/${currentDevice!.data.hw}':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('voltage_mm'.tr),
                        Text(currentDevice != null ? currentDevice!.data.voltageMM.toString() ?? '':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('voltage_out'.tr),
                        Text(currentDevice != null ? currentDevice!.data.voltageOutput.toString() ?? '':'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('errors_ecmm'.tr),
                        Text(currentDevice != null ? currentDevice!.data.ECMM.toString() ?? '':'')
                      ],
                    ),
                    /*
                    Wrap(
                      children: [
                        Text('hashboards: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.hashCount : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chips: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.chipPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.fans : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('freq: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.freqs : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('volt: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.volt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('watt: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.watt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hw: '),
                        Text('${currentDevice != null ? controller
                            .currentDevice.hwPerChain : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('chip status: '),
                        Text('${currentDevice != null ? controller
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
    else{
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
                        Text('${currentDevice != null ? controller
                            .currentDevice.ip : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('manufacture: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.manufacture : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('model: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.model : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('speed: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.currentSpeed.toStringAsFixed(2) : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temp: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.tMax : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('fans: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.fans : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('freq: '.tr),
                        Text(currentDevice != null ? currentDevice!.data.devs[0].devs.map((e)=>e.chipFrequency).toList().toString():'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('temps_chip: '.tr),
                        Text(currentDevice != null ? currentDevice!.data.devs[0].devs.map((e)=>e.chipTempMax).toList().toString():'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hard_errors: '.tr),
                        Text(currentDevice != null ? currentDevice!.data.devs[0].devs.map((e)=>e.hardwareErrors).toList().toString():'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('power_mode: '.tr),
                        Text(currentDevice != null ? currentDevice!.data.summary[0].summary[0].powerMode:'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('voltage: '.tr),
                        Text(currentDevice != null ?(currentDevice!.data.summary[0].summary[0].voltage ?? 0/100).toString():'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('error_codes_count'.tr),
                        Text(currentDevice != null ? currentDevice!.data.summary[0].summary[0].errorCodeCount.toString():'')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('factory_error_codes_count'.tr),
                        Text(currentDevice != null ? currentDevice!.data.summary[0].summary[0].factoryErrorCodeCount.toString():'')
                      ],
                    ),
                    /*
                    Wrap(
                      children: [
                        Text('volt: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.volt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('watt: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.watt : ''}')
                      ],
                    ),
                    Wrap(
                      children: [
                        Text('hw: '.tr),
                        Text('${currentDevice != null ? controller
                            .currentDevice.data.hwPerChain : ''}')
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
