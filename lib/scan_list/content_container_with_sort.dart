import 'package:avalon_tool/avalon_10xx/analyse_resolver.dart';
import 'package:avalon_tool/scan_list/rasp_controller.dart';
import 'package:avalon_tool/scan_list/resize_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentContainerWithSort extends StatelessWidget {
  final int index;
  final dynamic value;
  final String tag;
  final String sort;
  final String? type;
  const ContentContainerWithSort(this.index, this.value, this.tag, this.sort,
      [this.type,Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
    final RaspController controller = Get.put(RaspController(), tag: tag);
    return GetBuilder<ResizeController>(
        id: 'content_$index',
        builder: (_) {
          if(_.headers[index].isVisible??true) {
            return Obx(() =>
                InkWell(
                  onTap: (){controller.onClick(index, sort);},
                  onDoubleTap: (){controller.expand();},
                  child: Container(
                    height: 40,
                    width: _.widths[index],
                    decoration: BoxDecoration(border: Border.all(), color: Theme.of(context).cardTheme.color,),
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: analyseResolver.getColor(type, value)),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          //top: 5,
                          child: Obx(()=>IndexedStack(
                              index: controller.sortId[index],
                              children: [
                                Container(),
                                const Icon(Icons.arrow_downward_outlined),
                                const Icon(Icons.arrow_upward_outlined)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
