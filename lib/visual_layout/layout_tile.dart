import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutTile extends StatelessWidget {
  final Layout layout;
  const LayoutTile(this.layout, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutTileController controller = Get.put(LayoutTileController(layout), tag: layout.tag);
    return SizedBox(
      width: 350,
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text('${layout.tag}', style: Theme.of(context).textTheme.bodyText2,)),
                    Positioned(
                      left: -5,
                      top: -10,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){controller.scan();},
                          icon: const Icon(Icons.refresh,)
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -10,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){controller.openMenu();},
                          icon: const Icon(Icons.more_vert_outlined,)
                      ),
                    ),
                    Obx(()=>controller.isMenuOpen.value? Align(
                      alignment: Alignment.topCenter,
                      child: MouseRegion(
                        onExit: (event){controller.closeMenu();},
                        child: Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(onPressed: (){controller.onEditTagClick();}, child: Text('rename'.tr)),
                                OutlinedButton(onPressed: (){controller.editLayout();}, child: Text('edit'.tr)),
                                OutlinedButton(onPressed: (){controller.deleteLayout();}, child: Text('delete'.tr))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SHA256'),
                          Obx(()=>Text('devices: ${controller.deviceCountSHA256}')),
                          Obx(()=>Text('total: ${controller.speedSHA256}Th/s')),
                          Obx(()=>Text('average: ${controller.speedAvgSHA256}Th/s')),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SCRYPT'),
                          Obx(()=>Text('devices: ${controller.deviceCountSCRYPT}')),
                          Obx(()=>Text('total: ${controller.speedSCRYPT}Gh/s')),
                          Obx(()=>Text('average: ${controller.speedAvgSCRYPT}Gh/s')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
             const  SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){controller.openLayout();}, child: Text('details'.tr))),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(()=> LinearProgressIndicator(
                  value: controller.progress.value,
                  color: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
