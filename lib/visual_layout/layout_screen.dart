import 'package:AllMinerMonitor/visual_layout/layout_list_controller.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../visual_layout_container/container_layout.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutListController controller = Get.put(LayoutListController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                onPressed: (){controller.goToScanList();},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Row(
            children: [
              Text('auto_scan'.tr, textAlign: TextAlign.center,),
              Obx(()=>DropdownButton<String>(
                    value: controller.autoValue.value,
                    focusColor: Colors.transparent,
                    items: ['never', '1', '5', '10', '15', '30', '60'].map((e) => DropdownMenuItem(value: e, child: Text(e.tr, style: Get.textTheme.bodyText1,),)).toList(),
                    onChanged: (value){controller.autoSelect(value!);}
                ).marginAll(10.0),
              ),
            ],
          ),
          OutlinedButton(
              onPressed: (){controller.startScan();},
              child: Text('scan_all'.tr)
          ).marginAll(10.0),
          OutlinedButton(
              onPressed: (){controller.newLayout();},
              child: Text('add'.tr)
          ).marginAll(10.0),
          OutlinedButton(
              onPressed: (){controller.newAuto();},
              child: Text('auto_add'.tr)
          ).marginAll(10.0)
        ],
      ),
      body: Obx(()=>
          GridView.builder(
              shrinkWrap: true,
              itemCount: controller.layouts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index){
                //  return layoutTile(context, _.tags[index], controller);
                return LayoutTile(controller.layouts[index], Get.put(LayoutTileController(controller.layouts[index]), tag:controller.layouts[index].tag ));
              }
          ),
      ),
      /*
      GetBuilder<LayoutListController>(
        id: 'layout_list',
        builder: (_){
          return GridView.builder(
              shrinkWrap: true,
              itemCount: _.tags.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index){
              //  return layoutTile(context, _.tags[index], controller);
                return LayoutTile(_.layouts[index]);
              }
          );

          return Column(
             // children: _.tags.map((e) => layoutTile(context, e, _)).toList()
          );
        },
      ),


       */

    );
  }
  /*
  Widget layoutTile(BuildContext context, String? tag, LayoutListController controller){
    return SizedBox(
      //  height: 150,
      width: 350,
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text('$tag', style: Theme.of(context).textTheme.bodyText2,)),
                  Positioned(
                    left: -5,
                    top: -10,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        iconSize: 20,
                        splashRadius: 1.0,
                        onPressed: (){},
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
                        onPressed: (){},
                        icon: const Icon(Icons.more_vert_outlined,)
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              overview(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){controller.onEditTagClick(tag);}, child: Text('rename')),
                  OutlinedButton(onPressed: (){controller.editLayout(tag);}, child: Text('edit')),
                  OutlinedButton(onPressed: (){controller.deleteLayout(tag);}, child: Text('delete'))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){Get.to(()=>ContainerLayout());}, child: Text('details'))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              progressbar(),
            ],
          ),
        ),
      ),
    );
  }
  Widget overview(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('devices: 100'),
            Text('total: 100 Th/s'),
          ],
        ),
      ],
    );
  }
  Widget progressbar(){
    return Container(
      height: 10,
      color: Colors.blueGrey,
    );
  }
  */
}

