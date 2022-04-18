import 'package:avalon_tool/visual_layout/help_ui.dart';
import 'package:avalon_tool/visual_layout/layout_controller.dart';
import 'package:avalon_tool/visual_layout/popup_details.dart';
import 'package:avalon_tool/visual_layout/rig_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerLayout extends StatefulWidget {
  final String tag;
  const ContainerLayout(this.tag, {Key? key}) : super(key: key);

  @override
  State<ContainerLayout> createState() => _ContainerLayoutState();
}

class _ContainerLayoutState extends State<ContainerLayout> with TickerProviderStateMixin{
  final LayoutController  controller = Get.put(LayoutController());
  final ScrollController scrollController = ScrollController();
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
    // TODO: implement initState
    controller.setData(widget.tag);
    controller.scanInProgressStream.stream.listen((event) {event==true? _controller.repeat():_controller.stop();});
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {



    //controller.scanInProgressStream.stream.listen((event) {event==true? _controller.repeat():_controller.stop();});


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tag, style: Theme.of(context).textTheme.bodyText2,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){controller.zoomIn();}, icon: const Icon(Icons.zoom_in)),
          IconButton(onPressed: (){controller.zoomOut();}, icon: const Icon(Icons.zoom_out)),
          IconButton(onPressed: (){Get.defaultDialog(title: '', content: const HelpUI());}, icon: const Icon(Icons.help_outline_outlined)),
          RotationTransition(
              turns: _animation,
              child: IconButton(onPressed: (){controller.onRefresh();}, icon: const Icon(Icons.refresh)))
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
              top: (controller.offset.value.dy+50)>(7*50)?(controller.offset.value.dy-100):(controller.offset.value.dy-50),
             child: controller.offset.value == const Offset(0,0)? Container() : PopupDetails(),
            //  child: controller.offset.value == const Offset(0,0)? Container() : Text('${controller.offset.value.dx} / ${scrollController.offset} / ${Get.width} / ${(controller.offset.value.dx + scrollController.offset)>Get.width? true:false} / ${(controller.offset.value.dx + scrollController.offset)}'),
            )
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
