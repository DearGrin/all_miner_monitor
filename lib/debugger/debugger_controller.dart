import 'dart:convert';
import 'dart:io';
import 'package:AllMinerMonitor/isolates/generate_whatsminer_command.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class DebuggerController extends GetxController{
  String? ip;
  String? command;
  RxString data = ''.obs;
  editIp(String value){
    ip = value;
  }
  editCommand(String value){
    command = value;
  }
  handler(String _data){
    data.value = _data;
  }
  sendCommand() async {
    try {
      Socket socket = await Socket.connect(
          ip, 4028, timeout: const Duration(seconds: 5));
      socket.listen((dynamic event) {
        handler(utf8.decode(event));
        socket.close();
      });
      socket.add(utf8.encode(command!));
    }
    catch(e){
      data.value = e.toString();
    }
  }
  saveLog()async{
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    if(!Directory('$appDocumentsPath/All Miner/logs').existsSync()) {
      Directory('$appDocumentsPath/All Miner/logs').create();
    }
    String filePath = '$appDocumentsPath/All Miner/logs/all_miner_log_${DateTime.now().month}${DateTime.now().day}_${DateTime.now().hour}_${DateTime.now().minute}${DateTime.now().millisecond}.txt';
    File file = File(filePath); // 1
    file.writeAsString(data.value); // 2
    String _path = filePath.replaceAll('\\', '/');
    Get.snackbar('Save complete', _path,);
  }
  tryToken()async{
    RegExp regExp = RegExp(r'(Msg=\()(.*?)(\))');
    String _ = regExp.firstMatch(data.value)?.group(2)??'';
    String _p = 'admin';
    String _c = 'reboot';
    String result = await generateCommand(_, _p, _c);
    data.value = result;
  }
}