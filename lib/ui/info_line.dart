
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class InfoLine extends StatelessWidget {
  final String label;
  final String? content;
  const InfoLine(this.label, {this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(label.tr, style: Theme.of(context).textTheme.bodyText1,),
        Text(content ?? '', style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
