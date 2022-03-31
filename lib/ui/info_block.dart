import 'package:avalon_tool/styles/text_theme.dart';
import 'package:avalon_tool/ui/info_line.dart';
import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final String label;
  final List<Map<String,String>>? infos;
  const InfoBlock(this.label, {this.infos, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
     // constraints: const BoxConstraints(maxWidth: 500), //TODO remove later
      child: Card(
        color: Colors.grey,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(label, style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: infoList(),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  List<Widget> infoList(){
    List<Widget> _tmp = [];
    for(int i = 0; i < infos!.length; i++)
      {
        _tmp.add(InfoLine(infos![i].keys.first, content: infos?[i].values.first,));
      }
    return _tmp;
  }
}
