import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Label {tempError, fanError, speedError, hashCountError, chipCountError, chipSError }
class MoreDialog extends StatelessWidget{
  final List<List<String>> errors;
  final String contLabel;
  const MoreDialog(this.errors, this.contLabel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
       return SizedBox(
      width: 600,
      height: Get.height*0.8,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: SelectableText.rich(
              TextSpan(
                  children: widgetList()
              )
          ),
        ),
      )

    );
  }
  List<TextSpan> widgetList(){
    List<TextSpan> _tmp = [
    TextSpan(text: 'Tag: $contLabel\n', style: Get.textTheme.bodyText2),
    ];
    int index = 0;
    for(List<String> e in errors){
      if(e.isNotEmpty){
        String label = Label.values[index].toString().substring(6).tr;
        _tmp.add(TextSpan(text: '$label\n', style: Get.textTheme.bodyText2));
        for(String ip in e){
          _tmp.add(TextSpan(text: '$ip\n', style: Get.textTheme.bodyText1));
        }
      }
      index++;
    }
    return _tmp;
  }
}
