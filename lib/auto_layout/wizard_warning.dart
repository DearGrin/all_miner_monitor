import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WizardWarning extends StatelessWidget {
  final String message;
  const WizardWarning(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyText1,),
        const SizedBox(height: 20,),
        OutlinedButton(onPressed: (){Get.back();}, child: const Text('Ok')),
      ],
    );
  }
}
