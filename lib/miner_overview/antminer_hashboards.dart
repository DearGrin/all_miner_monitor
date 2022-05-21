import 'package:AllMinerMonitor/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AntminerHashboards extends StatelessWidget {
  const AntminerHashboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverviewController controller = Get.put(OverviewController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Get.theme.cardTheme.color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: hashes(controller.device[0].data.chainString, context)
          ),
        ),
      ),
    );
  }
  List<Widget> hashes(List<String?> _chainString, BuildContext context){
    List<Widget> _tmp = [];
    for (String? s in _chainString){
      _tmp.add(acnS(s!, context));
    }
    return _tmp;
  }
  Widget acnS(String acns, BuildContext context){
    List<InlineSpan> _tmp = [];
    for(int i = 0; i<acns.length; i++){
      _tmp.add(
          TextSpan(
            text: acns[i].toString(),
            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: acns[i]=='x'? Colors.red:null),
          )
      );
    }
    return SelectableText.rich(
      TextSpan(
        children: _tmp
      ),
    );
  }
}
