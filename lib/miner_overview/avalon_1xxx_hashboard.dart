import 'package:AllMinerMonitor/avalon_10xx/avalon_error_codes.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_chip.dart';
import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Avalon1xxxHashboard extends StatelessWidget{
  final int boardIndex;
  const Avalon1xxxHashboard({required this.boardIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverviewController controller = Get.put(OverviewController());
    return Card(
        color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$boardIndex', style: Theme.of(context).textTheme.bodyText2,),
            Text('errors_det'.tr),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
               SelectableText.rich(
                 TextSpan(
                   children: errors(controller.device[0].data.ECHU?[boardIndex], context)
                 )
               ),
              ],
            ),
            Column(
              children: chips(controller),
            ),
            /*
            chipRow([111, 112, 113]),
            chipRow([110, 109, 108]),
            chipRow([105, 106, 107, 0, 1, 2]),
            chipRow([104, 103, 102, 5, 4, 3]),
            chipRow([99, 100, 101, 6, 7, 8]),
            chipRow([98, 97, 96, 11, 10 ,9]),
            chipRow([93, 94, 95, 12, 13, 14]),
            chipRow([92, 91, 90, 17, 16, 15]),
            chipRow([87, 88, 89, 18, 19, 20]),
            chipRow([86, 85, 84, 23, 22, 21]),
            chipRow([81, 82, 83, 24, 25, 26]),
            chipRow([80, 79, 78, 29, 28, 27]),
            chipRow([75, 76, 77, 30, 31, 32]),
            chipRow([74, 73, 72, 35, 34, 33]),
            chipRow([69, 70, 71, 36, 37, 38]),
            chipRow([68, 67, 66, 41, 40, 39]),
            chipRow([63, 64, 65, 42, 43, 44]),
            chipRow([62, 61, 60, 47, 46, 45]),
            chipRow([57, 58, 59, 48, 49, 50]),
            chipRow([56, 55, 54, 53, 52, 51]),

             */
          ],
        ),
      ),
    );
  }
  Widget chipRow(List<int> chipNumbers){
    return Row(
      children: chipNumbers.map(
              (e) => AvalonChip(number: e, board: boardIndex,)
      ).toList(),
    );
  }
  List<Widget> chips(OverviewController controller){
    List<Widget> _tmp = [];
    if(controller.device[0].model.contains('1066'))
      {
        int _rowCount = (controller.device[0].data.hashBoards[boardIndex].chips.length/6).floor() +1;
        int _index = 0;
        for(int i = 0; i < _rowCount; i++){
          List<Widget> _right = [];
          List<Widget> _left = [];
          if(i<2){
            _right.add(AvalonChip(board: boardIndex, number: -1));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-(i*3)-1));
            _right.add(AvalonChip(board: boardIndex, number: -1));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-(i*3)-2));
            _right.add(AvalonChip(board: boardIndex, number: -1));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-(i*3)-3));
          }
          else {
            _right.add(AvalonChip(board: boardIndex, number: _index));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-7));
            _index++;
            _right.add(AvalonChip(board: boardIndex, number: _index));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-7));
            _index++;
            _right.add(AvalonChip(board: boardIndex, number: _index));
            _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-7));
            _index++;
          }
          if(i.isOdd){
            _right = _right.reversed.toList();

          }
          else{
            _left = _left.reversed.toList();
          }
          List<Widget> _chipRow = _left + _right;
          _tmp.add(Row(children: _chipRow,));
        }
      }
    else{
      int _rowCount = (controller.device[0].data.hashBoards[boardIndex].chips.length/6).floor();
      int _index = 0;
      for(int i = 0; i < _rowCount; i++){
        List<Widget> _right = [];
        List<Widget> _left = [];
        _right.add(AvalonChip(board: boardIndex, number: _index));
        _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-1));
        _index++;
        _right.add(AvalonChip(board: boardIndex, number: _index));
       _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-1));
        _index++;
        _right.add(AvalonChip(board: boardIndex, number: _index));
        _left.add(AvalonChip(board: boardIndex, number: controller.device[0].data.hashBoards[boardIndex].chips.length-_index-1));
        _index++;
        if(i.isOdd){
          _right = _right.reversed.toList();
        }
        else{
          _left = _left.reversed.toList();
        }
        List<Widget> _chipRow = _left + _right;
        _tmp.add(Row(children: _chipRow,));
      }
    }
    return _tmp;
  }
  List<InlineSpan> errors(List<AvalonError?>? errors, BuildContext context){
    List<InlineSpan> _tmp = [];
    if(errors!=null){
      for(int i = 0; i<errors.length; i++){
        String _ = errors[i]?.id.toString()??'';
        _tmp.add(TextSpan(
          text: '\n'+_ + ' - ' + errors[i]!.descr +'\n',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
          null // TODO get from analyze
          ),
        ));
      }
    }
    return _tmp;
  }
}
