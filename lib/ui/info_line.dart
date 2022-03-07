import 'package:avalon_tool/styles/text_theme.dart';
import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  final String label;
  final String? content;
  const InfoLine(this.label, {this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: ThemeText.textTheme.bodyText1,),
        Text(content ?? '',style: ThemeText.textTheme.bodyText2),
      ],
    );
  }
}
