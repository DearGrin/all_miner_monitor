import 'package:avalon_tool/avalon_10xx/controller_avalon.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/ui/hashboard.dart';
import 'package:avalon_tool/ui/hashboard_8_9.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HashboardDisplay extends StatelessWidget{
  const HashboardDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final ScanListController controller = Get.put(ScanListController());


    return SingleChildScrollView(
      controller: scrollController,
      child: controller.currentDevice.value.model!.startsWith('1')? Row(
        children: hashboards(controller.currentDevice.value.hashBoardCount, controller.currentDevice.value.hashBoards, controller.currentDevice.value.model), //TODO wtf with null check!
      )
      : Column(
        mainAxisSize: MainAxisSize.min,
        children: hashboards(controller.currentDevice.value.hashBoardCount, controller.currentDevice.value.hashBoards, controller.currentDevice.value.model), //TODO wtf with null check!,
      ),
    );
  }
List<Widget> hashboards(int? hashBoardsCount, List<Hashboard>? _hashboards, String? model){
  List<Widget> _tmp = [];
  if(model!.contains('1')||model!.startsWith('1')) {
    for (int i = 0; i < hashBoardsCount!; i++) {
      _tmp.add(
          Expanded(
              flex: 1,
              child: HashBoard(boardIndex: i,))
      );
    }
    if(_tmp.length>2)
      {
        Widget _ =  _tmp[1];
        _tmp.removeAt(1);
        _tmp.add(_);
      }
  }
  else{
    for(int i = 0; i < _hashboards!.length; i++){
      _tmp.add(
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Hashboard89(i,), //TODO add 8/9 ava hashboard
          )
      );
    }
  }
  return _tmp;
}
}
