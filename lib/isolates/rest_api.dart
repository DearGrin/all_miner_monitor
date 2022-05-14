import 'package:get/get.dart';

class RestApi extends GetConnect{

  reboot(String ip) async {
    await get('$ip/cgi-bin/reboot.cgi');
  }
  setPool(String ip, String command) async{
    var callback = await post('https://root:root@$ip/cgi-bin/set_miner_conf.cgi', command);
  }
}