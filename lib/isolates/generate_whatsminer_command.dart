import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart'  as encrypt;

Future<String>generateCommand(String token, String adminPassword, String command)async{
  ///default user password: admin:admin
  ///token from plain text split by space
  List<String> _token = token.split(' ');
  String _time = _token[0];
  String _salt = _token[1];
  String _newSalt = _token[2];
  String _timeSec = _time.substring(_time.length-4); /// take last 4 symbols
  print('time: $_time, salt: $_salt, newSalt: $_newSalt, timeSec: $_timeSec');
  ///calculate admin key
  String inputForKey = adminPassword+_salt;
  Digest key = md5.convert(utf8.encode(inputForKey));
  String _keyForAes = base64.encode(key.bytes);
  String inputForSign = _newSalt+key.toString()+_timeSec;
  Digest sigh = md5.convert(utf8.encode(inputForSign));
  Digest aesKey = sha256.convert(key.bytes);
  print('key: ${key.toString()}, sign: ${sigh.toString()}, aesKey: ${aesKey.toString()}');
  ///calculate command from plain text
  String commandInput = '$token,${sigh.toString()}|$command|,${aesKey.toString()}';
       ///create aes256 representation ECB mode
        Key _key = Key.fromBase64(_keyForAes);
       final encrypter = Encrypter(AES(_key, mode: AESMode.ecb));
    //    var ivBtyes = Uint8List.fromList([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
   //     final iv = encrypt.IV(ivBtyes);
       final encrypted = encrypter.encrypt(commandInput, iv: IV.fromUtf8(aesKey.toString()));
  ///final output
  String finalCommand = base64.encode(encrypted.bytes);
  String result = 'enc|$finalCommand';
  return finalCommand;
}