import 'package:avalon_tool/avalon_10xx/analyse_resolver.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentContainer extends StatelessWidget {
  final int index;
  final dynamic value;
  final String? type;
  ContentContainer(this.index, this.value, [this.type,Key? key]) : super(key: key);

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
                    value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color: analyseResolver.getColor(type, value)),
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
