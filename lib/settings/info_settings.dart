import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class InfoSettings extends StatelessWidget {
  const InfoSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'info_content'.tr,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
