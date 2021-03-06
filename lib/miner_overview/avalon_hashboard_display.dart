import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_1xxx_hashboard.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_hashboard_8_9.dart';
import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvalonHashboardDisplay extends StatelessWidget{
  const AvalonHashboardDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final OverviewController controller = Get.put(OverviewController());

    return SingleChildScrollView(
      controller: scrollController,
      child: controller.device[0].model!.startsWith('1')? Row(
        children: hashboards(controller.device[0].data.hashBoardCount, controller.device[0].data.hashBoards, controller.device[0].data.model), //TODO wtf with null check!
      )
      : Column(
        mainAxisSize: MainAxisSize.min,
        children: hashboards(controller.device[0].data.hashBoardCount, controller.device[0].data.hashBoards, controller.device[0].data.model), //TODO wtf with null check!,
      ),
    );
  }
List<Widget> hashboards(int? hashBoardsCount, List<Hashboard>? _hashboards, String? model){
  List<Widget> _tmp = [];
  if(model!.startsWith('1')) {
    for (int i = 0; i < hashBoardsCount!; i++) {
      _tmp.add(
          Expanded(
              flex: 1,
              child: Avalon1xxxHashboard(boardIndex: i,))
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
            child: Avalon89Hashboard(i,), //TODO add 8/9 ava hashboard
          )
      );
    }
  }
  return _tmp;
}
}
