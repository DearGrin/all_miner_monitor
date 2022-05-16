import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
class RestApi extends GetConnect{

  Future<String>reboot(String ip) async {
    var client = DigestAuthClient('root', 'megapwd');
    final url = Uri.parse('http://$ip/cgi-bin/reboot.cgi');
    var callback = await client.get(url);
    return callback.body;
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
  test(String ip, String command) async {
    print('test');
  //  var c = await get('http://192.168.1.131/cgi-bin/reboot.cgi');
 //   print(c);
   var client = DigestAuthClient('root', 'megapwd');
 //  print(client);
  final url = Uri.parse('http://192.168.1.131/cgi-bin/get_miner_conf.cgi');
 //  print(url);
   var callback = await client.get(url);
    //var callback = await client.read(url).timeout(Duration(seconds: 10), onTimeout: ()async{print('time out');throw't';});
  //  var callback2 = await client.readBytes(url).timeout(Duration(seconds: 10), onTimeout: ()async{print('time out');throw't';});
   print(callback.body);
  //  final url3 = Uri.parse('http://192.168.1.131/cgi-bin/get_auto_freq_conf.cgi');
   // var callback3 = await client.get(url3);
    //print(callback3.body);
    Map<String,dynamic> _ = {
      '_ant_pool1url':'stratum+tcp://ltc.viabtc.top:25',
      '_ant_pool1user':'keyda490.19x90',
      '_ant_pool1pw':'123',
      '_ant_pool2url':'stratum+tcp://ltc.viabtc.top:443',
      '_ant_pool2user':'keyda490.19x90',
      '_ant_pool2pw':'123',
      '_ant_pool3url':'stratum+tcp://ltc.viabtc.top:3333',
      '_ant_pool3user':'keyda490.19x90',
      '_ant_pool3pw':'123',
      '_ant_beeper':'true',
      '_ant_tempoverctrl':'true',
      '_ant_frequency_auto':'',
     //'bitmain-fan-mode' : '',
    //  'bitmain-fan-pwm' : '100',
     // 'bitmain-use-vil' : true,
    //  'bitmain-freq' : '384',
    };
    final url2 = Uri.parse('http://$ip/cgi-bin/set_miner_conf.cgi');
    var callback2 = await client.post(url2, body: _,);
    print(callback2.body);
    // print('test $ip and $command');
   // var client = DigestAuthClient('root', 'megapwd');
   // final url = Uri.parse('http://$ip/cgi-bin/set_miner_conf.cgi');
   // var callback = await client.post(url, body: command);
   // print(callback);
  }
}