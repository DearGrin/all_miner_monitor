import 'package:AllMinerMonitor/avalon_10xx/avalon_error_codes.dart';
import 'package:AllMinerMonitor/miner_overview/avalon_chip.dart';
import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Avalon89Hashboard extends StatelessWidget {
 final int boardIndex;
  const Avalon89Hashboard(this.boardIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverviewController controller = Get.put(OverviewController());
    List<Widget> _row1 = [];
    for(int i = 0; i < (controller.device[0].data.hashBoards![boardIndex].chips!.length/2).round(); i++)
      {

        _row1.add(AvalonChip(board: boardIndex, number: i)); //TODO get index of board
      }
    List<Widget> _row2 = [];
    for(int i = (controller.device[0].data.hashBoards![boardIndex].chips!.length/2).round();
      i < controller.device[0].data.hashBoards![boardIndex].chips!.length; i++)
    {
      _row2.add(AvalonChip(board: boardIndex, number: i)); //TODO get index of board
    }

    return Card(
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            SizedBox(
              height: 60,
              child: Row(
                children: _row1,
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: _row2,
              ),
            ),
          ],
        ),
      ),
    );
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
