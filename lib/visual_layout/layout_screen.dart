import 'package:avalon_tool/visual_constructor/constructor_layout.dart';
import 'package:avalon_tool/visual_constructor/cont_rig_row_controls.dart';
import 'package:avalon_tool/visual_constructor/layout_list_controller.dart';
import 'package:avalon_tool/visual_constructor/layouts_list.dart';
import 'package:avalon_tool/visual_constructor/rig_creation_form.dart';
import 'package:avalon_tool/visual_layout/container_ui.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  body: ContainerLayout(),
      //body: RigCreationForm(),
      //body: ConstructorLayout(),
      body: LayoutsList(),
    );
  }
}
