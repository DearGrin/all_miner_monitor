import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Label {tempError, fanError, speedError, hashCountError, chipCountError, chipSError }
class MoreDialog extends StatelessWidget{
  final List<List<String>> errors;
  const MoreDialog(this.errors,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return SizedBox(
      width: 600,
      height: Get.height*0.8,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: errors[index].map((e) => Text(e)).toList(),
            );
          },
          separatorBuilder: (BuildContext context, int index){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Label.values[index].toString().substring(6).tr
                ),
              ],
            );
          },
          itemCount: 6
      ),
    );
  }
}
