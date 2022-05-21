import 'package:AllMinerMonitor/service_record/record_model.dart';
import 'package:AllMinerMonitor/service_record/record_tag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordCard extends StatelessWidget {
  final RecordModel recordModel;
  const RecordCard(this.recordModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Get.theme.cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text('${recordModel.date}', style: Get.textTheme.bodyText1,)
            ),
            Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: recordModel.tags!.map((e) => RecordTag(e, false)).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                         SelectableText('${recordModel.comment}', style: Get.textTheme.bodyText1,)
                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
