import 'package:avalon_tool/visual_layout/layout_controller.dart';
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
          RotationTransition(
              turns: _animation,
              child: IconButton(onPressed: (){controller.onRefresh();}, icon: const Icon(Icons.refresh)))
        ],
      ),
      body: GetBuilder<LayoutController>(
          id: 'rigs_builder',
          builder: (_){
            return Card(
              color: Theme.of(context).cardColor,
              child: Row(
                children: rigs(controller),
              ),
            );
          }
      ),
    );
  }

  List<Widget> rigs(LayoutController  controller){
    List<Widget> _tmp = [];
    if(controller.layout.value.rigs!=null) {
      for (int i = 0; i < controller.layout.value.rigs!.length; i++) {
        _tmp.add(Expanded(
            flex: 1,
            child: RigUI(i)
        )
        );
      }
    }
    return _tmp;
  }
}
