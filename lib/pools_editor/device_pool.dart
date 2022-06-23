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

  Future<Pools> fromString(String data)async{
    final RegExp pool = RegExp(r'(POOL=[0-9],)(URL=)(.*?)(,)(.*?)(User=)(.*?)(,)(.*?)(|)');
    List<DevicePool> _tmp = [];
    var p = pool.allMatches(data).toList();
    if(p.isNotEmpty){
      for(var _p in p){
        _tmp.add(DevicePool(url: _p.group(3), worker: _p.group(7),));
      }
    }
    return Pools(pools: _tmp);
  }
  Future<Pools> fromJson(Map<String,dynamic> json)async{
    List<DevicePool>? _pools = [];
    for(var v in json['POOLS']){
      _pools.add(DevicePool(url: v['URL'], worker: v['User']));
    }
    return Pools(pools: _pools);
  }
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
  Pools.fromJson(Map<String,dynamic> json){
    List<DevicePool>? _pools = [];
    for(var v in json['POOLS']){
      _pools.add(DevicePool(url: v['URL'], worker: v['User']));
    }
    pools = _pools;
  }
}