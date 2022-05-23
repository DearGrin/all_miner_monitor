//import 'package:hive/hive.dart';

debug({String? subject, String? message, String? function}) async {
  print('$subject in $function\n$message');
  //Box box = await Hive.openBox('log');
 // box.add({'event':subject, 'function':function, 'message':message});
}