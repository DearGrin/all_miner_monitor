import 'package:flutter/material.dart';

class HelpUI extends StatelessWidget {
  const HelpUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Color Scheme', style: Theme.of(context).textTheme.bodyText1,),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.grey,
            ),
            Text('no data', style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.blueGrey,
            ),
            Text('speed low', style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 40,
              color: Colors.green,
            ),
            Text('speed ok', style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
        Text('Icons', style: Theme.of(context).textTheme.bodyText2,),
        Row(
          children: [
            const Icon(
              Icons.details, size: 15,
              color: Colors.red,
            ),
            Text('chip or hashboard is missing', style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.book_rounded, size: 15,
              color: Colors.red,
            ),
            Text('hashboard is missing', style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.ac_unit_outlined, size: 15,
              color: Colors.red,
            ),
            Text('temp too high', style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.flip_camera_android_outlined, size: 15,
              color: Colors.red,
            ),
            Text('fan is missing', style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.error_outline, size: 15,
              color: Colors.red,
            ),
            Text('errors on hash boards', style: Theme.of(context).textTheme.bodyText1,)
          ],
        ),
      ],
    );
  }
}
