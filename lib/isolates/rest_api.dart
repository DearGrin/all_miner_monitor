import 'dart:convert';
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
  setPool(String ip, String command) async{
 //   var callback = await post('http://root:megapwd@$ip/cgi-bin/set_miner_conf.cgi', command);
  }
}