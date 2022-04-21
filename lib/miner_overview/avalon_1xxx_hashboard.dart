import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/miner_overview/avalon_chip.dart';
import 'package:avalon_tool/miner_overview/overview_controller.dart';
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
                   children: errors(controller.device[0].ECHU?[boardIndex], context)
                 )
               ),
              ],
            ),
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
