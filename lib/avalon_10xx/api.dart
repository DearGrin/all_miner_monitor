import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';

class Api{

 Future<String> sendCommand(String address, int port, String command, int timeout) async {
   String? callback;
   try {
     Socket socket = await Socket.connect(
         address, port, timeout: Duration(seconds: timeout));
     socket.listen((List<int> event) {
       handleCallback(utf8.decode(event));
       callback = utf8.decode(event);
       socket.close();
     });
     socket.add(utf8.encode(command));
   }
   catch(err){
     callback = '$err';
   }
    return callback??'error';
  }
  handleCallback(String callback){
    debugPrint(callback);
  }
}