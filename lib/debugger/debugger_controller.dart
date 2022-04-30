import 'dart:convert';
import 'dart:io';
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
}