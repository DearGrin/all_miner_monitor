class DevicePool{
  String? url;
  String? worker;
  DevicePool({this.url, this.worker});
  DevicePool.fromString(String data){
   // print(data);
    final RegExp pool = RegExp(r'(POOL=[0-9],)(URL=)(.*?)(User=)(.*?)(|)');
   print(pool.allMatches(data).toList()[0].group(0));
   // List<RegExpMatch> p = _data.allMatches(data).toList();
    //print(p[0].group(0));
    url = '';
    worker = '';
  }
}
class Pools{
  List<DevicePool>? pools;
  Pools({this.pools});
  Pools.fromString(String data){
    final RegExp pool = RegExp(r'(POOL=[0-9],)(URL=)(.*?)(,)(.*?)(User=)(.*?)(,)(.*?)(|)');
    List<DevicePool> _tmp = [];
    var p = pool.allMatches(data).toList();
    if(p.isNotEmpty){
      for(var _p in p){
        _tmp.add(DevicePool(url: _p.group(3), worker: _p.group(7),));
      }
    }
    pools = _tmp;
  }
}