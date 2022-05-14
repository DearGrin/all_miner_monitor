import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutTile extends StatefulWidget {
  final Layout layout;
  const LayoutTile(this.layout, {Key? key}) : super(key: key);

  @override
  State<LayoutTile> createState() => _LayoutTileState();
}

class _LayoutTileState extends State<LayoutTile> with TickerProviderStateMixin{
  late LayoutTileController controller;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  @override
  void initState() {
    controller = Get.put(LayoutTileController(widget.layout), tag: widget.layout.tag);
    //controller.scanInProgressStream.stream.listen((event) {event.isEven? _controller.repeat():_controller.stop();});
    _controller.stop();
    controller.isActive.listen((event) {event? _controller.repeat():_controller.stop();});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                        child: Text('${widget.layout.tag}', style: Theme.of(context).textTheme.bodyText2,)),
                    Positioned(
                      left: -5,
                      top: -10,
                      child:  RotationTransition(
                          turns: _animation,
                          child: IconButton(onPressed: (){controller.scan();}, icon: const Icon(Icons.refresh))),
                      /*
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){controller.scan();},
                          icon: const Icon(Icons.refresh,)
                      ),
                      */
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
             const SizedBox(
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
                         const Text('SHA256'),
                          Obx(()=>Text('devices'.trParams({'value':'${controller.deviceCountSHA256}'})),),
                          Obx(()=>Text('total'.trParams({'value':(controller.speedSHA256).toStringAsFixed(2)}))),
                          Obx(()=>Text('average'.trParams({'value':(controller.speedAvgSHA256).toStringAsFixed(2)}))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SCRYPT'),
                          Obx(()=>Text('devicesGH'.trParams({'value':'${controller.deviceCountSCRYPT}'})),),
                          Obx(()=>Text('totalGH'.trParams({'value':(controller.speedSCRYPT/1000).toStringAsFixed(2)}))),
                          Obx(()=>Text('averageGH'.trParams({'value':(controller.speedAvgSCRYPT).toStringAsFixed(2)}))),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
