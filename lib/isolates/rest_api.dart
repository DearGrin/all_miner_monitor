import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http_auth/http_auth.dart';
class RestApi extends GetConnect{

  Future<String>reboot(String ip, List<Map<dynamic,dynamic>>? _credentials) async {
    print('reboot');
   // Box box = await Hive.openBox('settings');
   //List<Map<String,String>> _credentials = [{'root':'root'},{'root':'megapwd'}];
  //  List<Map<String, String>>? c = box.get('ant_passwords');
  //  if(c!=null && c.isNotEmpty){
   //   _credentials = c;
   // }
    _credentials ??= [{'root':'root'}];
    print(_credentials);
    dynamic _callback = 'Unauthorised';
    for(Map<dynamic,dynamic> c in _credentials){
      var client = DigestAuthClient(c.keys.first.toString(), c.values.first.toString());
      final url = Uri.parse('http://$ip/cgi-bin/reboot.cgi');
      var callback = await client.get(url);
      print(callback.body);
      print(callback.body.contains('Unauthorized'));
      if(!callback.body.contains('Unauthorized')){
        _callback = callback.body;
        break;
      }
    }
    return _callback;
    /*
    var client = DigestAuthClient('root', 'megapwd');
    final url = Uri.parse('http://$ip/cgi-bin/reboot.cgi');
    var callback = await client.get(url);
    return callback.body;


     */
    //client.get(url).then((r) => return r.body);
    /*
    print('in rest api');
    String username = 'root';
    String password = 'megapwd';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Map<String,String> pload = {'username':'root','password':'megapwd'};
    var callback = await get('http://$ip/cgi-bin/reboot.cgi');
    print(callback);
    print(callback.runtimeType);
    print(callback.status);
    print(callback.statusText);
    print(callback.headers);
    print(callback.request);
    print(callback.unauthorized);
    print(callback.toString());
    print(callback.body);
    return callback.body.toString();

     */
  }
  Future<String>setPool(String ip, String command) async{
    print('setting pool');
    var client = DigestAuthClient('root', 'megapwd');
    final url = Uri.parse('http://$ip/cgi-bin/set_miner_conf.cgi');
    var callback = await client.post(url, body: command);
   print(callback);
   return callback.body;
 //   var callback = await post('http://root:megapwd@$ip/cgi-bin/set_miner_conf.cgi', command);
  }

  Future<String>test(String ip, String command, List<Map<dynamic,dynamic>>? _credentials) async {
    print('test');
  //  var c = await get('http://192.168.1.131/cgi-bin/reboot.cgi');
 //   print(c);
    _credentials ??= [{'root':'root'}];
    print(_credentials);
    print(command.split(' ').toList());
    List<String> _pools = command.split(' ').toList();
    dynamic _callback = 'Unauthorised';
    for(Map<dynamic,dynamic> c in _credentials){
      var client = DigestAuthClient(c.keys.first.toString(), c.values.first.toString());
      final url = Uri.parse('http://192.168.1.131/cgi-bin/get_miner_conf.cgi');
      var callback = await client.get(url);
      print(callback.body);
      print(callback.body.contains('Unauthorized'));
      if(!callback.body.contains('Unauthorized')){
        print(callback.body.runtimeType);
        Map<String,dynamic> _tmp = jsonDecode(callback.body);
        print(_tmp);
        Map<String,dynamic> _ = {
          '_ant_pool1url':_pools[0],
          '_ant_pool1user':_pools[1],
          '_ant_pool1pw':_pools[2],
          '_ant_pool2url':_pools[3],
          '_ant_pool2user':_pools[4],
          '_ant_pool2pw':_pools[5],
          '_ant_pool3url':_pools[6],
          '_ant_pool3user':_pools[7],
          '_ant_pool3pw':_pools[8],
          '_ant_nobeeper':'false',
          '_ant_notempoverctrl':'false',
          '_ant_fan_mode':'${_tmp['bitmain-fan-mode']}',
          '_ant_fan_customize_value' : '${_tmp['bitmain-fan-pwm']}',
          '_ant_freq' : '${_tmp['bitmain-freq']}',
          '_ant_voltage' : '${_tmp['bitmain-voltage']}',
          '_ant_freq1' : '${_tmp['bitmain-freq1']}',
          '_ant_voltage1' : '${_tmp['bitmain-voltage1']}',
          '_ant_freq2' : '${_tmp['bitmain-freq2']}',
          '_ant_voltage2' : '${_tmp['bitmain-voltage2']}',
          '_ant_freq3' : '${_tmp['bitmain-freq3']}',
          '_ant_voltage3' : '${_tmp['bitmain-voltage3']}',
          '_ant_freq4' : '${_tmp['bitmain-freq4']}',
          '_ant_voltage4' : '${_tmp['bitmain-voltage4']}',
          '_ant_reboot_switch' : 'false',
          '_ant_reboot_asic' : 'false',
          '_ant_daily_fee' : 'false',
        };
        final url2 = Uri.parse('http://$ip/cgi-bin/set_miner_conf.cgi');
        var callback2 = await client.post(url2, body: _,);
        print('and result set pool is ${callback2.body}');
        _callback = callback2.body;
        if(_callback=='ok')
          {
            await reboot(ip, [c]);
          }
        break;
      }
    }
    return _callback;
 //  var client = DigestAuthClient('root', 'megapwd');
 //  print(client);
 // final url = Uri.parse('http://192.168.1.131/cgi-bin/get_miner_conf.cgi');
 //  print(url);
 //  var callback = await client.get(url);
    //var callback = await client.read(url).timeout(Duration(seconds: 10), onTimeout: ()async{print('time out');throw't';});
  //  var callback2 = await client.readBytes(url).timeout(Duration(seconds: 10), onTimeout: ()async{print('time out');throw't';});
 //  print(callback.body);
  //  final url3 = Uri.parse('http://192.168.1.131/cgi-bin/get_auto_freq_conf.cgi');
   // var callback3 = await client.get(url3);
    //print(callback3.body);

    // print('test $ip and $command');
   // var client = DigestAuthClient('root', 'megapwd');
   // final url = Uri.parse('http://$ip/cgi-bin/set_miner_conf.cgi');
   // var callback = await client.post(url, body: command);
   // print(callback);
  }

}