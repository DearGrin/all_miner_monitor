import 'package:AllMinerMonitor/analyzator/analyse_resolver.dart';
import 'package:AllMinerMonitor/scan_list/resize_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentContainer extends StatelessWidget {
  final int index;
  final dynamic value;
  final String? type;
  final String? model;
  const ContentContainer(this.index, this.value, [this.type, this.model, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
    return GetBuilder<ResizeController>(
        id: 'content_$index',
        builder: (_) {
          if(_.headers[index].isVisible??true) {
            return Obx(() =>
                Container(
                  height: 40,
                  width: _.widths[index],
                  decoration: BoxDecoration(border: Border.all(), color: Theme.of(context).cardTheme.color,),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value==null? '' :value==-100? '' : value==-100.0? '' : value.runtimeType.toString()=='double'? value.toStringAsFixed(2) : value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color: analyseResolver.getColor(type, value, model)),
                  ),
                ),
            );
          }
          else{
            return Container();
          }
        }
    );
  }
}
