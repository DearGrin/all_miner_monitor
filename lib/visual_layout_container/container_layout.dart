import 'package:AllMinerMonitor/visual_layout_container/help_ui.dart';
import 'package:AllMinerMonitor/visual_layout_container/layout_controller.dart';
import 'package:AllMinerMonitor/visual_layout_container/popup_details.dart';
import 'package:AllMinerMonitor/visual_layout_container/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'rig_layout.dart';

class ContainerLayout extends StatelessWidget {
  const ContainerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutController  controller = Get.put(LayoutController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.layout.value.tag}', style: Theme.of(context).textTheme.bodyText2,),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Obx(()=> Text('last_scan'.trParams({'value':controller.lastScan.value}))),
            ],
          ),
          /*
          OutlinedButton(onPressed: (){controller.onCommandClick();}, child: Text('commands'.tr)).marginAll(10.0),
          */
          IconButton(onPressed: (){controller.zoomIn();}, icon: const Icon(Icons.zoom_in)),
          IconButton(onPressed: (){controller.zoomOut();}, icon: const Icon(Icons.zoom_out)),
          IconButton(onPressed: (){Get.defaultDialog(title: '', content: const HelpUI());}, icon: const Icon(Icons.help_outline_outlined)),
           Obx(()=> Visibility(
                visible: !controller.scanIsActive.value,
                replacement: const SizedBox(height: 20, width: 25, child: FittedBox(fit: BoxFit.contain, child: CircularProgressIndicator())),
                child: SizedBox(width: 25, child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: (){controller.onRefresh();}, icon: const Icon(Icons.refresh)))
          ),
          ),
          const SizedBox(width: 10.0,)
        ],
      ),
      body: Container(
        height: Get.height,
        constraints: BoxConstraints(minWidth: Get.width),
        child: Stack(
          children: [
            GetBuilder<LayoutController>(
                id: 'rigs_builder',
                builder: (_){
                  return Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: scrollController,
                        child: Card(
                          color: Theme.of(context).cardColor,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: rigs(controller),
                              ),
                            ],


                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
            Obx(()=>Positioned(
              //TODO get max row possible + get size of pop up
              left: (controller.offset.value.dx + 500)>Get.width?
              (controller.offset.value.dx -500) // move to the left
                  :
              (controller.offset.value.dx), // place as is
              //top: (controller.offset.value.dy+50)>(7*50)?(controller.offset.value.dy-100):(controller.offset.value.dy-50),
              top: (controller.offset.value.dy+400)>Get.height? (controller.offset.value.dy-400):(controller.offset.value.dy-50),
              child: controller.offset.value == const Offset(0,0)? Container() :
              Obx(()=>Visibility(
                  visible: controller.displayPopup.value==0,
                  replacement: const PopupMenu(),
                  child: PopupDetails(controller.currentDevice))),
              ),
              //  child: controller.offset.value == const Offset(0,0)? Container() : Text('${controller.offset.value.dx} / ${scrollController.offset} / ${Get.width} / ${(controller.offset.value.dx + scrollController.offset)>Get.width? true:false} / ${(controller.offset.value.dx + scrollController.offset)}'),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> rigs(LayoutController  controller){
    List<Widget> _tmp = [];
    if(controller.layout.value.rigs!=null) {
      for (int i = 0; i < controller.layout.value.rigs!.length; i++) {
        _tmp.add(RigUI(i)
        );
      }
    }
    return _tmp;
  }
}
