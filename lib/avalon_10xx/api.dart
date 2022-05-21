import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Api{

 static Future<String> sendCommand(String address, int port, String command, int timeout) async {
   String? callback;
   dynamic ev;
   handleCallback(String _callback){
     callback = _callback;
     return _callback;
  //   eventStream.add(_callback.toString());
   }
   try {
     Socket socket = await Socket.connect(
         address, port, timeout: Duration(seconds: timeout));
     socket.listen((dynamic event) {
       handleCallback(event.toString());
       //callback = utf8.decode(event);
    //   eventStream.add(event.toString());
       callback = event.toString();
       socket.close();
     });
     socket.add(utf8.encode(command));
   }
   catch(err){
     callback = '$err';
     return '$err';
    // callback = mockData;
   }

    return callback??'error';
  }

}