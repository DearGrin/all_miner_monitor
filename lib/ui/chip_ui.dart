import 'package:avalon_tool/avalon_10xx/color_map.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipUi extends StatelessWidget {
  final int board;
  final int number;
  const ChipUi({required this.board, required this.number, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    return Obx(()=>Container(
            width: (MediaQuery.of(context).size.width*0.7/3-18)/6,
            height: (MediaQuery.of(context).size.width*0.7/3-18)/6,
            decoration: BoxDecoration(
              border: Border.all(),
              color: controller.displayMode==0?
              getChipColor(controller.currentDevice.value.hashBoards?[board].chips?[number].temp) : getChipColorWork(controller.currentDevice.value.hashBoards?[board].chips?[number].mw, controller.currentDevice.value.elapsed), // TODO get the data
            ),
            child: Obx(() {
              if (controller.displayMode == 0) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text((number+1).toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip #
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].voltage.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip V
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].temp.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ), //chip temp
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].mw.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip MW
                    ),
                  ],
                );
              }
              else {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('$number',
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip #
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].voltage.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip V
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].temp.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ), //chip temp
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        controller.currentDevice.value.hashBoards![board]
                            .chips![number].mw.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ), //chip MW
                    ),
                  ],
                );
              }
            }

            ),
          ),
    );
  }
  Color getChipColor(int? temp){
    return ColorMap().getColor(temp);
  }
  Color getChipColorWork(int? mw, int? elapsed){
    Color _;
    if(mw!/elapsed! > 10){
      _ = Colors.green;
    }
    else{
      _ = Colors.red;
    }// TODO add formula
    return _;
  }
}
