import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpUI extends StatelessWidget {
  const HelpUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('color_scheme'.tr, style: Get.textTheme.bodyText1,),
        const SizedBox(height: 10.0,),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.grey,
            ),
            const SizedBox(width: 10.0,),
            Text('no_data'.tr, style: Get.textTheme.bodyText1,),
          ],
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.blueGrey,
            ),
            const SizedBox(width: 10.0,),
            Text('speed_low'.tr, style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.green,
            ),
            const SizedBox(width: 10.0,),
            Text('speed_ok'.tr, style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
        Text('icons'.tr, style: Theme.of(context).textTheme.bodyText2,),
        const SizedBox(height: 10.0,),
        Row(
          children: [
            const Icon(
              Icons.details, size: 15,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0,),
            Text('chip or hashboard is missing'.tr, style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.book_rounded, size: 15,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0,),
            Text('hashboard is missing'.tr, style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.ac_unit_outlined, size: 15,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0,),
            Text('temp too high'.tr, style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.flip_camera_android_outlined, size: 15,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0,),
            Text('fan is missing'.tr, style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.error_outline, size: 15,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0,),
            Text('errors on hash boards'.tr, style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
      ],
    );
  }
}
