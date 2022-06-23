
import 'package:flutter/material.dart';

class IsolateMessageModel{
  String ip;
  String command;
  int delay;
  int timeout;
  int? isolateIndex;
  String? manufacture;
  String? addCommand;
  String? tag;
  List<Map<dynamic,dynamic>>? credentials;
  IsolateMessageModel({required this.ip,
    required this.command,
    required this.delay,
    required this.timeout,
    this.isolateIndex,
    this.manufacture,
    this.addCommand,
    this.credentials,
    this.tag});
  Map<String, dynamic>toMap(){
    return {
      'ip':ip,
      'command':command,
      'delay': delay,
      'timeout': timeout,
      'isolateIndex': isolateIndex,
      'manufacture':manufacture,
      'addCommand': addCommand,
      'credentials':credentials,
      'tag':tag,
    };
  }
}