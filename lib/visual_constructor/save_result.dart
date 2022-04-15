import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveResult extends StatelessWidget {
  final String message;
  const SaveResult(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyText1,),
        SizedBox(height: 20,),
        OutlinedButton(
            onPressed: (){Get.back();},
            child: Text('Ok', style: Theme.of(context).textTheme.bodyText1,))
      ],
    );
  }
}
