import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:get/get.dart';

class AvalonController extends GetxController{
  final Api api = Api();
  final CommandConstructor command = CommandConstructor();
  final String address;
  final int port;
  AvalonController(this.address, this.port);
  @override
  void onInit() {
    // TODO: implement onInit
    getInfo(); //TODO is await needed?
    super.onInit();
  }
  getInfo() async {
    String? info = await api.sendCommand(address, port, command.getStats(), 10);
  }
}