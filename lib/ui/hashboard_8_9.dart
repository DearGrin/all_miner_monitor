import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:avalon_tool/ui/chip_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Hashboard89 extends StatelessWidget {
 final int boardIndex;
  const Hashboard89(this.boardIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanListController controller = Get.put(ScanListController());
    List<Widget> _row1 = [];
    for(int i = 0; i < (controller.currentDevice.value.hashBoards![boardIndex].chips!.length/2).round(); i++)
      {

        _row1.add(ChipUi(board: boardIndex, number: i)); //TODO get index of board
      }
    List<Widget> _row2 = [];
    for(int i = (controller.currentDevice.value.hashBoards![boardIndex].chips!.length/2).round(); i < controller.currentDevice.value.hashBoards![boardIndex].chips!.length; i++)
    {
      _row2.add(ChipUi(board: boardIndex, number: i)); //TODO get index of board
    }

    return Card(
      color: Colors.grey,
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
                        children: errors(controller.currentDevice.value.ECHU?[boardIndex], context)
                    )
                ),
              ],
            ),
            Container(
              height: 60,
              child: Row(
                children: _row1,
              ),
            ),
            Container(
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
