import 'package:AllMinerMonitor/visual_constructor/constructor_model.dart';
import 'package:AllMinerMonitor/visual_layout/layout_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutTile extends StatefulWidget {
  final Layout layout;
  final LayoutTileController controller;
  const LayoutTile(this.layout, this.controller, {Key? key}) : super(key: key);

  @override
  State<LayoutTile> createState() => _LayoutTileState();
}

class _LayoutTileState extends State<LayoutTile> with TickerProviderStateMixin{
  //late LayoutTileController controller;
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
   // Get.create(()=>LayoutTileController((widget.layout)),tag: widget.layout.tag, permanent: false);
   // controller = Get.find(tag: widget.layout.tag);
    print('init tile');
    //controller = Get.put(LayoutTileController(widget.layout), tag: widget.layout.tag));
    //controller.scanInProgressStream.stream.listen((event) {event.isEven? _controller.repeat():_controller.stop();});
    _controller.stop();
   widget.controller.isActive.listen((event) {event? _controller.repeat():_controller.stop();});
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
                          child: IconButton(onPressed: (){widget.controller.scan(true);}, icon: const Icon(Icons.refresh))),
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
                      right: 60,
                      top: -10,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){widget.controller.showGraphs();},
                          icon:  const Icon(Icons.stacked_line_chart_outlined),
                          tooltip: 'graphs'.tr,
                      ),

                    ),
                    Positioned(
                      right: 30,
                      top: -10,
                      child: Obx(()=>IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: 20,
                            splashRadius: 1.0,
                            onPressed: (){widget.controller.switchMode();},
                            icon:  Icon(widget.controller.viewMode.value==0? Icons.list_alt_outlined : Icons.settings_overscan_outlined),
                            tooltip: 'toggle_view'.tr,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -10,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          splashRadius: 1.0,
                          onPressed: (){widget.controller.openMenu();},
                          icon: const Icon(Icons.more_vert_outlined,)
                      ),
                    ),
                    Obx(()=>widget.controller.isMenuOpen.value? Align(
                      alignment: Alignment.topCenter,
                      child: MouseRegion(
                        onExit: (event){widget.controller.closeMenu();},
                        child: Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(onPressed: (){widget.controller.onEditTagClick();}, child: Text('rename'.tr)),
                                OutlinedButton(onPressed: (){widget.controller.editLayout();}, child: Text('edit'.tr)),
                                OutlinedButton(onPressed: (){widget.controller.deleteLayout();}, child: Text('delete'.tr))
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
              Obx(()=>IndexedStack(
                  index: widget.controller.viewMode.value,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(()=> Text('scan_res'.trParams({'value':'${widget.controller.scannedDevices.value}/${widget.controller.layout.ips?.length}'}))),
                                const Divider(),
                                const Text('SHA256'),
                                Obx(()=>Text('devices'.trParams({'value':'${widget.controller.deviceCountSHA256}'})),),
                                Obx(()=>Text('total'.trParams({'value':(widget.controller.speedSHA256).toStringAsFixed(2)}))),
                                Obx(()=>Text('average'.trParams({'value':(widget.controller.speedAvgSHA256).toStringAsFixed(2)}))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(()=>Text('with_problems'.trParams({'value':'${widget.controller.totalErrors.length}'})),),
                               const Divider(),
                                const Text('SCRYPT'),
                                Obx(()=>Text('devicesGH'.trParams({'value':'${widget.controller.deviceCountSCRYPT}'})),),
                                Obx(()=>Text('totalGH'.trParams({'value':(widget.controller.speedSCRYPT/1000).toStringAsFixed(2)}))),
                                Obx(()=>Text('averageGH'.trParams({'value':(widget.controller.speedAvgSCRYPT).toStringAsFixed(2)}))),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                                Obx(()=>Text('speed_error'.trParams({'value':'${widget.controller.speedErrors.length}'})),),
                                Obx(()=>Text('temp_error'.trParams({'value':'${widget.controller.tempErrors.length}'}))),
                                Obx(()=>Text('fan_error'.trParams({'value':'${widget.controller.fanErrors.length}'})),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(()=>Text('hash_count_error'.trParams({'value':'${widget.controller.hashCountErrors.length}'})),),
                                Obx(()=>Text('chip_count_error'.trParams({'value':'${widget.controller.chipCountErrors.length}'}))),
                                Obx(()=>Text('chip_s_error'.trParams({'value':'${widget.controller.chipsSErrors.length}'})),),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        OutlinedButton(
                            onPressed: (){widget.controller.showMore();},
                            child: Text('more'.tr)
                        ).marginAll(10.0)
                      ],
                    ),
                  ],
                ),
              ),
             const  SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){widget.controller.openLayout();}, child: Text('details'.tr))),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(()=> LinearProgressIndicator(
                  value: widget.controller.progress.value,
                ),
              ),
              Obx(()=>Text('last_scan'.trParams({'value':widget.controller.lastScanTime.value}))),
            ],
          ),
        ),
      ),
    );
  }
}
